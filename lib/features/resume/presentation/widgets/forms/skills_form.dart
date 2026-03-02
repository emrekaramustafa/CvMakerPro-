import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';

class SkillsForm extends StatefulWidget {
  const SkillsForm({super.key});

  @override
  State<SkillsForm> createState() => _SkillsFormState();
}

class _SkillsFormState extends State<SkillsForm> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _addSkill() {
    if (_controller.text.trim().isEmpty) return;
    
    final provider = context.read<ResumeProvider>();
    final currentSkills = List<String>.from(provider.currentResume?.skills ?? []);
    
    if (!currentSkills.contains(_controller.text.trim())) {
      currentSkills.add(_controller.text.trim());
      provider.updateSkills(currentSkills);
    }
    
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _removeSkill(String skill) {
    final provider = context.read<ResumeProvider>();
    final currentSkills = List<String>.from(provider.currentResume?.skills ?? []);
    
    currentSkills.remove(skill);
    provider.updateSkills(currentSkills);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final skills = provider.currentResume?.skills ?? [];
        
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Input Field
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: c.isDark ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ] : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: 'form.add_skill'.tr(),
                          hintText: 'form.skill_hint'.tr(),
                          labelStyle: TextStyle(color: c.textSecondary),
                          hintStyle: TextStyle(color: c.textTertiary),
                          prefixIcon: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [c.accentOrange, const Color(0xFFEF4444)],
                            ).createShader(bounds),
                            child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 22),
                          ),
                          filled: true,
                          fillColor: c.cardBackgroundSolid,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: c.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: c.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: c.accentOrange, width: 2),
                          ),
                        ),
                        onSubmitted: (_) => _addSkill(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Premium Add Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [c.accentOrange, const Color(0xFFEF4444)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: c.accentOrange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _addSkill,
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Icon(Icons.add_rounded, color: Colors.white, size: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSuggestedSkills(c, skills),
              const SizedBox(height: 24),
              
              // Skills Display
              if (skills.isEmpty)
                _buildEmptyState(c)
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: skills.map((skill) => _buildSkillChip(skill, c)).toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestedSkills(AppColorsDynamic c, List<String> currentSkills) {
    final suggestedKeys = [
      'form.suggested_teamwork',
      'form.suggested_discipline',
      'form.suggested_communication',
    ];

    // Translate the keys first
    final suggested = suggestedKeys.map((key) => key.tr()).toList();
    // Filter out ones already in the list (case-insensitive check)
    final toShow = suggested.where((s) {
      return !currentSkills.any((cs) => cs.toLowerCase() == s.toLowerCase());
    }).toList();

    if (toShow.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'form.suggestions'.tr(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.textTertiary,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: toShow.map((skill) {
            return GestureDetector(
              onTap: () {
                final provider = context.read<ResumeProvider>();
                final updatedSkills = List<String>.from(provider.currentResume?.skills ?? []);
                updatedSkills.add(skill);
                provider.updateSkills(updatedSkills);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: c.primaryStart.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: c.primaryStart.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 16, color: c.primaryStart),
                    const SizedBox(width: 4),
                    Text(
                      skill,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.primaryStart,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppColorsDynamic c) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: c.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: c.cardBorder),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [c.accentOrange, const Color(0xFFEF4444)],
                ).createShader(bounds),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'form.no_skills'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'form.no_skills_desc'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: c.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill, AppColorsDynamic c) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            c.cardBackgroundSolid,
            c.cardBackgroundSolid.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [c.accentOrange, const Color(0xFFEF4444)],
                  ).createShader(bounds),
                  child: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  skill,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeSkill(skill),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: c.error.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: c.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
