import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../../core/constants/app_constants.dart';

import '../providers/resume_provider.dart';
import '../widgets/forms/personal_info_form.dart';
import '../widgets/forms/experience_form.dart';
import '../widgets/forms/education_form.dart';
import '../widgets/forms/languages_form.dart';
import '../widgets/forms/skills_form.dart';
import '../widgets/forms/certificates_form.dart';
import '../widgets/forms/references_form.dart';
import '../widgets/forms/activities_form.dart';
import '../widgets/section_card.dart';
import '../../../paywall/presentation/pages/paywall_page.dart';
import '../../../paywall/presentation/providers/premium_provider.dart';
import '../../../paywall/data/services/usage_limit_service.dart';
import '../../data/models/personal_info_model.dart';
import 'section_page.dart';

import 'preview_page.dart';
import 'cover_letter_page.dart';
import '../widgets/forms/summary_form.dart';
import 'home_page.dart';


class ResumeEditPage extends StatefulWidget {
  const ResumeEditPage({super.key});

  @override
  State<ResumeEditPage> createState() => _ResumeEditPageState();
}

class _ResumeEditPageState extends State<ResumeEditPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  
  void _navigateToSection(BuildContext context, String title, Widget form, {VoidCallback? onNext, String? nextLabel, bool showQuickPreview = true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionPage(
          title: title,
          onNext: onNext,
          nextButtonLabel: nextLabel,
          showQuickPreview: showQuickPreview,
          child: form,
        ),
      ),
    ).then((_) {
      // Check for completion celebration or status update if needed
      if (mounted) setState(() {});
    });
  }

  // Helper methods for cleaner navigation logic
  void _openPersonalInfo(BuildContext context) {
    _navigateToSection(
      context, 'form.personal_info'.tr(), const PersonalInfoForm(),
      onNext: () { 
        Navigator.pop(context); 
        _openExperience(context); 
      },
    );
  }

  void _openEducation(BuildContext context) {
    _navigateToSection(
      context, 'form.education'.tr(), const EducationForm(),
      onNext: () { 
        Navigator.pop(context); 
        _openSkills(context); 
      },
    );
  }

  void _openExperience(BuildContext context) {
    _navigateToSection(
      context, 'form.experience'.tr(), const ExperienceForm(),
      onNext: () { 
        Navigator.pop(context); 
        _openEducation(context); 
      },
    );
  }

  void _openLanguages(BuildContext context) {
    _navigateToSection(
      context, 'form.languages'.tr(), const LanguagesForm(),
      onNext: () { 
        Navigator.pop(context); 
        _openSummaryEdit(context, context.read<ResumeProvider>()); 
      },
    );
  }

  void _openSkills(BuildContext context) {
    _navigateToSection(
      context, 'form.skills'.tr(), const SkillsForm(),
      onNext: () { 
        Navigator.pop(context); 
        _openLanguages(context); 
      },
    );
  }

  void _openCertificates(BuildContext context) {
    _navigateToSection(
      context, 'form.certificates'.tr(), const CertificatesForm(),
      onNext: () { Navigator.pop(context); _openActivities(context); },
    );
  }

  void _openReferences(BuildContext context) {
    _navigateToSection(
      context, 'form.references'.tr(), const ReferencesForm(),
      onNext: () => Navigator.pop(context),
    );
  }

  void _openActivities(BuildContext context) {
    _navigateToSection(
      context, 'form.activities'.tr(), const ActivitiesForm(),
      onNext: () {
        Navigator.pop(context);
        _openReferences(context);
      },
    );
  }

  // New helper methods for summary and cover letter
  void _openSummaryEdit(BuildContext context, ResumeProvider provider) {
    _navigateToSection(
      context, 'form.summary'.tr(), const SummaryForm(),
      onNext: () {
        Navigator.pop(context);
        _openCoverLetterEdit(context, provider);
      },
    );
  }

  void _openCoverLetterEdit(BuildContext context, ResumeProvider provider) {
    _navigateToSection(
      context, 'home.cover_letter'.tr(), const CoverLetterPage(),
      showQuickPreview: false,
      onNext: () {
        Navigator.pop(context);
        _openCertificates(context);
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final resume = provider.currentResume;
        if (resume == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Confetti control
        if (_latestResumeId == null || _latestResumeId != resume.id) {
          _latestResumeId = resume.id;
        }

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: c.backgroundGradient),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                      Column(
                        children: [
                          _buildPremiumHeader(context, c, provider),
                          // Scrollable List
                      Expanded(
                        child: ListView(
                           padding: const EdgeInsets.fromLTRB(20, 10, 20, 110),
                          children: [
                            _buildSectionHeader(c, "form.essentials".tr(), Icons.star_rounded),
                            
                            // Personal Info
                            SectionCard(
                              title: 'form.personal_info'.tr(),
                              icon: Icons.person_outline_rounded,
                              color: c.accent,
                              isCompleted: provider.isPersonalInfoComplete,
                              onTap: () => _openPersonalInfo(context),
                            ),

                            // Experience
                            SectionCard(
                              title: 'form.experience'.tr(),
                              icon: Icons.work_outline_rounded,
                              color: c.accentOrange,
                              isCompleted: provider.isExperienceComplete,
                              onTap: () => _openExperience(context),
                            ),

                            // Education
                            SectionCard(
                              title: 'form.education'.tr(),
                              icon: Icons.school_outlined,
                              color: c.accentGreen,
                              isCompleted: provider.isEducationComplete,
                              onTap: () => _openEducation(context),
                            ),
                            
                            // Skills
                            SectionCard(
                              title: 'form.skills'.tr(),
                              icon: Icons.psychology_outlined,
                              color: c.accentPurple,
                              isCompleted: provider.isSkillsComplete,
                              onTap: () => _openSkills(context),
                            ),

                            // Languages
                            SectionCard(
                              title: 'form.languages'.tr(),
                              icon: Icons.language_outlined,
                              color: c.accentPink,
                              isCompleted: provider.isLanguagesComplete,
                              onTap: () => _openLanguages(context),
                            ),

                            // Summary
                            SectionCard(
                              title: 'form.summary'.tr(),
                              icon: Icons.description_outlined,
                              color: c.primaryMid,
                              isCompleted: resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty,
                              onTap: () => _openSummaryEdit(context, provider),
                            ),

                            const SizedBox(height: 20),
                            _buildSectionHeader(c, "form.additional".tr(), Icons.add_circle_outline_rounded),

                             // Cover Letter (Optional)
                            SectionCard(
                              title: 'home.cover_letter'.tr(), 
                              icon: Icons.mark_email_read_outlined,
                              color: Colors.cyan,
                              isCompleted: resume.coverLetter != null && resume.coverLetter!.isNotEmpty,
                              onTap: () => _openCoverLetterEdit(context, provider),
                            ),

                            // Certificates
                            SectionCard(
                              title: 'form.certificates'.tr(),
                              icon: Icons.workspace_premium_outlined,
                              color: Colors.teal,
                              isCompleted: provider.isCertificatesComplete,
                              onTap: () => _openCertificates(context),
                            ),

                            // Activities
                            SectionCard(
                              title: 'form.activities'.tr(),
                              icon: Icons.local_activity_outlined,
                              color: Colors.amber,
                              isCompleted: provider.isActivitiesComplete,
                              onTap: () => _openActivities(context),
                            ),
                            
                            // References
                            SectionCard(
                              title: 'form.references'.tr(),
                              icon: Icons.people_outline_rounded,
                              color: Colors.indigo,
                              isCompleted: provider.isReferencesComplete,
                              onTap: () => _openReferences(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                   // Confetti Overlay
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple
                      ],
                    ),
                  ),

                    if (provider.isLoading)
                      Positioned.fill(
                        child: Container(
                          color: c.background.withValues(alpha: 0.85),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                color: c.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: c.primaryMid.withValues(alpha: 0.3)),
                                boxShadow: [
                                  BoxShadow(
                                    color: c.primaryMid.withValues(alpha: 0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: CircularProgressIndicator(
                                          color: c.primaryMid,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        color: c.accentOrange,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'ai_magic.optimizing'.tr(),
                                    style: TextStyle(
                                      color: c.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                  // ── Footer pinned to bottom ──
                  Positioned(
                    bottom: 50, left: 0, right: 0,
                    child: _buildBottomActions(c),
                  ),

                  // ── Quick Preview floating just above footer ──
                  Positioned(
                    bottom: 173,
                    right: 16,
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
                              color: Colors.black.withValues(alpha: 0.3),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildSectionHeader(AppColorsDynamic c, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.primaryMid),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: c.primaryMid,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(BuildContext context, int score) {
     final c = AppColorsDynamic.of(context);
     if (score >= 80) return c.success;
     if (score >= 50) return c.warning;
     return c.error;
  }
  
  String? _latestResumeId;


  Widget _buildBottomActions(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.cardBorder)),
      ),
      child: Row(
        children: [
          // 1. Preview
          Expanded(
            child: _buildActionButton(
              label: 'cover_letter.preview'.tr(), 
              icon: Icons.visibility_rounded, 
              gradient: c.accentGradient,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PreviewPage(resume: null))),
            ),
          ),
          const SizedBox(width: 12),
          
          // 2. AI Analyze
          Expanded(
            child: _buildActionButton(
              label: 'ai_assistant.analyze'.tr(),
              icon: Icons.psychology_rounded,
              gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.deepPurple]),
              onTap: () async {
                final granted = await _checkAndConsumeAiAccess(
                  context,
                  featureKey: UsageLimitService.featureAiAnalyze,
                );
                if (!granted || !context.mounted) return;
                context.read<ResumeProvider>().analyzeWithAI();
                _showScoreDetails(context);
              },
            ),
          ),
          const SizedBox(width: 12),

          // 3. Save
          Expanded(
            child: _buildActionButton(
              label: 'form.save'.tr(),
              icon: Icons.save_rounded,
              gradient: c.primaryGradient,
              onTap: () async {
                await context.read<ResumeProvider>().saveResume();
                if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('form.save_success'.tr()), backgroundColor: c.success)
                   );
                   _confettiController.play(); // Celebrate save!
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAIMagicSheet(BuildContext context) async {
    final c = AppColorsDynamic.of(context);
    final premium = context.read<PremiumProvider>();
    final provider = context.read<ResumeProvider>();
    final resume = provider.currentResume;

    // 1. Premium check
    if (!premium.isPremium) {
      final purchased = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const PaywallPage()),
      );
      if (purchased != true || !context.mounted) return;
    }

    if (!context.mounted) return;

    // 2. Required fields check
    final name = resume?.personalInfo.fullName ?? '';
    final email = resume?.personalInfo.email ?? '';
    final jobTitle = resume?.personalInfo.targetJobTitle ?? '';
    if (name.isEmpty || email.isEmpty || jobTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ai_assistant.missing_required_fields'.tr()),
          backgroundColor: c.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // 3. Show AI Magic confirmation sheet
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: c.textTertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text(
                'ai_assistant.ai_magic'.tr(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: c.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'ai_assistant.ai_magic_confirm_desc'.tr(),
                style: TextStyle(fontSize: 14, color: c.textSecondary, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFF97316)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final granted = await _checkAndConsumeAiAccess(
                        context,
                        featureKey: UsageLimitService.featureAiOptimize,
                      );
                      if (!granted || !context.mounted) return;
                      _showTargetPositionDialog(context, provider);
                    },
                    icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    label: Text(
                      'ai_assistant.ai_magic_start'.tr(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('form.cancel'.tr(), style: TextStyle(color: c.textSecondary)),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTargetPositionDialog(BuildContext context, ResumeProvider provider) async {
    final c = AppColorsDynamic.of(context);
    final _controller = TextEditingController(text: provider.currentResume?.personalInfo.targetJobTitle ?? '');
    
    // Check if widget is still in tree before showing dialog
    if (!context.mounted) return;

    final targetPosition = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'ai_magic.target_position_title'.tr(), // "What is your target position?"
          style: TextStyle(color: c.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ai_magic.target_position_desc'.tr(), // "Enter the exact position so the AI can optimize better."
              style: TextStyle(color: c.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              style: TextStyle(color: c.textPrimary),
              decoration: InputDecoration(
                hintText: 'ai_magic.target_position_hint'.tr(),
                hintStyle: TextStyle(color: c.textTertiary),
                filled: true,
                fillColor: c.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primaryMid)),
              ),
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (val) => Navigator.pop(ctx, val.trim()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('ai_magic.cancel'.tr(), style: TextStyle(color: c.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, _controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primaryMid,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('ai_magic.start'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (targetPosition != null && targetPosition.isNotEmpty) {
      if (!context.mounted) return;
      // Update the target job title in provider first
      provider.updatePersonalInfo(PersonalInfoModel(
        fullName: provider.currentResume?.personalInfo.fullName ?? '',
        email: provider.currentResume?.personalInfo.email ?? '',
        phone: provider.currentResume?.personalInfo.phone ?? '',
        targetJobTitle: targetPosition,
        address: provider.currentResume?.personalInfo.address,
        linkedinUrl: provider.currentResume?.personalInfo.linkedinUrl,
        websiteUrl: provider.currentResume?.personalInfo.websiteUrl,
        birthDate: provider.currentResume?.personalInfo.birthDate,
        profileImagePath: provider.currentResume?.personalInfo.profileImagePath,
      ));
      
      _runAIMagic(context, provider);
    }
  }

  Future<void> _runAIMagic(BuildContext context, ResumeProvider provider) async {
    final c = AppColorsDynamic.of(context);
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('common.ai_starting'.tr()), backgroundColor: AppColors.primaryStart, duration: const Duration(seconds: 2)));
      await provider.optimizeResume();
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('common.ai_success'.tr()), backgroundColor: c.success));
        _confettiController.play();
        
        // Auto-navigate to preview page
        await Future.delayed(const Duration(milliseconds: 1500)); // Let the user see the success and confetti
        if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PreviewPage(resume: null)),
            );
        }
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('common.ai_failed'.tr(args: [e.toString()])), backgroundColor: c.error));
    }
  }

  /// Returns true if the user is allowed to use an AI feature.
  /// Handles both premium weekly limit and free-trial logic.
  Future<bool> _checkAndConsumeAiAccess(
    BuildContext context, {
    required String featureKey,
  }) async {
    final premium = context.read<PremiumProvider>();

    // ── Premium user ────────────────────────────
    if (premium.isPremium) {
      final ok = await premium.consumeAiCall();
      if (!ok && context.mounted) {
        _showWeeklyLimitDialog(context, premium);
      }
      return ok;
    }

    // ── Free user ────────────────────────────────
    final trialOk = await premium.consumeFreeTrial(featureKey);
    if (trialOk) return true;

    // Free trial exhausted — open paywall
    if (!context.mounted) return false;
    final purchased = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const PaywallPage()),
    );
    return purchased == true;
  }

  void _showWeeklyLimitDialog(BuildContext context, PremiumProvider premium) {
    final c = AppColorsDynamic.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          Text('premium.ai_limit_title'.tr(),
              style: TextStyle(color: c.textPrimary, fontSize: 17)),
        ]),
        content: Text(
          'premium.ai_limit_body'.tr(args: [
            AppConstants.weeklyAiLimitPremium.toString(),
            premium.weeklyAiRemaining.toString(),
          ]),
          style: TextStyle(color: c.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('form.cancel'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required Gradient gradient, required VoidCallback onTap}) {
    return ScaleButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient, borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: (gradient.colors.firstOrNull ?? Colors.black).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  void _showScoreDetails(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    showModalBottomSheet(
      context: context, backgroundColor: c.surface, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: DraggableScrollableSheet(
          initialChildSize: 0.75, maxChildSize: 0.9, minChildSize: 0.4, expand: false,
          builder: (context, scrollController) {
            return Consumer<ResumeProvider>(
              builder: (context, provider, child) {
                final breakdown = provider.scoreBreakdown;
                final totalScore = provider.cvStrength;
                final aiData = provider.aiAnalysis;
                final isAnalyzing = provider.isAnalyzing;
                Color scoreColor = totalScore >= 80 ? c.success : totalScore >= 50 ? c.warning : c.error;

                return Container(
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('score.cv_strength_analysis'.tr(), 
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: c.textPrimary, fontSize: 19),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('score.improve_hint'.tr(), 
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: scoreColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text('$totalScore/100', style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // AI Analysis Section (Moved Up)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [const Color(0xFF6366F1).withValues(alpha: 0.1), const Color(0xFF8B5CF6).withValues(alpha: 0.05)]),
                          borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Builder(
                                  builder: (context) {
                                    String scoreText = "";
                                    if (aiData != null) {
                                      final avg = ((aiData['keywordScore'] ?? 0) + (aiData['actionVerbScore'] ?? 0) + (aiData['overallImpression'] ?? 0)) ~/ 3;
                                      scoreText = avg.toString();
                                    }
                                    return Text(
                                      aiData != null ? 'score.ai_insights'.tr(args: [scoreText]) : 'score.ai_insights'.tr(args: ['---']),
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: c.textPrimary),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ),
                            ]),
                            const SizedBox(height: 12),
                            if (aiData == null && !isAnalyzing)
                              SizedBox(
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(12)),
                                  child: ElevatedButton.icon(
                                    onPressed: () => provider.analyzeWithAI(),
                                    icon: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                                    label: Text('score.ai_analyze'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  ),
                                ),
                              ),
                            if (isAnalyzing) Center(child: Column(children: [const SizedBox(height: 8), const SizedBox(height: 32, width: 32, child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF8B5CF6))), const SizedBox(height: 12), Text('score.analyzing'.tr(), style: TextStyle(color: c.textSecondary, fontSize: 13)), const SizedBox(height: 8)])),
                            if (aiData != null && !isAnalyzing && aiData['error'] == null) ...[
                              _buildAIScoreBar('score.keyword_score'.tr(), aiData['keywordScore'] ?? 0, Icons.key_rounded, c),
                              const SizedBox(height: 10),
                              _buildAIScoreBar('score.action_verbs'.tr(), aiData['actionVerbScore'] ?? 0, Icons.flash_on_rounded, c),
                              const SizedBox(height: 10),
                              _buildAIScoreBar('score.overall'.tr(), aiData['overallImpression'] ?? 0, Icons.star_rounded, c),
                              if (aiData['strengths'] != null && (aiData['strengths'] as List).isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text('score.strengths'.tr(), style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary, fontSize: 14)),
                                const SizedBox(height: 8),
                                ...((aiData['strengths'] as List).map((s) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.check_circle_rounded, color: c.success, size: 16), const SizedBox(width: 8), Flexible(child: Text(s.toString(), style: TextStyle(color: c.textSecondary, fontSize: 13, height: 1.4)))])))),
                              ],
                              if (aiData['missingKeywords'] != null && (aiData['missingKeywords'] as List).isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text('score.missing_keywords'.tr(), style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary, fontSize: 14)),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                    children: (aiData['missingKeywords'] as List).map((kw) {
                                      final keyword = kw.toString();
                                      return ScaleButton(
                                        onTap: () {
                                          Feedback.forTap(context);
                                          provider.addSkill(keyword);
                                          
                                          // Use ScaffoldMessenger of the main context to ensure visibility
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('common.added_to_skills'.tr(args: [keyword])),
                                              backgroundColor: c.success,
                                              behavior: SnackBarBehavior.floating,
                                              duration: const Duration(seconds: 2),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: c.warning.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(25),
                                            border: Border.all(color: c.warning.withValues(alpha: 0.4), width: 1.5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: c.warning.withValues(alpha: 0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.add_rounded, color: c.warning, size: 16),
                                              const SizedBox(width: 4),
                                              Text(keyword, style: TextStyle(color: c.warning, fontSize: 13, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                ),
                              ],
                              if (aiData['suggestions'] != null && (aiData['suggestions'] as List).isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text('score.suggestions'.tr(), style: TextStyle(fontWeight: FontWeight.w600, color: c.textPrimary, fontSize: 14)),
                                const SizedBox(height: 8),
                                ...((aiData['suggestions'] as List).asMap().entries.map((entry) => Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.cardBackgroundSolid, borderRadius: BorderRadius.circular(10), border: Border.all(color: c.cardBorder)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 22, height: 22, alignment: Alignment.center, decoration: BoxDecoration(gradient: c.primaryGradient, borderRadius: BorderRadius.circular(6)), child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))), const SizedBox(width: 10), Flexible(child: Text(entry.value.toString(), style: TextStyle(color: c.textSecondary, fontSize: 13, height: 1.4)))])))),
                              ],
                            ],
                            if (aiData != null && aiData['error'] != null) Text(aiData['error'].toString(), style: TextStyle(color: c.error, fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Section Breakdown
                      ...breakdown.map((item) {
                        final isComplete = item['current'] == item['max'];
                        final progress = (item['current'] as int) / (item['max'] as int);
                        final itemColor = isComplete ? c.success : c.textPrimary;

                        // Title translation
                        final title = (item['title'] as String).tr();

                        // Hint translation
                        String hint = '';
                        if (!isComplete) {
                          final hintKey = item['hint'] as String;
                          final hintArgs = item['hint_args'] as List<dynamic>?;
                          if (hintArgs != null) {
                            final translatedArgs = hintArgs.map((arg) {
                              final s = arg.toString();
                              return s.startsWith('form.') ? s.tr() : s;
                            }).join(', ');
                            hint = hintKey.tr(args: [translatedArgs]);
                          } else {
                            hint = hintKey.tr();
                          }
                        }

                        return ScaleButton(
                          onTap: () {
                            // Navigate based on ID
                            final id = item['id'];
                            if (id == 'personal_info') {
                              _openPersonalInfo(context);
                            } else if (id == 'experience') _openExperience(context);
                            else if (id == 'education') _openEducation(context);
                            else if (id == 'skills') _openSkills(context);
                            else if (id == 'languages') _openLanguages(context);
                            else if (id == 'certificates') _openCertificates(context);
                            else if (id == 'references') _openReferences(context);
                            else if (id == 'activities') _openActivities(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: c.cardBackgroundSolid,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isComplete ? c.success.withValues(alpha: 0.3) : c.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: itemColor)),
                                    Row(
                                      children: [
                                        Text('${item['current']}/${item['max']}', style: TextStyle(fontWeight: FontWeight.bold, color: isComplete ? c.success : c.textSecondary)),
                                        const SizedBox(width: 8),
                                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: c.textTertiary),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(value: progress.clamp(0.0, 1.0), backgroundColor: c.background, color: isComplete ? c.success : c.primaryStart, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                                if (!isComplete && hint.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.info_outline_rounded, size: 14, color: c.warning),
                                      const SizedBox(width: 4),
                                      Flexible(child: Text(hint, style: TextStyle(fontSize: 12, color: c.textSecondary, fontStyle: FontStyle.italic))),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),

                    ],
                  ),
                );
              },
            );
          },
          ),
        );
      },
    );
  }

  Widget _buildAIScoreBar(String label, dynamic score, IconData icon, AppColorsDynamic c) {
    final int scoreVal = (score is int) ? score : (score as num).toInt();
    Color barColor = scoreVal >= 70 ? c.success : scoreVal >= 40 ? c.warning : c.error;
    return Row(
      children: [
        Icon(icon, size: 16, color: barColor),
        const SizedBox(width: 8),
        Expanded(flex: 3, child: Text(label, style: TextStyle(color: c.textPrimary, fontSize: 13, fontWeight: FontWeight.w500))),
        Expanded(flex: 4, child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: scoreVal / 100.0, backgroundColor: c.background, color: barColor, minHeight: 8))),
        const SizedBox(width: 8),
        SizedBox(width: 36, child: Text('$scoreVal', textAlign: TextAlign.right, style: TextStyle(color: barColor, fontWeight: FontWeight.bold, fontSize: 14))),
      ],
    );
  }

  Widget _buildPremiumHeader(BuildContext context, AppColorsDynamic c, ResumeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            style: IconButton.styleFrom(
              backgroundColor: c.cardBackgroundSolid,
              foregroundColor: c.textPrimary,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: c.cardBorder),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CV Maker Pro +',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: c.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'form.subtitle'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // AI Assistant
          Container(
            decoration: BoxDecoration(
              gradient: c.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: c.primaryStart.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: IconButton(
              onPressed: () => _showAIMagicSheet(context),
              icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
              tooltip: 'AI Assistant',
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 12),
          // Strength
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showScoreDetails(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: c.cardBackgroundSolid,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.cardBorder),
                ),
                child: Builder(
                  builder: (context) {
                    final score = provider.cvStrength;
                    Color scoreColor = score >= 80 ? c.success : score >= 50 ? c.warning : c.error;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            value: score / 100,
                            backgroundColor: c.cardBorder,
                            color: scoreColor,
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score%',
                              style: TextStyle(
                                color: scoreColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Strength',
                              style: TextStyle(
                                color: c.textSecondary,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
