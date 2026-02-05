import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../../../core/theme/app_colors.dart';
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
import 'section_page.dart';
import 'preview_page.dart';

class ResumeEditPage extends StatefulWidget {
  const ResumeEditPage({super.key});

  @override
  State<ResumeEditPage> createState() => _ResumeEditPageState();
}

class _ResumeEditPageState extends State<ResumeEditPage> {
  
  void _navigateToSection(BuildContext context, String title, Widget form, {VoidCallback? onNext, String? nextLabel}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionPage(
          title: title,
          onNext: onNext,
          nextButtonLabel: nextLabel,
          child: form,
        ),
      ),
    );
  }

  // Helper methods for cleaner navigation logic
  void _openEducation(BuildContext context) {
    _navigateToSection(
      context,
      'form.education'.tr(),
      const EducationForm(),
      onNext: () {
        Navigator.pop(context);
        _openExperience(context);
      },
    );
  }

  void _openExperience(BuildContext context) {
    _navigateToSection(
      context,
      'form.experience'.tr(),
      const ExperienceForm(),
      onNext: () {
        Navigator.pop(context);
        _openLanguages(context);
      },
    );
  }

  void _openLanguages(BuildContext context) {
    _navigateToSection(
      context,
      'form.languages'.tr(),
      const LanguagesForm(),
      onNext: () {
        Navigator.pop(context);
        _openSkills(context);
      },
    );
  }

  void _openSkills(BuildContext context) {
    _navigateToSection(
      context,
      'form.skills'.tr(),
      const SkillsForm(),
      onNext: () {
        Navigator.pop(context);
        _openCertificates(context);
      },
    );
  }

  void _openCertificates(BuildContext context) {
    _navigateToSection(
      context,
      'form.certificates'.tr(),
      const CertificatesForm(),
      onNext: () {
        Navigator.pop(context);
        _openReferences(context);
      },
    );
  }

  void _openReferences(BuildContext context) {
    _navigateToSection(
      context,
      'form.references'.tr(),
      const ReferencesForm(),
      onNext: () {
        Navigator.pop(context);
        _openActivities(context);
      },
    );
  }

  void _openActivities(BuildContext context) {
    _navigateToSection(
      context,
      'form.activities'.tr(),
      const ActivitiesForm(),
      nextLabel: 'Finish',
      onNext: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Premium AppBar
              _buildPremiumAppBar(),
              
              // Grid Content
              Expanded(
                child: Consumer<ResumeProvider>(
                  builder: (context, provider, child) {
                    return GridView.count(
                      crossAxisCount: 2,
                      padding: const EdgeInsets.all(20),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        // 1. Personal Info
                        SectionCard(
                          title: 'form.personal_info'.tr(),
                          icon: Icons.person_rounded,
                          color: const Color(0xFF6366F1), // Indigo
                          isCompleted: provider.isPersonalInfoComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.personal_info'.tr(),
                            const PersonalInfoForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openEducation(context);
                            },
                          ),
                        ),

                        // 2. Education
                        SectionCard(
                          title: 'form.education'.tr(),
                          icon: Icons.school_rounded,
                          color: const Color(0xFF059669), // Emerald
                          isCompleted: provider.isEducationComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.education'.tr(),
                            const EducationForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openExperience(context);
                            },
                          ),
                        ),

                        // 3. Experience
                        SectionCard(
                          title: 'form.experience'.tr(),
                          icon: Icons.work_rounded,
                          color: const Color(0xFFF59E0B), // Amber
                          isCompleted: provider.isExperienceComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.experience'.tr(),
                            const ExperienceForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openLanguages(context);
                            },
                          ),
                        ),

                        // 4. Languages
                        SectionCard(
                          title: 'form.languages'.tr(),
                          icon: Icons.translate_rounded,
                          color: const Color(0xFFEC4899), // Pink
                          isCompleted: provider.isLanguagesComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.languages'.tr(),
                            const LanguagesForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openSkills(context);
                            },
                          ),
                        ),

                        // 5. Skills
                        SectionCard(
                          title: 'form.skills'.tr(),
                          icon: Icons.psychology_rounded,
                          color: const Color(0xFF8B5CF6), // Violet
                          isCompleted: provider.isSkillsComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.skills'.tr(),
                            const SkillsForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openCertificates(context);
                            },
                          ),
                        ),

                        // 6. Certificates
                        SectionCard(
                          title: 'form.certificates'.tr(),
                          icon: Icons.workspace_premium_rounded,
                          color: AppColors.accent, // Cyan
                          isCompleted: provider.isCertificatesComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.certificates'.tr(),
                            const CertificatesForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openReferences(context);
                            },
                          ),
                        ),

                        // 7. References
                        SectionCard(
                          title: 'form.references'.tr(),
                          icon: Icons.people_alt_rounded,
                          color: AppColors.accentGreen, // Green
                          isCompleted: provider.isReferencesComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.references'.tr(),
                            const ReferencesForm(),
                            onNext: () {
                              Navigator.pop(context);
                              _openActivities(context);
                            },
                          ),
                        ),

                        // 8. Activities (Social & Hobbies)
                        SectionCard(
                          title: 'form.activities'.tr(),
                          icon: Icons.volunteer_activism_rounded,
                          color: AppColors.accentOrange, // Orange
                          isCompleted: provider.isActivitiesComplete,
                          onTap: () => _navigateToSection(
                            context,
                            'form.activities'.tr(),
                            const ActivitiesForm(),
                            nextLabel: 'Finish',
                            onNext: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Bottom Actions
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.8), // subtle background
        border: const Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Preview PDF (Left)
          _buildActionButton(
            label: 'Preview PDF',
            icon: Icons.visibility_rounded,
            gradient: AppColors.accentGradient,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreviewPage(resume: null)),
              );
            },
          ),
          
          // 2. AI Optimize (Right)
          Consumer<ResumeProvider>(
            builder: (context, provider, _) {
              final strength = provider.cvStrength;
              final isUnlocked = strength > 70;
              
              return _buildActionButton(
                label: 'AI Magic',
                icon: isUnlocked ? Icons.auto_awesome_rounded : Icons.lock_rounded,
                isAi: true, // Tag to handle specific styling if needed
                gradient: isUnlocked 
                  ? AppColors.primaryGradient 
                  : const LinearGradient(colors: [Colors.grey, Colors.grey]), // Disabled look
                onTap: () {
                  if (isUnlocked) {
                    provider.optimizeResume();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reach 70% Strength to unlock AI Magic! (Current: $strength%)'),
                        backgroundColor: AppColors.warning,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
    bool isAi = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (gradient.colors.firstOrNull ?? Colors.black).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            constraints: const BoxConstraints(minWidth: 140), // Ensure equal/similar width
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScoreDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer<ResumeProvider>(
          builder: (context, provider, child) {
            final breakdown = provider.scoreBreakdown;
            final totalScore = provider.cvStrength;
             
            Color scoreColor;
            if (totalScore >= 80) {
              scoreColor = AppColors.success;
            } else if (totalScore >= 50) {
              scoreColor = AppColors.warning;
            } else {
              scoreColor = AppColors.error;
            }

            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CV Strength',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Complete sections to improve score',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: scoreColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$totalScore/100',
                          style: TextStyle(
                            color: scoreColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // List
                  Expanded(
                    child: ListView.separated(
                      itemCount: breakdown.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = breakdown[index];
                        final isComplete = item['current'] == item['max'];
                        final progress = (item['current'] as int) / (item['max'] as int);
                        final itemColor = isComplete ? AppColors.success : AppColors.textPrimary;
                        
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundSolid,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isComplete ? AppColors.success.withOpacity(0.3) : AppColors.cardBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: itemColor,
                                    ),
                                  ),
                                  Text(
                                    '${item['current']}/${item['max']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isComplete ? AppColors.success : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                backgroundColor: AppColors.background,
                                color: isComplete ? AppColors.success : AppColors.primaryStart, // Using primary for progress
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              if (!isComplete) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warning),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['hint'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        border: const Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: ClipRRect( 
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.cardBackgroundSolid,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CV Maker Pro +',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Create your professional resume',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Score Indicator
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showScoreDetails(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundSolid,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Consumer<ResumeProvider>(
                      builder: (context, provider, _) {
                        final score = provider.cvStrength;
                        Color scoreColor;
                        if (score >= 80) {
                          scoreColor = AppColors.success;
                        } else if (score >= 50) {
                          scoreColor = AppColors.warning;
                        } else {
                          scoreColor = AppColors.error;
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: score / 100,
                                backgroundColor: AppColors.cardBorder,
                                color: scoreColor,
                                strokeWidth: 3,
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
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Strength',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
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
        ),
      ),
    );
  }


}
