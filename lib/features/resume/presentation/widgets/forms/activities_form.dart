import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/activity_model.dart';
import 'education_form.dart'; // Reusing styling patterns

class ActivitiesForm extends StatelessWidget {
  const ActivitiesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final activities = provider.currentResume?.activities ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Button
              _buildAddButton(context),
              
              const SizedBox(height: 32),
              
              // List
              if (activities.isNotEmpty) ...[
                Text(
                  'form.activities_list'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...activities.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildActivityCard(context, entry.value, entry.key),
                  );
                }),
              ],
              
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.accentPink.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentPink.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDialog(context),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentPink.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.accentPink, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  'form.add_activity'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentPink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, ActivityModel activity, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDialog(context, activity: activity, index: index),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    activity.category == 'Volunteering' ? Icons.volunteer_activism_rounded : Icons.sports_esports_rounded,
                    color: AppColors.accentPink,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.category == 'Volunteering' ? 'form.volunteering'.tr() : 'form.hobby'.tr(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  onPressed: () => context.read<ResumeProvider>().deleteActivity(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, {ActivityModel? activity, int? index}) {
    showDialog(
      context: context,
      builder: (context) => _ActivityEditDialog(activity: activity, index: index),
    );
  }
}

class _ActivityEditDialog extends StatefulWidget {
  final ActivityModel? activity;
  final int? index;

  const _ActivityEditDialog({this.activity, this.index});

  @override
  State<_ActivityEditDialog> createState() => _ActivityEditDialogState();
}

class _ActivityEditDialogState extends State<_ActivityEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _category = 'Hobby';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.activity?.title);
    _descriptionController = TextEditingController(text: widget.activity?.description);
    _category = widget.activity?.category ?? 'Hobby';
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final act = ActivityModel(
        title: _titleController.text,
        description: _descriptionController.text,
        category: _category,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.index != null) {
        provider.updateActivity(widget.index!, act);
      } else {
        provider.addActivity(act);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackgroundSolid,
      title: Text(widget.index == null ? 'form.add_activity'.tr() : 'form.edit_activity'.tr()),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'form.activity_title'.tr(),
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'form.category'.tr(),
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
                items: [
                  DropdownMenuItem(value: 'Hobby', child: Text('form.hobby'.tr())),
                  DropdownMenuItem(value: 'Volunteering', child: Text('form.volunteering'.tr())),
                ],
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'form.description'.tr(),
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('form.cancel'.tr())),
        FilledButton(onPressed: _save, child: Text('form.save'.tr())),
      ],
    );
  }
}
