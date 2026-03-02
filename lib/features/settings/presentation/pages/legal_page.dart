import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

/// Displays real Privacy Policy or Terms of Service content.
/// The [contentKey] determines which document is shown:
///   - 'privacy_policy_text'  → Privacy Policy
///   - 'terms_of_service_text' → Terms of Service
class LegalPage extends StatelessWidget {
  final String title;
  final String contentKey;

  const LegalPage({
    super.key,
    required this.title,
    required this.contentKey,
  });

  // ────────────────────────────────────────────────────────────────────────────
  // PRIVACY POLICY — mirrors website/privacy-policy.html
  // ────────────────────────────────────────────────────────────────────────────
  static const List<_LegalSection> _privacySections = [
    _LegalSection(
      heading: '1. Introduction',
      body:
          'Welcome to CV Maker Pro+ (the "App"). We are committed to protecting '
          'your privacy and ensuring you have a positive experience when you use '
          'our mobile application. This Privacy Policy outlines our data handling '
          'practices, particularly concerning the advanced AI and biometrics '
          'features we provide.',
    ),
    _LegalSection(
      heading: '2. Data We Collect and How We Use It',
      body:
          'To provide you with highly customized and professional resumes, we '
          'collect and process certain information:\n\n'
          '• Camera and Photo Library Access: We request access to your device\'s '
          'camera and photo library strictly to allow you to upload or capture a '
          'profile picture for your resume.\n\n'
          '• Biometric Data (Face Detection): We utilize on-device ML Kit Face '
          'Detection technology to automatically identify and properly crop faces '
          'in the photos you upload. This process happens entirely on your device. '
          'We do not transmit, collect, or store any biometric face data on our '
          'servers.\n\n'
          '• Resume Information: The text data you input (experience, education, '
          'skills, etc.) is temporarily processed to generate your final PDF document.',
    ),
    _LegalSection(
      heading: '3. Third-Party AI Processing (OpenAI)',
      body:
          'Our App leverages advanced artificial intelligence provided by OpenAI '
          'to analyze, enhance, and format your resume content. When you use our '
          'AI features (such as ATS score analysis or smart text rewriting), the '
          'text data you provide is securely sent to OpenAI\'s servers for '
          'processing. This data is only used to generate your requested response '
          'and is not used by OpenAI to train their models, in accordance with '
          'OpenAI\'s API data usage policies.',
    ),
    _LegalSection(
      heading: '4. In-App Purchases and Subscriptions',
      body:
          'We use RevenueCat to manage our in-app purchases and premium '
          'subscriptions securely. RevenueCat processes your purchase history '
          'anonymously to grant you access to premium features (like PDF downloads '
          'and AI tools) across your devices. We do not have access to your raw '
          'credit card information.',
    ),
    _LegalSection(
      heading: '5. Data Retention and Security',
      body:
          'Your privacy is our priority. Your generated resumes and entered data '
          'are primarily stored locally on your device. Any data transmitted to '
          'AI models is encrypted in transit and is only retained for as long as '
          'necessary to fulfill the immediate request. We do not sell, rent, or '
          'trade any of your personal information to third parties.',
    ),
    _LegalSection(
      heading: '6. Contact Us',
      body:
          'If you have any questions or concerns about this Privacy Policy or our '
          'data practices, please contact us at:\n\n'
          'mehmetemrekaramustafa@gmail.com',
    ),
  ];

  // ────────────────────────────────────────────────────────────────────────────
  // TERMS OF SERVICE — mirrors website/terms-of-service.html
  // ────────────────────────────────────────────────────────────────────────────
  static const List<_LegalSection> _termsSections = [
    _LegalSection(
      heading: '1. Agreement to Terms',
      body:
          'By downloading or using CV Maker Pro+, you agree to be bound by these '
          'Terms of Use. If you disagree with any part of these terms, you may not '
          'access or use the application.',
    ),
    _LegalSection(
      heading: '2. License to Use',
      body:
          'We grant you a personal, non-exclusive, non-transferable, and revocable '
          'license to use the app for your personal, non-commercial purposes. You '
          'may not distribute, modify, reverse engineer, or create derivative works '
          'from the application.',
    ),
    _LegalSection(
      heading: '3. AI Features and Disclaimer',
      body:
          'Our app utilizes third-party artificial intelligence algorithms (such as '
          'OpenAI) to assist you in creating resumes. While we strive for accuracy, '
          'the AI-generated content may be incomplete, inaccurate, or require manual '
          'editing. You are solely responsible for reviewing and verifying any '
          'content generated by the AI before using it for professional applications.',
    ),
    _LegalSection(
      heading: '4. Subscriptions and Payments',
      body:
          'Some features of CV Maker Pro+ are available via an auto-renewing '
          'subscription or one-time purchases (In-App Purchases). Payments will be '
          'charged to your Apple ID or Google Play account at confirmation of '
          'purchase. Subscriptions automatically renew unless canceled at least '
          '24 hours before the end of the current period. You can manage and cancel '
          'your subscriptions by going to your App Store or Google Play account '
          'settings after purchase.',
    ),
    _LegalSection(
      heading: '5. User Guidelines',
      body:
          'You agree not to use the app for any unlawful purposes or to upload any '
          'content that is offensive, defamatory, or violates any third party\'s '
          'rights.',
    ),
    _LegalSection(
      heading: '6. Contact Information',
      body:
          'If you have any questions regarding these Terms, please contact us at:\n\n'
          'mehmetemrekaramustafa@gmail.com',
    ),
  ];

  List<_LegalSection> get _sections =>
      contentKey == 'privacy_policy_text' ? _privacySections : _termsSections;

  String get _webUrl =>
      contentKey == 'privacy_policy_text'
          ? 'https://emrekaramustafa.github.io/cv-maker-pro-legal/privacy-policy.html'
          : 'https://emrekaramustafa.github.io/cv-maker-pro-legal/terms-of-service.html';

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(_webUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      backgroundColor: c.backgroundStart,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: c.textPrimary)),
        iconTheme: IconThemeData(color: c.textPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.open_in_browser, color: c.textSecondary),
            tooltip: 'legal.open_in_browser'.tr(),
            onPressed: _openInBrowser,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Last-updated chip ──────────────────────────────────────
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: c.primaryStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: c.primaryStart.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'legal.last_updated'.tr(),
                style: TextStyle(
                  color: c.primaryStart,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ── Sections ──────────────────────────────────────────────
            ..._sections.map((section) => _buildSection(section, c)),

            const SizedBox(height: 20),

            // ── Footer note ───────────────────────────────────────────
            Center(
              child: Text(
                'legal.all_rights_reserved'.tr(),
                style: TextStyle(color: c.textTertiary, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(_LegalSection section, AppColorsDynamic c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.heading,
            style: TextStyle(
              color: c.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            section.body,
            style: TextStyle(
              color: c.textSecondary,
              fontSize: 14,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Simple data class for a document section ─────────────────────────────────
class _LegalSection {
  final String heading;
  final String body;
  const _LegalSection({required this.heading, required this.body});
}
