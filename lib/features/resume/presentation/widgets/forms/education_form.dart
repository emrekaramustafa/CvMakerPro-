import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/education_model.dart';
import 'package:intl/intl.dart';

class EducationForm extends StatelessWidget {
  const EducationForm({super.key});

  // Education Levels
  static const List<Map<String, dynamic>> educationLevels = [
    {'id': 'phd', 'nameKey': 'form.edu_phd', 'icon': Icons.psychology_rounded, 'color': Color(0xFF7C3AED)},
    {'id': 'masters', 'nameKey': 'form.edu_masters', 'icon': Icons.workspace_premium_rounded, 'color': Color(0xFF2563EB)},
    {'id': 'bachelors', 'nameKey': 'form.edu_bachelors', 'icon': Icons.school_rounded, 'color': Color(0xFF059669)},
    {'id': 'high_school', 'nameKey': 'form.edu_high_school', 'icon': Icons.menu_book_rounded, 'color': Color(0xFFF59E0B)},
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final educationList = provider.currentResume?.education ?? [];
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Education Level Buttons
              Text(
                'form.add_education'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Level Buttons - Vertical Full Width
              Column(
                children: educationLevels.map((level) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildLevelButton(context, level, c),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Education List
              if (educationList.isNotEmpty) ...[
                Text(
                  'form.education_list'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...educationList.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEducationCard(context, entry.value, entry.key, c),
                  );
                }).toList(),
              ] else ...[
                const SizedBox(height: 32),
                _buildEmptyState(context, c),
              ],
              
              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelButton(BuildContext context, Map<String, dynamic> level, AppColorsDynamic c) {
    final color = level['color'] as Color;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEducationDialog(context, degreeLevel: level),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    level['icon'] as IconData,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '+ ${(level['nameKey'] as String).tr()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color.withOpacity(0.6),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard(BuildContext context, EducationModel edu, int index, AppColorsDynamic c) {
    // Find matching level color
    Color levelColor = c.accentGreen;
    for (var level in educationLevels) {
      if (edu.degree.toLowerCase().contains(level['id']) ||
          (level['nameKey'] as String).tr().toLowerCase() == edu.degree.toLowerCase()) {
        levelColor = level['color'] as Color;
        break;
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.cardBorder, width: 1),
        boxShadow: c.isDark ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEducationDialog(context, education: edu, index: index),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: levelColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        edu.institutionName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${edu.degree} • ${edu.fieldOfStudy}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: c.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: levelColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${DateFormat.y().format(edu.startDate)} - ${edu.isCurrent ? 'form.present'.tr() : (edu.endDate != null ? DateFormat.y().format(edu.endDate!) : 'form.present'.tr())}',
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
                // Edit Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: c.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: c.textTertiary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEducationDialog(BuildContext context, {EducationModel? education, int? index, Map<String, dynamic>? degreeLevel}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EducationEditDialog(
        education: education,
        index: index,
        degreeLevel: degreeLevel,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppColorsDynamic c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school_rounded,
              size: 40,
              color: c.textTertiary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'form.no_education'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'form.no_education_desc'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: c.textTertiary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EducationEditDialog extends StatefulWidget {
  final EducationModel? education;
  final int? index;
  final Map<String, dynamic>? degreeLevel;

  const EducationEditDialog({super.key, this.education, this.index, this.degreeLevel});

  @override
  State<EducationEditDialog> createState() => _EducationEditDialogState();
}

class _EducationEditDialogState extends State<EducationEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _institutionController;
  late TextEditingController _degreeController;
  late TextEditingController _fieldController;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isCurrent = false;
  late Color _levelColor;

  @override
  void initState() {
    super.initState();
    _institutionController = TextEditingController(text: widget.education?.institutionName);
    
    // Pre-fill degree from level selection
    String degreeText = widget.education?.degree ?? '';
    if (widget.degreeLevel != null && degreeText.isEmpty) {
      degreeText = (widget.degreeLevel!['nameKey'] as String).tr();
    }
    _degreeController = TextEditingController(text: degreeText);
    
    _fieldController = TextEditingController(text: widget.education?.fieldOfStudy);
    _startDate = widget.education?.startDate ?? DateTime.now();
    _endDate = widget.education?.endDate;
    _isCurrent = widget.education?.isCurrent ?? false;
    
    // Set level color
    _levelColor = widget.degreeLevel?['color'] as Color? ?? AppColors.accentGreen;
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
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with level indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.degreeLevel != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _levelColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(widget.degreeLevel!['icon'] as IconData, color: _levelColor, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    (widget.degreeLevel!['nameKey'] as String).tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _levelColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Text(
                              widget.education == null ? 'form.add_education'.tr() : 'form.edit_education'.tr(),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: c.textPrimary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Form Fields
                      _buildPremiumTextField(
                        controller: _institutionController,
                        label: 'form.institution_name'.tr(),
                        icon: Icons.school_rounded,
                        c: c,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumTextField(
                        controller: _degreeController,
                        label: 'form.degree'.tr(),
                        icon: Icons.workspace_premium_rounded,
                        c: c,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumTextField(
                        controller: _fieldController,
                        label: 'form.field_of_study'.tr(),
                        icon: Icons.menu_book_rounded,
                        c: c,
                      ),
                      const SizedBox(height: 20),
                      
                      // Date Selection
                      Row(
                        children: [
                          Expanded(child: _buildDateButton(
                            label: 'form.start_date'.tr(),
                            date: _startDate,
                            c: c,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                initialDate: _startDate,
                                builder: (context, child) => Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: c.isDark ? ColorScheme.dark(primary: c.primaryStart, surface: c.surface) : ColorScheme.light(primary: c.primaryStart, surface: c.surface),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (date != null) setState(() => _startDate = date);
                            },
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDateButton(
                            label: 'form.end_date'.tr(),
                            date: _endDate,
                            isDisabled: _isCurrent,
                            placeholder: 'Select',
                            c: c,
                            onTap: _isCurrent ? null : () async {
                              final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                initialDate: _endDate ?? DateTime.now(),
                                builder: (context, child) => Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: c.isDark ? ColorScheme.dark(primary: c.primaryStart, surface: c.surface) : ColorScheme.light(primary: c.primaryStart, surface: c.surface),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (date != null) setState(() => _endDate = date);
                            },
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Currently Studying Checkbox
                      Container(
                        decoration: BoxDecoration(
                          color: c.cardBackgroundSolid,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: c.cardBorder),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            'form.currently_studying'.tr(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: c.textPrimary,
                            ),
                          ),
                          value: _isCurrent,
                          onChanged: (v) => setState(() {
                            _isCurrent = v!;
                            if (v) _endDate = null;
                          }),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          activeColor: _levelColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.index != null)
                            TextButton.icon(
                              onPressed: () {
                                context.read<ResumeProvider>().deleteEducation(widget.index!);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.delete_rounded, size: 18),
                              label: Text('form.delete'.tr()),
                              style: TextButton.styleFrom(foregroundColor: c.error),
                            ),
                          const SizedBox(width: 12),
                          _buildSaveButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required AppColorsDynamic c,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: c.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: c.textSecondary),
        prefixIcon: Icon(icon, color: _levelColor, size: 22),
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
          borderSide: BorderSide(color: _levelColor, width: 2),
        ),
      ),
      validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
    );
  }

  Widget _buildDateButton({
    required String label,
    DateTime? date,
    required AppColorsDynamic c,
    bool isDisabled = false,
    String? placeholder,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDisabled ? c.surface : c.cardBackgroundSolid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled ? c.textMuted : _levelColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null ? DateFormat.yMMM().format(date) : (placeholder ?? 'Select'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDisabled ? c.textMuted : c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        color: _levelColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _levelColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              final newEdu = EducationModel(
                institutionName: _institutionController.text,
                degree: _degreeController.text,
                fieldOfStudy: _fieldController.text,
                startDate: _startDate,
                endDate: _endDate,
                isCurrent: _isCurrent,
              );
              
              final provider = context.read<ResumeProvider>();
              if (widget.index != null) {
                provider.updateEducation(widget.index!, newEdu);
              } else {
                provider.addEducation(newEdu);
              }
              
              Navigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text(
              'form.save'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
