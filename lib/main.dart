import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/init/hive_init.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/pages/welcome_page.dart';
import 'features/resume/data/datasources/resume_local_data_source.dart';
import 'features/resume/data/models/resume_model.dart';
import 'features/resume/domain/repositories/resume_repository.dart';
import 'features/resume/presentation/providers/resume_provider.dart';
import 'features/resume/data/services/openai_service.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await HiveInit.init();
  
  final resumeBox = Hive.box<ResumeModel>('resumes');
  final localDataSource = ResumeLocalDataSourceImpl(resumeBox: resumeBox);
  final repository = ResumeRepositoryImpl(localDataSource: localDataSource);
  
  // TODO: Get API Key from secure storage or UI
  final openAiService = OpenAIService(apiKey: AppConstants.openAiApiKey);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('de'),
        Locale('fr'),
        Locale('es'),
        Locale('pt'),
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
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for dark theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF0F172A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    
    return MaterialApp(
      title: 'AI Resume Pro',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const WelcomePage(),
    );
  }
}

