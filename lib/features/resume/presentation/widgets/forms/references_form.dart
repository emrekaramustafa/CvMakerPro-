import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/reference_model.dart';
import 'education_form.dart'; // Reusing styling patterns

class ReferencesForm extends StatelessWidget {
  const ReferencesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final references = provider.currentResume?.references ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Button
              _buildAddButton(context, c),
              
              const SizedBox(height: 32),
              
              // List
              if (references.isNotEmpty) ...[
                Text(
                  'form.references_list'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...references.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildReferenceCard(context, entry.value, entry.key, c),
                  );
                }),
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

  Widget _buildAddButton(BuildContext context, AppColorsDynamic c) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.accentGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.accentGreen.withOpacity(0.3)),
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
                    color: c.accentGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_rounded, color: c.accentGreen, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  'form.add_reference'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.accentGreen,
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
              color: c.accentGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_alt_rounded,
              color: c.accentGreen,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'form.no_references'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'form.no_references_desc'.tr(),
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

  Widget _buildReferenceCard(BuildContext context, ReferenceModel ref, int index, AppColorsDynamic c) {
    return Container(
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDialog(context, reference: ref, index: index),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.people_alt_rounded, color: c.accentGreen),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.fullName,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ref.company,
                        style: TextStyle(
                          color: c.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (ref.email != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          ref.email!,
                          style: TextStyle(
                            color: c.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: c.error),
                  onPressed: () => context.read<ResumeProvider>().deleteReference(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, {ReferenceModel? reference, int? index}) {
    showDialog(
      context: context,
      builder: (context) => _ReferenceEditDialog(reference: reference, index: index),
    );
  }
}

class _ReferenceEditDialog extends StatefulWidget {
  final ReferenceModel? reference;
  final int? index;

  const _ReferenceEditDialog({this.reference, this.index});

  @override
  State<_ReferenceEditDialog> createState() => _ReferenceEditDialogState();
}

class _ReferenceEditDialogState extends State<_ReferenceEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.reference?.fullName);
    _companyController = TextEditingController(text: widget.reference?.company);
    _emailController = TextEditingController(text: widget.reference?.email);
    _phoneController = TextEditingController(text: widget.reference?.phone);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final ref = ReferenceModel(
        fullName: _nameController.text,
        company: _companyController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.index != null) {
        provider.updateReference(widget.index!, ref);
      } else {
        provider.addReference(ref);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return AlertDialog(
      backgroundColor: c.cardBackgroundSolid,
      title: Text(widget.index == null ? 'form.add_reference'.tr() : 'form.edit_reference'.tr(), style: TextStyle(color: c.textPrimary)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'form.ref_name'.tr(),
                  labelStyle: TextStyle(color: c.textSecondary),
                  filled: true,
                  fillColor: c.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primaryStart)),
                ),
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'form.ref_company'.tr(),
                  labelStyle: TextStyle(color: c.textSecondary),
                  filled: true,
                  fillColor: c.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primaryStart)),
                ),
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'form.email'.tr(),
                  labelStyle: TextStyle(color: c.textSecondary),
                  filled: true,
                  fillColor: c.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primaryStart)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'form.phone'.tr(),
                  labelStyle: TextStyle(color: c.textSecondary),
                  filled: true,
                  fillColor: c.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primaryStart)),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('form.cancel'.tr(), style: TextStyle(color: c.textSecondary))),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(backgroundColor: c.primaryStart),
          child: Text('form.save'.tr()),
        ),
      ],
    );
  }
}
