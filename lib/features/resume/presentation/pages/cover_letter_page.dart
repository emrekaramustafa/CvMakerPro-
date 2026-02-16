import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/resume_provider.dart';

class CoverLetterPage extends StatefulWidget {
  const CoverLetterPage({super.key});

  @override
  State<CoverLetterPage> createState() => _CoverLetterPageState();
}

class _CoverLetterPageState extends State<CoverLetterPage>
    with SingleTickerProviderStateMixin {
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _jobDescController = TextEditingController();
  final _resultController = TextEditingController();

  bool _isGenerating = false;
  bool _hasResult = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Load existing cover letter if any
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ResumeProvider>();
      final existing = provider.currentResume?.coverLetter;
      if (existing != null && existing.isNotEmpty) {
        setState(() {
          _resultController.text = existing;
          _hasResult = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _jobDescController.dispose();
    _resultController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final c = AppColorsDynamic.of(context);
    final provider = context.read<ResumeProvider>();
    provider.updateCoverLetter(_resultController.text);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('form.save_success'.tr()),
          backgroundColor: c.success,
        ),
      );
    }
  }

  // ... _generate, _copyToClipboard, _shareAsPdf methods remain the same ...
  // But for brevity in this replace block, I will just skip them if they are not in the range I'm replacing.
  // Wait, I need to be careful with range.
  // The user wants me to modify initState and add _save.
  // I will just replace initState and add _save before it or after it.
  
  // Let's replace initState up to buildAppBar to include _save and updated AppBar.

  Future<void> _generate() async {
    final c = AppColorsDynamic.of(context);
    if (_companyController.text.trim().isEmpty ||
        _jobTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('cover_letter.fill_required'.tr()),
          backgroundColor: c.warning,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _hasResult = false;
    });

    try {
      final provider = context.read<ResumeProvider>();
      final resume = provider.currentResume;
      if (resume == null) throw Exception('No resume data');

      final result = await provider.openAIService.generateCoverLetter(
        resume: resume,
        jobTitle: _jobTitleController.text.trim(),
        companyName: _companyController.text.trim(),
        jobDescription: _jobDescController.text.trim(),
        language: resume.targetLanguage,
      );

      if (mounted) {
        setState(() {
          _resultController.text = result;
          _hasResult = true;
          _isGenerating = false;
        });
        // Auto-save generated result
        _save();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: c.error,
          ),
        );
      }
    }
  }

  Future<void> _copyToClipboard() async {
    final c = AppColorsDynamic.of(context);
    await Clipboard.setData(ClipboardData(text: _resultController.text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('cover_letter.copied'.tr()),
          backgroundColor: c.success,
        ),
      );
    }
  }

  Future<void> _shareAsPdf() async {
    final c = AppColorsDynamic.of(context);
    try {
      final provider = context.read<ResumeProvider>();
      final resume = provider.currentResume;
      final name = resume?.personalInfo.fullName ?? '';
      final email = resume?.personalInfo.email ?? '';
      final phone = resume?.personalInfo.phone ?? '';

      final html = '''
<!DOCTYPE html>
<html>
<head>
<style>
  body { font-family: 'Helvetica Neue', Arial, sans-serif; padding: 60px; color: #1a1a2e; line-height: 1.7; font-size: 14px; }
  .header { margin-bottom: 30px; border-bottom: 2px solid #6366F1; padding-bottom: 15px; }
  .header h1 { font-size: 22px; color: #6366F1; margin: 0; }
  .header p { margin: 4px 0; color: #555; font-size: 13px; }
  .content { white-space: pre-wrap; font-size: 14px; line-height: 1.8; }
  .footer { margin-top: 40px; color: #888; font-size: 12px; }
</style>
</head>
<body>
  <div class="header">
    <h1>$name</h1>
    <p>$email ${phone.isNotEmpty ? '• $phone' : ''}</p>
  </div>
  <div class="content">${_resultController.text.replaceAll('\n', '<br>')}</div>
  <div class="footer">
    <p>${'cover_letter.title'.tr()} — ${_companyController.text} / ${_jobTitleController.text}</p>
  </div>
</body>
</html>
''';

      final dir = await getApplicationDocumentsDirectory();
      final file = await FlutterHtmlToPdf.convertFromHtmlContent(
        html,
        dir.path,
        'CoverLetter_${DateTime.now().millisecondsSinceEpoch}',
      );

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'cover_letter.title'.tr(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF Error: ${e.toString()}'),
            backgroundColor: c.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(c),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _isGenerating
                      ? _buildLoadingState(c)
                      : _hasResult
                          ? _buildResultState(c)
                          : _buildInputState(c),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppColorsDynamic c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: c.textPrimary),
            style: IconButton.styleFrom(
              backgroundColor: c.cardBackgroundSolid,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'cover_letter.title'.tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ),
          ),
          if (_hasResult) ...[
            IconButton(
              onPressed: () { _save(); _copyToClipboard(); }, // Save on copy too
              icon: Icon(Icons.copy_rounded, color: c.textPrimary, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: c.cardBackgroundSolid,
                padding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () { _save(); _shareAsPdf(); },
              icon: Icon(Icons.share_rounded, color: c.textPrimary, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: c.cardBackgroundSolid,
                padding: const EdgeInsets.all(10),
              ),
            ),
             const SizedBox(width: 8),
            IconButton(
              onPressed: _save,
              icon: Icon(Icons.save_rounded, color: c.primaryStart, size: 24),
              style: IconButton.styleFrom(
                backgroundColor: c.cardBackgroundSolid,
                padding: const EdgeInsets.all(10),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputState(AppColorsDynamic c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withOpacity(0.15),
                const Color(0xFF8B5CF6).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'cover_letter.info'.tr(),
                  style: TextStyle(
                    color: c.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Company Name
        _buildInputField(
          controller: _companyController,
          label: 'cover_letter.company_name'.tr(),
          hint: 'cover_letter.company_hint'.tr(),
          icon: Icons.business_rounded,
          required: true,
          c: c,
        ),

        const SizedBox(height: 16),

        // Job Title
        _buildInputField(
          controller: _jobTitleController,
          label: 'cover_letter.job_title'.tr(),
          hint: 'cover_letter.job_hint'.tr(),
          icon: Icons.work_rounded,
          required: true,
          c: c,
        ),

        const SizedBox(height: 16),

        // Job Description
        _buildInputField(
          controller: _jobDescController,
          label: 'cover_letter.job_desc'.tr(),
          hint: 'cover_letter.job_desc_hint'.tr(),
          icon: Icons.description_rounded,
          maxLines: 5,
          c: c,
        ),

        const SizedBox(height: 32),

        // Generate Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: c.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: c.primaryStart.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
              label: Text(
                'cover_letter.generate'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(AppColorsDynamic c) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.15),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: c.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: c.primaryStart.withOpacity(0.3 + _pulseController.value * 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'cover_letter.generating'.tr(),
              style: TextStyle(
                color: c.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'cover_letter.generating_desc'.tr(),
              style: TextStyle(
                color: c.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState(AppColorsDynamic c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: c.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.success.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: c.success, size: 20),
              const SizedBox(width: 10),
              Text(
                'cover_letter.ready'.tr(),
                style: TextStyle(
                  color: c.success,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Job info
        Text(
          '${_companyController.text} — ${_jobTitleController.text}',
          style: TextStyle(
            color: c.textSecondary,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 16),

        // Editable result
        Container(
          decoration: BoxDecoration(
            color: c.cardBackgroundSolid,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.cardBorder),
          ),
          child: TextField(
            controller: _resultController,
            maxLines: null,
            minLines: 12,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 14,
              height: 1.7,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              border: InputBorder.none,
              hintText: 'cover_letter.edit_hint'.tr(),
              hintStyle: TextStyle(color: c.textTertiary),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasResult = false;
                    _resultController.clear();
                  });
                },
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text('cover_letter.regenerate'.tr()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.textSecondary,
                  side: BorderSide(color: c.cardBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: c.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _shareAsPdf,
                    icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 18),
                    label: Text(
                      'cover_letter.share_pdf'.tr(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AppColorsDynamic c,
    bool required = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: c.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (required)
              Text(' *', style: TextStyle(color: c.error, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: c.cardBackgroundSolid,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.cardBorder),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: c.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: c.textTertiary, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
