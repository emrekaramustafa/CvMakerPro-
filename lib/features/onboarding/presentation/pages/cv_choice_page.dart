import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resume/data/models/resume_model.dart';
import '../../../resume/data/models/personal_info_model.dart';
import '../../../resume/data/models/experience_model.dart';
import '../../../resume/data/models/education_model.dart';
import '../../../resume/data/models/language_entry.dart';
import '../../../resume/data/services/openai_service.dart';
import '../../../resume/presentation/providers/resume_provider.dart';
import 'language_selection_page.dart';
import 'template_selection_page.dart';
import '../../../resume/presentation/pages/home_page.dart';
import '../../../resume/data/services/pdf_import_service.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../widgets/ai_loading_overlay.dart';

class CVChoicePage extends StatefulWidget {
  const CVChoicePage({super.key});

  @override
  State<CVChoicePage> createState() => _CVChoicePageState();
}

class _CVChoicePageState extends State<CVChoicePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _createNewCV() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionPage()));
  }

  Future<void> _importCV() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      if (result == null || result.files.isEmpty) return;
      final filePath = result.files.single.path;
      if (filePath == null) return;
      
      if (mounted) {
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AILoadingOverlay(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ));
      }
      
      final pdfService = PdfImportService();
      final extractedText = await pdfService.extractTextFromPdf(File(filePath));
      final profileImagePath = await pdfService.extractProfileImage(File(filePath));
      
      if (extractedText.isEmpty) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('cv_choice.no_text_found'.tr()), backgroundColor: AppColors.error));
        }
        return;
      }
      
      final openAIService = OpenAIService(apiKey: AppConstants.openAiApiKey);
      final parsedData = await openAIService.parseCVFromText(extractedText);
      final personalInfo = parsedData['personalInfo'] ?? {};
      final experiences = (parsedData['experience'] as List<dynamic>?)?.map((e) => ExperienceModel(
        companyName: e['companyName'] ?? '', jobTitle: e['jobTitle'] ?? '',
        startDate: _parseDate(e['startDate']), endDate: e['endDate'] != null ? _parseDate(e['endDate']) : null,
        isCurrent: e['isCurrent'] == true, description: e['description'] ?? '', bulletPoints: List<String>.from(e['bulletPoints'] ?? []),
      )).toList() ?? [];
      final educations = (parsedData['education'] as List<dynamic>?)?.map((e) => EducationModel(
        institutionName: e['institutionName'] ?? '', degree: e['degree'] ?? '', fieldOfStudy: e['fieldOfStudy'] ?? '',
        startDate: _parseDate(e['startDate']), endDate: e['endDate'] != null ? _parseDate(e['endDate']) : null, isCurrent: e['isCurrent'] == true,
      )).toList() ?? [];
      final skills = List<String>.from(parsedData['skills'] ?? []);
      final languages = (parsedData['languages'] as List<dynamic>?)?.map((l) => LanguageEntry(
        languageName: l['languageName'] ?? '', level: l['level'] ?? 'intermediate',
      )).toList() ?? [];
      
      final resume = ResumeModel(
        id: const Uuid().v4(), targetLanguage: context.locale.languageCode,
        personalInfo: PersonalInfoModel(
          fullName: personalInfo['fullName'] ?? '', email: personalInfo['email'] ?? '', phone: personalInfo['phone'] ?? '',
          address: personalInfo['address'], linkedinUrl: personalInfo['linkedinUrl'], websiteUrl: personalInfo['websiteUrl'],
          targetJobTitle: personalInfo['targetJobTitle'] ?? '',
          profileImagePath: profileImagePath, // New field
        ),
        experience: experiences, education: educations, skills: skills, languages: languages,
        professionalSummary: parsedData['professionalSummary'], createdAt: DateTime.now(), updatedAt: DateTime.now(),
      );
      
      if (mounted) {
        Navigator.pop(context);
        context.read<ResumeProvider>().loadResume(resume);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TemplateSelectionPage(isFromImport: true)));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error));
      }
    }
  }
  
  DateTime _parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return DateTime.now();
    try { return DateTime.parse(dateStr.toString()); } catch (_) { return DateTime.now(); }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                      icon: Icon(Icons.settings_outlined, color: c.textPrimary),
                      style: IconButton.styleFrom(backgroundColor: c.cardBackgroundSolid, padding: const EdgeInsets.all(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ShaderMask(
                    shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
                    child: Text(
                      'cv_choice.title'.tr(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('cv_choice.subtitle'.tr(), style: TextStyle(fontSize: 16, color: c.textSecondary)),
                  
                  _buildOptionCard(icon: Icons.auto_awesome_rounded, iconGradient: c.primaryGradient, title: 'cv_choice.create_new'.tr(), subtitle: 'cv_choice.create_new_desc'.tr(), onTap: _createNewCV, c: c),
                  const SizedBox(height: 16),
                  _buildOptionCard(icon: Icons.upload_file_rounded, iconGradient: c.accentGradient, title: 'cv_choice.import_cv'.tr(), subtitle: 'cv_choice.import_cv_desc'.tr(), onTap: _importCV, c: c),
                  const SizedBox(height: 16),
                  _buildOptionCard(icon: Icons.folder_shared_rounded, iconGradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]), title: 'cv_choice.saved_resumes'.tr(), subtitle: 'cv_choice.saved_resumes_desc'.tr(), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage())), c: c),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({required IconData icon, required Gradient iconGradient, required String title, required String subtitle, required VoidCallback onTap, required AppColorsDynamic c}) {
    return Container(
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(gradient: iconGradient, borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.textPrimary)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 14, color: c.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.arrow_forward_rounded, color: AppColors.textTertiary, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
