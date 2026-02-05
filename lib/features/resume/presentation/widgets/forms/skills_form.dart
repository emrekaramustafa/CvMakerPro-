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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          labelText: 'form.add_skill'.tr(),
                          hintText: 'form.skill_hint'.tr(),
                          prefixIcon: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [AppColors.accentOrange, Color(0xFFEF4444)],
                            ).createShader(bounds),
                            child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 22),
                          ),
                          filled: true,
                          fillColor: AppColors.cardBackgroundSolid,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.accentOrange, width: 2),
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
                      gradient: const LinearGradient(
                        colors: [AppColors.accentOrange, Color(0xFFEF4444)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentOrange.withOpacity(0.4),
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
              const SizedBox(height: 28),
              
              // Skills Display
              if (skills.isEmpty)
                _buildEmptyState()
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: skills.map((skill) => _buildSkillChip(skill)).toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.accentOrange, Color(0xFFEF4444)],
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
              'form.skills'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your skills above',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cardBackgroundSolid,
            AppColors.cardBackgroundSolid.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.accentOrange, Color(0xFFEF4444)],
                  ).createShader(bounds),
                  child: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeSkill(skill),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.error,
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
