import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/scale_button.dart';
import '../providers/resume_provider.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'resume_edit_page.dart';
import 'template_gallery_page.dart';
import '../../data/models/template_data.dart';
import '../../../onboarding/presentation/pages/cv_choice_page.dart';
import '../../../paywall/presentation/pages/paywall_page.dart';
import '../../../paywall/presentation/providers/premium_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResumeProvider>().loadResumes();
    });
  }

  String get _greetingMessage {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'home.good_morning'.tr();
    if (hour < 18) return 'home.good_afternoon'.tr();
    return 'home.good_evening'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    final isRoot = !Navigator.canPop(context);
    
    return PopScope(
      canPop: !isRoot,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CVChoicePage()),
        );
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: c.backgroundGradient,
          ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, c),
              const SizedBox(height: 10),
              // Template Carousel (Showcase)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "home.popular_templates".tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateGalleryPage())),
                      child: Text(
                        "home.see_all".tr(),
                        style: TextStyle(color: c.primaryStart, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 180, // Increased height for better visuals
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  children: TemplateData.templates
                      .where((t) => ['modern', 'classic', 'creative', 'simple'].contains(t['id']))
                      .map((t) {
                    return _buildTemplateCard(context, c, t);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              
              Expanded(
                child: Consumer<ResumeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(c.primaryStart),
                        ),
                      );
                    }

                    if (provider.resumes.isEmpty) {
                      return _buildEmptyState(context, c);
                    }

                    return AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80), // Bottom padding for FAB
                        itemCount: provider.resumes.length,
                        itemBuilder: (context, index) {
                          final resume = provider.resumes[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: _buildResumeCard(context, resume, provider, c),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleButton(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: c.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: c.primaryStart.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                "home.create_new".tr(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CVChoicePage()),
          );
        },
      ),
    ));
  }

  Widget _buildHeader(BuildContext context, AppColorsDynamic c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (Navigator.canPop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ScaleButton(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.cardBackgroundSolid,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.cardBorder),
                      ),
                      child: Icon(Icons.arrow_back_rounded, color: c.textPrimary, size: 22),
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greetingMessage,',
                    style: TextStyle(fontSize: 14, color: c.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'home.ready_to_succeed'.tr(), // Motivating subtitle
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: c.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ScaleButton(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: c.cardBackgroundSolid,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.cardBorder),
              ),
              child: Icon(Icons.settings_outlined, color: c.textPrimary, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, AppColorsDynamic c, Map<String, dynamic> template) {
    final title = template['name'].toString().tr();
    final color = template['color'] as Color;
    final image = template['image'] as String;

    return ScaleButton(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateGalleryPage()));
      },
      child: Container(
        width: 120, // Slightly wider
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: c.cardBackgroundSolid,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.cardBorder),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                title,
                style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppColorsDynamic c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: c.cardBackgroundSolid,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: c.cardBorder),
            boxShadow: c.isDark ? [] : [
              BoxShadow(
                color: c.primaryStart.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Glowing Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: c.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: c.primaryStart.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.note_add_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                "home.no_resumes".tr(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: c.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                "home.start_journey_desc".tr(),
                style: TextStyle(
                  fontSize: 15,
                  color: c.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Primary CTA Button
              ScaleButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CVChoicePage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: c.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: c.primaryStart.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "home.create_new".tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(AppColorsDynamic c, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: c.success),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: c.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildResumeCard(BuildContext context, dynamic resume, ResumeProvider provider, AppColorsDynamic c) {
    return ScaleButton(
      onTap: () {
        provider.loadResume(resume);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResumeEditPage()),
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: c.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  image: (resume.personalInfo.profileImagePath != null &&
                          resume.personalInfo.profileImagePath!.isNotEmpty)
                      ? DecorationImage(
                          image: FileImage(
                              File(resume.personalInfo.profileImagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (resume.personalInfo.profileImagePath != null &&
                        resume.personalInfo.profileImagePath!.isNotEmpty)
                    ? null
                    : const Icon(Icons.person_rounded, color: Colors.white),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resume.personalInfo.fullName.isEmpty
                        ? 'home.untitled_cv'.tr()
                        : resume.personalInfo.fullName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${"template_names.${resume.templateId}.name".tr()} - ${DateFormat.yMMMd().format(resume.updatedAt)}',
                    style: TextStyle(fontSize: 13, color: c.textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _confirmDelete(context, resume.id, provider),
              icon: Icon(Icons.delete_outline_rounded, color: c.error),
            ),
            IconButton(
              onPressed: () {
                provider.loadResume(resume);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ResumeEditPage()),
                );
              },
              icon: Icon(Icons.edit_note_rounded, color: c.primaryStart),
            ),
            IconButton(
              onPressed: () async {
                final isPremium = context.read<PremiumProvider>().isPremium;
                if (!isPremium) {
                  final purchased = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (_) => const PaywallPage()),
                  );
                  if (!context.mounted) return;
                  if (purchased != true && !context.read<PremiumProvider>().isPremium) {
                    return;
                  }
                }
                if (context.mounted) {
                  provider.shareResume(resume);
                }
              },
              icon: Icon(Icons.send_rounded, color: c.accent),
            ),
          ],
        ),
      ),
    ));
  }

  void _confirmDelete(BuildContext context, String id, ResumeProvider provider) {
    final c = AppColorsDynamic.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.surface,
        title: Text('form.delete'.tr()),
        content: Text('home.delete_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('form.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              provider.deleteResume(id);
              Navigator.pop(context);
            },
            child: Text('form.delete'.tr(), style: TextStyle(color: c.error)),
          ),
        ],
      ),
    );
  }
}
