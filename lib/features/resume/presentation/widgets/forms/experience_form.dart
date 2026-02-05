import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/experience_model.dart';
import 'package:intl/intl.dart';

class ExperienceForm extends StatelessWidget {
  const ExperienceForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final experiences = provider.currentResume?.experience ?? [];
        
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: experiences.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == experiences.length) {
              return _buildAddButton(context);
            }
            
            final exp = experiences[index];
            return _buildExperienceCard(context, exp, index);
          },
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showExperienceDialog(context),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(
                  'form.add_experience'.tr(),
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

  Widget _buildExperienceCard(BuildContext context, ExperienceModel exp, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showExperienceDialog(context, experience: exp, index: index),
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
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business_rounded,
                    color: Colors.white,
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
                        exp.jobTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exp.companyName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${DateFormat.yMMM().format(exp.startDate)} - ${exp.isCurrent ? 'form.present'.tr() : (exp.endDate != null ? DateFormat.yMMM().format(exp.endDate!) : 'form.present'.tr())}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
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
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.textTertiary,
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

  void _showExperienceDialog(BuildContext context, {ExperienceModel? experience, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExperienceEditDialog(experience: experience, index: index),
    );
  }
}

class ExperienceEditDialog extends StatefulWidget {
  final ExperienceModel? experience;
  final int? index;

  const ExperienceEditDialog({super.key, this.experience, this.index});

  @override
  State<ExperienceEditDialog> createState() => _ExperienceEditDialogState();
}

class _ExperienceEditDialogState extends State<ExperienceEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _isCurrent = false;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.experience?.companyName);
    _titleController = TextEditingController(text: widget.experience?.jobTitle);
    _descriptionController = TextEditingController(text: widget.experience?.description);
    _startDate = widget.experience?.startDate ?? DateTime.now();
    _endDate = widget.experience?.endDate;
    _isCurrent = widget.experience?.isCurrent ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
              color: AppColors.textMuted,
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
                      // Title
                      Center(
                        child: Text(
                          widget.experience == null ? 'form.add_experience'.tr() : 'form.edit_experience'.tr(),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Form Fields
                      _buildPremiumTextField(
                        controller: _companyController,
                        label: 'form.company_name'.tr(),
                        icon: Icons.business_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildPremiumTextField(
                        controller: _titleController,
                        label: 'form.job_title'.tr(),
                        icon: Icons.work_rounded,
                      ),
                      const SizedBox(height: 20),
                      
                      // Date Selection
                      Row(
                        children: [
                          Expanded(child: _buildDateButton(
                            label: 'form.start_date'.tr(),
                            date: _startDate,
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1980),
                                lastDate: DateTime.now(),
                                initialDate: _startDate,
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
                            onTap: _isCurrent ? null : () async {
                              final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1980),
                                lastDate: DateTime.now(),
                                initialDate: _endDate ?? DateTime.now(),
                              );
                              if (date != null) setState(() => _endDate = date);
                            },
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Currently Working Checkbox
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackgroundSolid,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            'form.current_job'.tr(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          value: _isCurrent,
                          onChanged: (v) => setState(() {
                            _isCurrent = v!;
                            if (v) _endDate = null;
                          }),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          activeColor: AppColors.primaryStart,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      _buildPremiumTextField(
                        controller: _descriptionController,
                        label: 'form.description'.tr(),
                        icon: Icons.description_rounded,
                        maxLines: 3,
                        isRequired: false,
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.index != null)
                            TextButton.icon(
                              onPressed: () {
                                context.read<ResumeProvider>().deleteExperience(widget.index!);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.delete_rounded, size: 18),
                              label: Text('form.delete'.tr()),
                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryStart, size: 22),
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
          borderSide: const BorderSide(color: AppColors.primaryStart, width: 2),
        ),
      ),
      validator: isRequired ? (v) => v!.isEmpty ? 'form.required'.tr() : null : null,
    );
  }

  Widget _buildDateButton({
    required String label,
    DateTime? date,
    bool isDisabled = false,
    String? placeholder,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.surface : AppColors.cardBackgroundSolid,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled ? AppColors.textMuted : AppColors.primaryStart,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date != null ? DateFormat.yMMMd().format(date) : (placeholder ?? 'Select'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDisabled ? AppColors.textMuted : AppColors.textPrimary,
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
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withOpacity(0.3),
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
              final newExp = ExperienceModel(
                companyName: _companyController.text,
                jobTitle: _titleController.text,
                startDate: _startDate,
                endDate: _endDate,
                isCurrent: _isCurrent,
                description: _descriptionController.text,
                bulletPoints: widget.experience?.bulletPoints ?? [],
              );
              
              final provider = context.read<ResumeProvider>();
              if (widget.index != null) {
                provider.updateExperience(widget.index!, newExp);
              } else {
                provider.addExperience(newExp);
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
