import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';

class SummaryForm extends StatefulWidget {
  const SummaryForm({super.key});

  @override
  State<SummaryForm> createState() => _SummaryFormState();
}

class _SummaryFormState extends State<SummaryForm> {
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ResumeProvider>();
    _summaryController = TextEditingController(text: provider.currentResume?.professionalSummary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.primaryStart.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.primaryStart.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                 Icon(Icons.auto_awesome_rounded, color: c.primaryStart, size: 24),
                 const SizedBox(width: 12),
                 Expanded(
                   child: Text(
                     'form.summary_hint'.tr(), // Ensure this key exists or use fallback
                     style: TextStyle(color: c.textSecondary, fontSize: 13, height: 1.4),
                   ),
                 ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Text(
            'form.professional_summary'.tr(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: c.textPrimary),
          ),
          const SizedBox(height: 8),
          
          TextFormField(
            controller: _summaryController,
            maxLines: 8,
            style: TextStyle(color: c.textPrimary, fontSize: 15, height: 1.5),
            decoration: InputDecoration(
              hintText: 'form.summary_placeholder'.tr(),
              hintStyle: TextStyle(color: c.textMuted),
              filled: true,
              fillColor: c.inputBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: c.primaryStart, width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: () {
              context.read<ResumeProvider>().updateSummary(_summaryController.text);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                 gradient: c.primaryGradient,
                 borderRadius: BorderRadius.circular(14),
                 boxShadow: [
                   BoxShadow(
                     color: c.primaryStart.withOpacity(0.3),
                     blurRadius: 12,
                     offset: const Offset(0, 6),
                   ),
                 ],
              ),
              alignment: Alignment.center,
              child: Text(
                'form.save'.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
