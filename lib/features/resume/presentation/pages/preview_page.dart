import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import '../../presentation/providers/resume_provider.dart';
import '../../data/models/resume_model.dart';
import '../../data/services/pdf_generator_service.dart';
import '../../../paywall/presentation/pages/paywall_page.dart';

class PreviewPage extends StatefulWidget {
  final ResumeModel? resume;

  const PreviewPage({super.key, this.resume});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final PdfGeneratorService _pdfService = PdfGeneratorService();
  String? _pdfPath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generatePdf();
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final resume = context.read<ResumeProvider>().currentResume ?? widget.resume;
      
      if (resume == null) {
        if (mounted) {
          setState(() {
            _errorMessage = "No resume data available";
            _isLoading = false;
          });
        }
        return;
      }

      final file = await _pdfService.generateResumePdf(resume);
      if (mounted) {
        setState(() {
          _pdfPath = file.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('form.preview'.tr()),
        actions: [
          // Template Switcher
          PopupMenuButton<String>(
            icon: const Icon(Icons.style),
            tooltip: 'form.change_template'.tr(),
            onSelected: (value) {
              context.read<ResumeProvider>().switchTemplate(value);
              _generatePdf();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'modern', child: Text('form.modern_template'.tr())),
              PopupMenuItem(value: 'classic', child: Text('form.classic_template'.tr())),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _pdfPath == null ? null : () {
              // TODO: Share/Download PDF
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('PDF Generation Error', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: _generatePdf,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _pdfPath == null
                  ? const Center(child: Text("Failed to generate PDF"))
                  : Stack(
                      children: [
                        PDFView(
                          filePath: _pdfPath!,
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageFling: true,
                        ),
                        if (!(context.watch<ResumeProvider>().currentResume?.isPremium ?? false))
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white.withOpacity(0.9),
                                    Colors.white,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: FilledButton(
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const PaywallPage()),
                                    );
                                    
                                    if (result == true && context.mounted) {
                                      context.read<ResumeProvider>().upgradeToPremium();
                                      setState(() {});
                                    }
                                  },
                                  child: Text('form.unlock_pdf'.tr()),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
    );
  }
}
