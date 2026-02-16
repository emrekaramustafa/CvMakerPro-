import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/language_entry.dart';

class LanguagesForm extends StatelessWidget {
  const LanguagesForm({super.key});

  // Language Proficiency Levels
  static const List<Map<String, dynamic>> proficiencyLevels = [
    {'id': 'native', 'nameKey': 'form.lang_native', 'color': Color(0xFF059669)},
    {'id': 'fluent', 'nameKey': 'form.lang_fluent', 'color': Color(0xFF2563EB)},
    {'id': 'advanced', 'nameKey': 'form.lang_advanced', 'color': Color(0xFF7C3AED)},
    {'id': 'intermediate', 'nameKey': 'form.lang_intermediate', 'color': Color(0xFFF59E0B)},
    {'id': 'basic', 'nameKey': 'form.lang_basic', 'color': Color(0xFFEC4899)},
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final languages = provider.languages;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Language Button
              _buildAddLanguageButton(context, c),
              
              const SizedBox(height: 24),
              
              // Languages List
              if (languages.isNotEmpty) ...[
                Text(
                  'form.languages_list'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...languages.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLanguageCard(context, entry.value, entry.key, c),
                  );
                }).toList(),
              ] else ...[
                _buildEmptyState(c),
              ],
              
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddLanguageButton(BuildContext context, AppColorsDynamic c) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: c.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: c.primaryStart.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageDialog(context),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.translate_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(
                  'form.add_language'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorsDynamic c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: c.primaryStart.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.translate_rounded,
              color: c.primaryStart,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'form.no_languages'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'form.no_languages_desc'.tr(),
            style: TextStyle(
              fontSize: 14,
              color: c.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, LanguageEntry lang, int index, AppColorsDynamic c) {
    // Find level color
    Color levelColor = c.accentGreen;
    for (var level in proficiencyLevels) {
      if (level['id'] == lang.level) {
        levelColor = level['color'] as Color;
        break;
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.cardBorder),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageDialog(context, language: lang, index: index),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.translate_rounded,
                    color: levelColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.languageName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: levelColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'form.lang_${lang.level}'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: levelColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  onPressed: () {
                    context.read<ResumeProvider>().deleteLanguage(index);
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: c.error,
                  iconSize: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, {LanguageEntry? language, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LanguageEditDialog(language: language, index: index),
    );
  }
}

class LanguageEditDialog extends StatefulWidget {
  final LanguageEntry? language;
  final int? index;

  const LanguageEditDialog({super.key, this.language, this.index});

  @override
  State<LanguageEditDialog> createState() => _LanguageEditDialogState();
}

class _LanguageEditDialogState extends State<LanguageEditDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLanguage;
  String _selectedLevel = 'intermediate';

  static const List<String> _commonLanguages = [
    'Turkish', 'English', 'German', 'Spanish', 
    'French', 'Italian', 'Portuguese', 'Russian', 
    'Chinese', 'Japanese', 'Arabic', 'Dutch', 
    'Korean', 'Hindi', 'Swedish', 'Norwegian', 
    'Danish', 'Finnish', 'Polish', 'Greek',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.language?.languageName;
    _selectedLevel = widget.language?.level ?? 'intermediate';
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: c.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      widget.language == null ? 'form.add_language'.tr() : 'form.edit_language'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Language Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: 'form.language_name'.tr(),
                      hintText: 'form.language_hint'.tr(),
                      labelStyle: TextStyle(color: c.textSecondary),
                      prefixIcon: Icon(Icons.translate_rounded, color: c.primaryStart, size: 22),
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
                        borderSide: BorderSide(color: c.primaryStart, width: 2),
                      ),
                    ),
                    items: _commonLanguages.map((lang) {
                      return DropdownMenuItem(
                        value: lang,
                        child: Text(lang, style: TextStyle(color: c.textPrimary)),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedLanguage = val),
                    validator: (v) => v == null || v.isEmpty ? 'form.required'.tr() : null,
                    dropdownColor: c.cardBackground,
                  ),
                  const SizedBox(height: 20),
                  
                  // Proficiency Level Selection
                  Text(
                    'form.proficiency_level'.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Level Options
                  ...LanguagesForm.proficiencyLevels.map((level) {
                    final isSelected = level['id'] == _selectedLevel;
                    final color = level['color'] as Color;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedLevel = level['id']),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withOpacity(0.15) : c.cardBackgroundSolid,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? color : c.cardBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? color : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? color : c.textMuted,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected 
                                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                                  : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                (level['nameKey'] as String).tr(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  color: isSelected ? color : c.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  
                  const SizedBox(height: 20),
                  
                  // Save Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: c.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: c.primaryStart.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _saveLanguage,
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              'form.save'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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
        ],
      ),
    );
  }

  void _saveLanguage() {
    if (_formKey.currentState!.validate()) {
      final newLang = LanguageEntry(
        languageName: _selectedLanguage!,
        level: _selectedLevel,
      );
      
      final provider = context.read<ResumeProvider>();
      if (widget.index != null) {
        provider.updateLanguage(widget.index!, newLang);
      } else {
        provider.addLanguage(newLang);
      }
      
      Navigator.pop(context);
    }
  }
}
