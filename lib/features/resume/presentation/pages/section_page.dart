import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/scale_button.dart';

import 'preview_page.dart';
import 'home_page.dart';
import '../providers/resume_provider.dart';

class SectionPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onNext;
  final String? nextButtonLabel;
  final bool showQuickPreview;

  const SectionPage({
    super.key,
    required this.title,
    required this.child,
    this.onNext,
    this.nextButtonLabel,
    this.showQuickPreview = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    
    Future<bool> handleBackPress() async {
      // Check if not at root
      if (!Navigator.canPop(context)) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
        return false;
      }

      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: c.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'form.unsaved_changes_title'.tr(),
            style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'form.unsaved_changes_desc'.tr(),
            style: TextStyle(color: c.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true), // pop dialog, let caller know to pop without save
              child: Text('form.discard'.tr(), style: TextStyle(color: c.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primaryStart,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                // Save and pop
                await context.read<ResumeProvider>().saveResume();
                if (dialogContext.mounted) {
                   Navigator.pop(dialogContext, true);
                }
              },
              child: Text('form.save'.tr(), style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      return shouldPop ?? false;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await handleBackPress();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: c.textPrimary),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: c.background.withValues(alpha: 0.8),
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.textPrimary),
            onPressed: () async {
              final bool shouldPop = await handleBackPress();
              if (shouldPop && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: c.backgroundGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Wrap child with padding to avoid button overlap
              Padding(
                padding: EdgeInsets.only(bottom: onNext != null ? 100 : 0),
                child: child,
              ),
              
              if (onNext != null)
                Positioned(
                  bottom: 24,
                  right: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: c.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: c.primaryStart.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (onNext != null) onNext!();
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                nextButtonLabel ?? 'form.save_and_continue'.tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: showQuickPreview ? Padding(
        padding: EdgeInsets.only(bottom: onNext != null ? 82 : 16),
        child: ScaleButton(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PreviewPage(resume: null)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: c.success,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.visibility_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'form.quick_preview'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
    );
  }
}
