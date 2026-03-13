import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../../core/services/analytics_service.dart';
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
    AnalyticsService().trackEvent('create_new_cv');
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionPage()));
  }

  Future<void> _importCV() async {
    try {
      AnalyticsService().trackEvent('import_cv_start');
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
      print('[CVImport] profileImagePath result: $profileImagePath');
      
      if (extractedText.isEmpty) {
        if (mounted) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('cv_choice.no_text_found'.tr()), backgroundColor: AppColors.error));
        }
        return;
      }
      
      final openAIService = OpenAIService();
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
        if (ModalRoute.of(context)?.isCurrent == true) {
          Navigator.pop(context);
        }
        context.read<ResumeProvider>().loadResume(resume);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateSelectionPage(isFromImport: true)));
      }
    } catch (e) {
      if (mounted) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${'common.error'.tr()}: $e"), backgroundColor: AppColors.error));
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
    final isRoot = !Navigator.canPop(context);
    
    return PopScope(
      canPop: !isRoot,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      },
      child: Scaffold(
        body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.primaryStart.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.accent.withValues(alpha: 0.1),
              ),
            ),
          ),
          
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: c.backgroundGradient),
              child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // Settings Button aligned to the right
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                            icon: Icon(Icons.settings_outlined, color: Colors.white.withValues(alpha: 0.8)),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              padding: const EdgeInsets.all(12),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Centered App Icon & Name
                        Center(
                          child: Column(
                            children: [
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.8, end: 1.0),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutBack,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: child,
                                  );
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                                        blurRadius: 40,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Image.asset(
                                      'assets/appicon_transparent.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Colors.white, Color(0xFFD8B4FE)],
                                ).createShader(bounds),
                                child: const Text(
                                  'CV Maker Pro+',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                                ),
                                child: Text(
                                  'cv_choice.title'.tr(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        _buildHighlightedAiCard(
                          icon: Icons.auto_awesome_rounded,
                          title: 'cv_choice.create_new'.tr(),
                          subtitle: 'cv_choice.create_new_desc'.tr(),
                          onTap: _createNewCV,
                          c: c,
                          index: 0,
                        ),
                        const SizedBox(height: 16),
                        _buildOptionCard(
                          icon: Icons.upload_file_rounded,
                          iconGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.4),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          title: 'cv_choice.import_cv'.tr(),
                          subtitle: 'cv_choice.import_cv_desc'.tr(),
                          onTap: _importCV,
                          c: c,
                          index: 1,
                        ),
                        const SizedBox(height: 16),
                        _buildOptionCard(
                          icon: Icons.folder_shared_rounded,
                          iconGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.4),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          title: 'cv_choice.saved_resumes'.tr(),
                          subtitle: 'cv_choice.saved_resumes_desc'.tr(),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage())),
                          c: c,
                          index: 2,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      ),
    ));
  }

  Widget _buildHighlightedAiCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required AppColorsDynamic c,
    required int index,
  }) {
    // Unique animated glowing card for the primary AI action
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C2BD9), Color(0xFF3B0764)], // Deep vibrant purple gradient
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD8B4FE).withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            splashColor: Colors.white.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.4),
                          Colors.white.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.2,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required Gradient iconGradient,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required AppColorsDynamic c,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C2BD9), Color(0xFF3B0764)], // Deep vibrant purple gradient
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD8B4FE).withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            splashColor: c.primaryStart.withValues(alpha: 0.1),
            highlightColor: c.primaryStart.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: iconGradient,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: (iconGradient as LinearGradient).colors.first.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
