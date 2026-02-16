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
import 'cover_letter_page.dart';

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
      context, 'form.education'.tr(), const EducationForm(),
      onNext: () { Navigator.pop(context); _openExperience(context); },
    );
  }

  void _openExperience(BuildContext context) {
    _navigateToSection(
      context, 'form.experience'.tr(), const ExperienceForm(),
      onNext: () { Navigator.pop(context); _openLanguages(context); },
    );
  }

  void _openLanguages(BuildContext context) {
    _navigateToSection(
      context, 'form.languages'.tr(), const LanguagesForm(),
      onNext: () { Navigator.pop(context); _openSkills(context); },
    );
  }

  void _openSkills(BuildContext context) {
    _navigateToSection(
      context, 'form.skills'.tr(), const SkillsForm(),
      onNext: () { Navigator.pop(context); _openCertificates(context); },
    );
  }

  void _openCertificates(BuildContext context) {
    _navigateToSection(
      context, 'form.certificates'.tr(), const CertificatesForm(),
      onNext: () { Navigator.pop(context); _openReferences(context); },
    );
  }

  void _openReferences(BuildContext context) {
    _navigateToSection(
      context, 'form.references'.tr(), const ReferencesForm(),
      onNext: () { Navigator.pop(context); _openActivities(context); },
    );
  }

  void _openActivities(BuildContext context) {
    _navigateToSection(
      context, 'form.activities'.tr(), const ActivitiesForm(),
      onNext: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: Consumer<ResumeProvider>(
            builder: (context, provider, _) {
              return Stack(
                children: [
                  Column(
                    children: [
                      _buildPremiumAppBar(c),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2, padding: const EdgeInsets.all(20),
                          mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.1,
                          children: [
                            SectionCard(
                              title: 'form.personal_info'.tr(), icon: Icons.person_rounded, color: const Color(0xFF6366F1),
                              isCompleted: provider.isPersonalInfoComplete,
                              onTap: () => _navigateToSection(context, 'form.personal_info'.tr(), const PersonalInfoForm(), onNext: () { Navigator.pop(context); _openEducation(context); }),
                            ),
                            SectionCard(
                              title: 'form.education'.tr(), icon: Icons.school_rounded, color: const Color(0xFF059669),
                              isCompleted: provider.isEducationComplete,
                              onTap: () => _navigateToSection(context, 'form.education'.tr(), const EducationForm(), onNext: () { Navigator.pop(context); _openExperience(context); }),
                            ),
                            SectionCard(
                              title: 'form.experience'.tr(), icon: Icons.work_rounded, color: const Color(0xFFF59E0B),
                              isCompleted: provider.isExperienceComplete,
                              onTap: () => _navigateToSection(context, 'form.experience'.tr(), const ExperienceForm(), onNext: () { Navigator.pop(context); _openLanguages(context); }),
                            ),
                            SectionCard(
                              title: 'form.languages'.tr(), icon: Icons.translate_rounded, color: const Color(0xFFEC4899),
                              isCompleted: provider.isLanguagesComplete,
                              onTap: () => _navigateToSection(context, 'form.languages'.tr(), const LanguagesForm(), onNext: () { Navigator.pop(context); _openSkills(context); }),
                            ),
                            SectionCard(
                              title: 'form.skills'.tr(), icon: Icons.psychology_rounded, color: const Color(0xFF8B5CF6),
                              isCompleted: provider.isSkillsComplete,
                              onTap: () => _navigateToSection(context, 'form.skills'.tr(), const SkillsForm(), onNext: () { Navigator.pop(context); _openCertificates(context); }),
                            ),
                            SectionCard(
                              title: 'form.certificates'.tr(), icon: Icons.workspace_premium_rounded, color: c.accent,
                              isCompleted: provider.isCertificatesComplete,
                              onTap: () => _navigateToSection(context, 'form.certificates'.tr(), const CertificatesForm(), onNext: () { Navigator.pop(context); _openReferences(context); }),
                            ),
                            SectionCard(
                              title: 'form.references'.tr(), icon: Icons.people_alt_rounded, color: c.accentGreen,
                              isCompleted: provider.isReferencesComplete,
                              onTap: () => _navigateToSection(context, 'form.references'.tr(), const ReferencesForm(), onNext: () { Navigator.pop(context); _openActivities(context); }),
                            ),
                            SectionCard(
                              title: 'form.activities'.tr(), icon: Icons.volunteer_activism_rounded, color: c.accentOrange,
                              isCompleted: provider.isActivitiesComplete,
                              onTap: () => _navigateToSection(context, 'form.activities'.tr(), const ActivitiesForm(), onNext: () => Navigator.pop(context)),
                            ),
                            SectionCard(
                              title: 'cover_letter.menu_title'.tr(), icon: Icons.description_rounded, color: Colors.indigoAccent,
                              isCompleted: provider.currentResume?.coverLetter != null && provider.currentResume!.coverLetter!.isNotEmpty,
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoverLetterPage())),
                            ),
                          ],
                        ),
                      ),
                      _buildBottomActions(c),
                    ],
                  ),
                  if (provider.isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text('AI Magic in progress...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
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
              onTap: () {
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAIOptions(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'ai_assistant.title'.tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'ai_assistant.subtitle'.tr(),
              style: TextStyle(fontSize: 14, color: c.textSecondary),
            ),
            const SizedBox(height: 24),
            _buildAIOptionTile(
              context,
              icon: Icons.psychology_rounded,
              title: 'ai_assistant.analyze'.tr(),
              subtitle: 'ai_assistant.analyze_desc'.tr(),
              color: Colors.purpleAccent,
              onTap: () {
                Navigator.pop(context);
                context.read<ResumeProvider>().analyzeWithAI();
                _showScoreDetails(context); // Auto open score details to see analysis
              },
            ),
            const SizedBox(height: 12),
            _buildAIOptionTile(
              context,
              icon: Icons.auto_awesome_rounded,
              title: 'ai_assistant.ai_magic'.tr(),
              subtitle: 'ai_assistant.ai_magic_desc'.tr(),
              color: Colors.amber,
              onTap: () async {
                 Navigator.pop(context);
                 _runAIMagic(context);
              },
            ),
            const SizedBox(height: 12),
            _buildAIOptionTile(
              context,
              icon: Icons.bar_chart_rounded,
              title: 'ai_assistant.strength'.tr(),
              subtitle: 'ai_assistant.strength_desc'.tr(),
              color: c.success,
              onTap: () {
                Navigator.pop(context);
                _showScoreDetails(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAIOptionTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    final c = AppColorsDynamic.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.cardBackgroundSolid,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: c.textPrimary)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: c.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: c.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _runAIMagic(BuildContext context) async {
    final c = AppColorsDynamic.of(context); // Capture colors effectively
    final provider = context.read<ResumeProvider>();
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('AI Magic starting... ✨'), backgroundColor: AppColors.primaryStart, duration: Duration(seconds: 2)));
      await provider.optimizeResume();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('AI Magic applied successfully! 🚀'), backgroundColor: c.success));
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Optimization failed: ${e.toString()}'), backgroundColor: c.error));
    }
  }

  Widget _buildActionButton({required String label, required IconData icon, required Gradient gradient, required VoidCallback onTap, bool isAi = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: (gradient.colors.firstOrNull ?? Colors.black).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, borderRadius: BorderRadius.circular(16),
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
      ),
    );
  }

  void _showScoreDetails(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    showModalBottomSheet(
      context: context, backgroundColor: c.surface, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('score.cv_strength_analysis'.tr(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: c.textPrimary)),
                              Text('Complete sections to improve score', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.textSecondary)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(color: scoreColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text('$totalScore/100', style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // AI Analysis Section (Moved Up)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [const Color(0xFF6366F1).withOpacity(0.1), const Color(0xFF8B5CF6).withOpacity(0.05)]),
                          borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 22), const SizedBox(width: 10), Text('score.ai_insights'.tr(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: c.textPrimary))]),
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
                                Wrap(spacing: 8, runSpacing: 8, children: (aiData['missingKeywords'] as List).map((kw) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: c.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: c.warning.withOpacity(0.3))), child: Text('+ $kw', style: TextStyle(color: c.warning, fontSize: 12, fontWeight: FontWeight.w500)))).toList()),
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
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: c.cardBackgroundSolid,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isComplete ? c.success.withOpacity(0.3) : c.cardBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['title'], style: TextStyle(fontWeight: FontWeight.w600, color: itemColor)),
                                  Text('${item['current']}/${item['max']}', style: TextStyle(fontWeight: FontWeight.bold, color: isComplete ? c.success : c.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(value: progress.clamp(0.0, 1.0), backgroundColor: c.background, color: isComplete ? c.success : c.primaryStart, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                              if (!isComplete) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded, size: 14, color: c.warning),
                                    const SizedBox(width: 4),
                                    Flexible(child: Text(item['hint'], style: TextStyle(fontSize: 12, color: c.textSecondary, fontStyle: FontStyle.italic))),
                                  ],
                                ),
                              ],
                            ],
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

  Widget _buildPremiumAppBar(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: c.background.withOpacity(0.5), border: Border(bottom: BorderSide(color: c.cardBorder, width: 1))),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded), style: IconButton.styleFrom(backgroundColor: c.cardBackgroundSolid, foregroundColor: c.textPrimary, padding: const EdgeInsets.all(12))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('CV Maker Pro +', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: c.textPrimary)), Text('Create your professional resume', style: TextStyle(fontSize: 12, color: c.textSecondary))])),
              const SizedBox(width: 8),
              // AI Assistant Trigger (Replaces Save)
              Container(
                decoration: BoxDecoration(
                  gradient: c.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: c.primaryStart.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: IconButton(
                  onPressed: () => _showAIOptions(context),
                  icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  tooltip: 'AI Assistant',
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showScoreDetails(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: c.cardBackgroundSolid, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.cardBorder)),
                    child: Consumer<ResumeProvider>(
                      builder: (context, provider, _) {
                        final score = provider.cvStrength;
                        Color scoreColor = score >= 80 ? c.success : score >= 50 ? c.warning : c.error;
                        return Row(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 24, height: 24, child: CircularProgressIndicator(value: score / 100, backgroundColor: c.cardBorder, color: scoreColor, strokeWidth: 3)), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('$score%', style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 14)), Text('Strength', style: TextStyle(color: c.textSecondary, fontSize: 10))])]);
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
