import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resume/presentation/providers/resume_provider.dart';
import 'template_selection_page.dart';
import '../../../resume/presentation/pages/home_page.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final deviceLangCode = deviceLocale.languageCode;
      final supportedCodes = languages.map((l) => l['code']).toList();
      if (supportedCodes.contains(deviceLangCode)) {
        setState(() => _selectedLanguageCode = deviceLangCode);
      } else {
        setState(() => _selectedLanguageCode = 'en');
      }
    });
  }

  void _onContinue() {
    if (_selectedLanguageCode == null) return;
    context.setLocale(Locale(_selectedLanguageCode!));
    context.read<ResumeProvider>().initNewResume(_selectedLanguageCode!);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TemplateSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: c.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                            (route) => false,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: c.textPrimary),
                      style: IconButton.styleFrom(
                        backgroundColor: c.cardBackgroundSolid,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
                      child: const Icon(Icons.translate_rounded, size: 48, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'cv_language.title'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: c.textPrimary,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'cv_language.subtitle'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: c.textSecondary,
                      ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: languages.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final lang = languages[index];
                      final isSelected = lang['code'] == _selectedLanguageCode;
                      return _buildLanguageCard(lang, isSelected, c);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildContinueButton(c),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard(Map<String, String> lang, bool isSelected, AppColorsDynamic c) {
    return Container(
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? c.primaryStart : c.cardBorder,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: c.primaryStart.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ] : c.isDark ? [] : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                    color: isSelected ? c.primaryStart.withValues(alpha: 0.1) : c.surface,
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
                      color: c.textPrimary,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected ? c.primaryGradient : null,
                    border: isSelected ? null : Border.all(color: c.cardBorder, width: 2),
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

  Widget _buildContinueButton(AppColorsDynamic c) {
    final isEnabled = _selectedLanguageCode != null;
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled ? c.primaryGradient : null,
        color: isEnabled ? null : c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: c.primaryStart.withValues(alpha: 0.4),
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
                color: isEnabled ? Colors.white : c.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // PDF Import methods removed as they should be in cv_choice_page.dart, not language selection
}
