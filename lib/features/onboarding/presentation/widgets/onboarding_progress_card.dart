import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resume/presentation/providers/resume_provider.dart';

class OnboardingProgressCard extends StatelessWidget {
  const OnboardingProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    final provider = context.watch<ResumeProvider>();
    
    // Don't show if there are already multiple resumes or everything is complete
    if (provider.resumes.length > 1 || provider.onboardingProgress >= 1.0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.cardBorder),
        boxShadow: [
          BoxShadow(
            color: c.primaryStart.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: c.primaryStart.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.rocket_launch_rounded, color: c.primaryStart, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'onboarding_checklist.title'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: provider.onboardingProgress,
                          backgroundColor: c.isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                          valueColor: AlwaysStoppedAnimation<Color>(c.primaryStart),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(provider.onboardingProgress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: c.primaryStart,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildCheckItem(
            context,
            'onboarding_checklist.step_template'.tr(),
            provider.hasSelectedTemplate,
            c,
          ),
          _buildCheckItem(
            context,
            'onboarding_checklist.step_info'.tr(),
            provider.hasAddedPersonalInfo,
            c,
          ),
          _buildCheckItem(
            context,
            'onboarding_checklist.step_experience'.tr(),
            provider.hasAddedExperience,
            c,
          ),
          _buildCheckItem(
            context,
            'onboarding_checklist.step_ai'.tr(),
            provider.hasCheckedAI,
            c,
          ),
          _buildCheckItem(
            context,
            'onboarding_checklist.step_pdf'.tr(),
            provider.hasExportedPDF,
            c,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String title, bool isDone, AppColorsDynamic c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDone ? c.success.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone ? c.success : c.textMuted.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: isDone
                ? Icon(Icons.check_rounded, size: 14, color: c.success)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDone ? c.textPrimary : c.textSecondary,
              fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
              decoration: isDone ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }
}
