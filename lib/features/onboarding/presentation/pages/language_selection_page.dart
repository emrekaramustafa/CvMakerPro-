import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resume/presentation/providers/resume_provider.dart';
import '../../../resume/data/services/pdf_import_service.dart';
import 'template_selection_page.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String? _selectedLanguageCode;
  
  final List<Map<String, String>> languages = const [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
  ];

  @override
  void initState() {
    super.initState();
    // Set default language to device locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final deviceLangCode = deviceLocale.languageCode;
      
      // Check if device language is in our supported languages
      final supportedCodes = languages.map((l) => l['code']).toList();
      if (supportedCodes.contains(deviceLangCode)) {
        setState(() {
          _selectedLanguageCode = deviceLangCode;
        });
      } else {
        setState(() {
          _selectedLanguageCode = 'en'; // Default to English
        });
      }
    });
  }

  void _onContinue() {
    if (_selectedLanguageCode == null) return;
    
    // Set locale
    context.setLocale(Locale(_selectedLanguageCode!));
    
    // Init new resume with selected language
    context.read<ResumeProvider>().initNewResume(_selectedLanguageCode!);
    
    // Navigate to Template Selection Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TemplateSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Back Button
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.cardBackgroundSolid,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title with gradient
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                  child: const Icon(Icons.translate_rounded, size: 48, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'cv_language.title'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'cv_language.subtitle'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 24),
                
                // Language List
                Expanded(
                  child: ListView.separated(
                    itemCount: languages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final isSelected = lang['code'] == _selectedLanguageCode;
                      return _buildLanguageCard(lang, isSelected);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Continue Button
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(Map<String, String> lang, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryStart : AppColors.cardBorder,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppColors.primaryStart.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedLanguageCode = lang['code'];
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryStart.withOpacity(0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      lang['flag']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    lang['name']!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    border: isSelected ? null : Border.all(color: AppColors.cardBorder, width: 2),
                  ),
                  child: isSelected 
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _selectedLanguageCode != null;
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled ? AppColors.primaryGradient : null,
        color: isEnabled ? null : AppColors.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: AppColors.primaryStart.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _onContinue : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              'cv_language.continue'.tr(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isEnabled ? Colors.white : AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _importPdf(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (result == null || result.files.isEmpty) return;
      
      final filePath = result.files.single.path;
      if (filePath == null) return;
      
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryStart),
              ),
            ),
          ),
        );
      }
      
      final pdfService = PdfImportService();
      final extractedText = await pdfService.extractTextFromPdf(File(filePath));
      
      if (context.mounted) {
        Navigator.pop(context);
      }
      
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Extracted Text', style: TextStyle(color: AppColors.textPrimary)),
            content: SingleChildScrollView(
              child: Text(
                extractedText.isEmpty ? 'No text found in PDF' : extractedText,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              if (extractedText.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        _onContinue();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error importing PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
