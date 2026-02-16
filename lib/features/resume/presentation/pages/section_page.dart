import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../../core/theme/app_colors.dart';

class SectionPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onNext;
  final String? nextButtonLabel;

  const SectionPage({
    super.key,
    required this.title,
    required this.child,
    this.onNext,
    this.nextButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
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
              color: c.background.withOpacity(0.8),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.textPrimary),
          onPressed: () => Navigator.pop(context),
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
                          color: c.primaryStart.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onNext,
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
    );
  }
}
