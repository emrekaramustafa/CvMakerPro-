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
    final c = AppColorsDynamic.of(context);
    return Consumer<ResumeProvider>(
      builder: (context, provider, child) {
        final certificates = provider.currentResume?.certificates ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Button
              _buildAddButton(context, c),
              
              const SizedBox(height: 32),
              
              // List
              if (certificates.isNotEmpty) ...[
                Text(
                  'form.certificates_list'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...certificates.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCertificateCard(context, entry.value, entry.key, c),
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
        color: c.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.accent.withOpacity(0.3)),
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
                    color: c.accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_rounded, color: c.accent, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  'form.add_certificate'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.accent,
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
              color: c.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: c.accent,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'form.no_certificates'.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'form.no_certificates_desc'.tr(),
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

  Widget _buildCertificateCard(BuildContext context, CertificateModel cert, int index, AppColorsDynamic c) {
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
          onTap: () => _showDialog(context, certificate: cert, index: index),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: c.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.workspace_premium_rounded, color: c.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cert.title,
                        style: TextStyle(
                          color: c.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.issuer,
                        style: TextStyle(
                          color: c.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      if (cert.date != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().format(cert.date!),
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
    final c = AppColorsDynamic.of(context);
    return AlertDialog(
      backgroundColor: c.cardBackgroundSolid,
      title: Text(widget.index == null ? 'form.add_certificate'.tr() : 'form.edit_certificate'.tr(), style: TextStyle(color: c.textPrimary)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'form.cert_title'.tr(),
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
                controller: _issuerController,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  labelText: 'form.cert_issuer'.tr(),
                  labelStyle: TextStyle(color: c.textSecondary),
                  filled: true,
                  fillColor: c.isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primaryStart)),
                ),
                validator: (v) => v!.isEmpty ? 'form.required'.tr() : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_date == null ? 'form.select_date'.tr() : DateFormat.yMMMd().format(_date!), style: TextStyle(color: c.textPrimary)),
                leading: Icon(Icons.calendar_today, color: c.textSecondary),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                       data: Theme.of(context).copyWith(
                        colorScheme: c.isDark ? ColorScheme.dark(primary: c.primaryStart, surface: c.surface) : ColorScheme.light(primary: c.primaryStart, surface: c.surface),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
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
