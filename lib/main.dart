import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/init/hive_init.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/onboarding/presentation/pages/welcome_page.dart';
import 'features/resume/data/datasources/resume_local_data_source.dart';
import 'features/resume/data/models/resume_model.dart';
import 'features/resume/domain/repositories/resume_repository.dart';
import 'features/resume/presentation/providers/resume_provider.dart';
import 'features/resume/data/services/openai_service.dart';
import 'core/constants/app_constants.dart';

import 'dart:async';



void main() async {
  runZonedGuarded(() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      
      // Init Localization
      try {
        await EasyLocalization.ensureInitialized();
      } catch (e) {
        debugPrint("EasyLocalization Init Error: $e");
      }
      
      // Init Hive with robust handling
      try {
        await HiveInit.init();
      } catch (e) {
        debugPrint("Hive Init Error: $e");
        runApp(_buildErrorApp("Storage Initialization Failed: $e"));
        return;
      }
    
      final resumeBox = Hive.box<ResumeModel>('resumes');
      final localDataSource = ResumeLocalDataSourceImpl(resumeBox: resumeBox);
      final repository = ResumeRepositoryImpl(localDataSource: localDataSource);
      final openAiService = OpenAIService(apiKey: AppConstants.openAiApiKey);

      runApp(
        EasyLocalization(
          supportedLocales: const [
            Locale('en'), Locale('tr'), Locale('de'),
            Locale('fr'), Locale('es'), Locale('pt'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ResumeProvider(
                  repository: repository,
                  openAIService: openAiService,
                ),
              ),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: const MyApp(),
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint("Critical Startup Error: $e");
      debugPrint(stack.toString());
      runApp(_buildErrorApp("Critical Startup Error: $e"));
    }
  }, (error, stack) {
    debugPrint('Global Zone Error: $error');
    debugPrint(stack.toString());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        // Set system UI overlay style based on theme
        final isDark = themeProvider.isDarkMode;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FC),
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );
        
        return MaterialApp(
          title: 'AI Resume Pro',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const WelcomePage(),
        );
      },
    );
  }
}

Widget _buildErrorApp(String message) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text("Startup Error", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              const Text("Try reinstalling the app.", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    ),
  );
}
