import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import 'legal_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = "${info.version} (${info.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      backgroundColor: c.backgroundStart,
      appBar: AppBar(
        title: Text('settings.title'.tr(), style: TextStyle(color: c.textPrimary)),
        iconTheme: IconThemeData(color: c.textPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('settings.language'.tr(), c),
          _buildLanguageCard(context, c),
          
          const SizedBox(height: 24),
          _buildSectionTitle('settings.theme'.tr(), c),
          _buildThemeCard(c),

          const SizedBox(height: 24),
          _buildSectionTitle('settings.legal'.tr(), c),
          _buildLegalCard(context, c),

          const SizedBox(height: 24),
          _buildSectionTitle('settings.about'.tr(), c),
          _buildAboutCard(context, c),
          
          const SizedBox(height: 30),
          Center(
            child: Text(
              "${'settings.app_version'.tr()} $_version",
              style: TextStyle(color: c.textTertiary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorsDynamic c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: c.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildCard(AppColorsDynamic c, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildLanguageCard(BuildContext context, AppColorsDynamic c) {
    return _buildCard(c,
      children: [
        ListTile(
          leading: Icon(Icons.language, color: c.primaryStart),
          title: Text('settings.language'.tr(), style: TextStyle(color: c.textPrimary)),
          subtitle: Text(_getCurrentLanguageName(context), style: TextStyle(color: c.textSecondary)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: c.textTertiary),
          onTap: () => _showLanguageBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildThemeCard(AppColorsDynamic c) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return _buildCard(c,
          children: [
            SwitchListTile(
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: c.primaryStart,
              ),
              title: Text(
                'settings.dark_mode'.tr(),
                style: TextStyle(color: c.textPrimary),
              ),
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.setDarkMode(val),
              activeColor: AppColors.primaryStart,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegalCard(BuildContext context, AppColorsDynamic c) {
    return _buildCard(c,
      children: [
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined, color: c.textSecondary),
          title: Text('settings.privacy_policy'.tr(), style: TextStyle(color: c.textPrimary)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: c.textTertiary),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LegalPage(
                title: 'settings.privacy_policy'.tr(),
                contentKey: 'privacy_policy_text',
              ),
            ),
          ),
        ),
        const Divider(height: 1, indent: 56),
        ListTile(
          leading: Icon(Icons.description_outlined, color: c.textSecondary),
          title: Text('settings.terms_of_service'.tr(), style: TextStyle(color: c.textPrimary)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: c.textTertiary),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LegalPage(
                title: 'settings.terms_of_service'.tr(),
                contentKey: 'terms_of_service_text',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutCard(BuildContext context, AppColorsDynamic c) {
    return _buildCard(c,
      children: [
        ListTile(
          leading: Icon(Icons.mail_outline, color: c.textSecondary),
          title: Text('settings.contact'.tr(), style: TextStyle(color: c.textPrimary)),
          onTap: () => _launchEmail(),
        ),
        const Divider(height: 1, indent: 56),
        ListTile(
          leading: Icon(Icons.share_outlined, color: c.textSecondary),
          title: Text('settings.share_app'.tr(), style: TextStyle(color: c.textPrimary)),
          onTap: () => Share.share('Check out AI Resume Pro! Create professional CVs in minutes.'),
        ),
        const Divider(height: 1, indent: 56),
        ListTile(
          leading: Icon(Icons.star_outline, color: c.textSecondary),
          title: Text('settings.rate_app'.tr(), style: TextStyle(color: c.textPrimary)),
          onTap: () async {
            try {
              final InAppReview inAppReview = InAppReview.instance;
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              } else {
                inAppReview.openStoreListing(appStoreId: 'YOUR_APP_STORE_ID'); // Replace with real ID later
              }
            } catch (e) {
              debugPrint('Error launching review: $e');
            }
          },
        ),
      ],
    );
  }

  String _getCurrentLanguageName(BuildContext context) {
    final currentLocale = context.locale.languageCode;
    switch (currentLocale) {
      case 'tr': return 'Türkçe';
      case 'de': return 'Deutsch';
      case 'fr': return 'Français';
      case 'es': return 'Español';
      case 'pt': return 'Português';
      default: return 'English';
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 100, // Move up by 100 pixels
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: c.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'settings.language'.tr(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: c.textPrimary),
            ),
            const SizedBox(height: 8),
            _buildLanguageOption(context, 'English', const Locale('en'), c),
            _buildLanguageOption(context, 'Türkçe', const Locale('tr'), c),
            _buildLanguageOption(context, 'Deutsch', const Locale('de'), c),
            _buildLanguageOption(context, 'Français', const Locale('fr'), c),
            _buildLanguageOption(context, 'Español', const Locale('es'), c),
            _buildLanguageOption(context, 'Português', const Locale('pt'), c),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String name, Locale locale, AppColorsDynamic c) {
    final isSelected = context.locale.languageCode == locale.languageCode;
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        name,
        style: TextStyle(
          color: isSelected ? c.primaryStart : c.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: c.primaryStart, size: 20) : null,
      onTap: () {
        context.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@airesumepro.com',
      query: 'subject=Support: AI Resume Pro',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }
}
