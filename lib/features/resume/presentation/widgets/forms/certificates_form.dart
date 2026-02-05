import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/certificate_model.dart';
import 'education_form.dart'; // Reusing styling patterns

class CertificatesForm extends StatelessWidget {
  const CertificatesForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final certificates = provider.currentResume?.certificates ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Button
              _buildAddButton(context),
              
              const SizedBox(height: 32),
              
              // List
              if (certificates.isNotEmpty) ...[
                Text(
                  'form.certificates_list'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...certificates.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCertificateCard(context, entry.value, entry.key),
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
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
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
                    color: AppColors.accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded, color: AppColors.accent, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  'form.add_certificate'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateCard(BuildContext context, CertificateModel cert, int index) {
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
          onTap: () => _showDialog(context, certificate: cert, index: index),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.workspace_premium_rounded, color: AppColors.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.issuer,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (cert.date != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().format(cert.date!),
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                  onPressed: () => context.read<ResumeProvider>().deleteCertificate(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, {CertificateModel? certificate, int? index}) {
    showDialog(
      context: context,
      builder: (context) => _CertificateEditDialog(certificate: certificate, index: index),
    );
  }
}

class _CertificateEditDialog extends StatefulWidget {
  final CertificateModel? certificate;
  final int? index;

  const _CertificateEditDialog({this.certificate, this.index});

  @override
  State<_CertificateEditDialog> createState() => _CertificateEditDialogState();
}

class _CertificateEditDialogState extends State<_CertificateEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _issuerController;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.certificate?.title);
    _issuerController = TextEditingController(text: widget.certificate?.issuer);
    _date = widget.certificate?.date;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final cert = CertificateModel(
        title: _titleController.text,
        issuer: _issuerController.text,
        date: _date,
      );

      final provider = context.read<ResumeProvider>();
      if (widget.index != null) {
        provider.updateCertificate(widget.index!, cert);
      } else {
        provider.addCertificate(cert);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackgroundSolid,
      title: Text(widget.index == null ? 'form.add_certificate'.tr() : 'form.edit_certificate'.tr()),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'form.cert_title'.tr(),
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issuerController,
                decoration: InputDecoration(
                  labelText: 'form.cert_issuer'.tr(),
                  filled: true,
                  fillColor: AppColors.inputFill,
                ),
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_date == null ? 'form.select_date'.tr() : DateFormat.yMMMd().format(_date!)),
                leading: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
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
