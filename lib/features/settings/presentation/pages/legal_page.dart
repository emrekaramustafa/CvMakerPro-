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

  List<_LegalSection> get _privacySections => [
    _LegalSection(heading: 'legal.privacy.s1_heading'.tr(), body: 'legal.privacy.s1_body'.tr()),
    _LegalSection(heading: 'legal.privacy.s2_heading'.tr(), body: 'legal.privacy.s2_body'.tr()),
    _LegalSection(heading: 'legal.privacy.s3_heading'.tr(), body: 'legal.privacy.s3_body'.tr()),
    _LegalSection(heading: 'legal.privacy.s4_heading'.tr(), body: 'legal.privacy.s4_body'.tr()),
    _LegalSection(heading: 'legal.privacy.s5_heading'.tr(), body: 'legal.privacy.s5_body'.tr()),
    _LegalSection(heading: 'legal.privacy.s6_heading'.tr(), body: 'legal.privacy.s6_body'.tr()),
  ];

  List<_LegalSection> get _termsSections => [
    _LegalSection(heading: 'legal.terms.s1_heading'.tr(), body: 'legal.terms.s1_body'.tr()),
    _LegalSection(heading: 'legal.terms.s2_heading'.tr(), body: 'legal.terms.s2_body'.tr()),
    _LegalSection(heading: 'legal.terms.s3_heading'.tr(), body: 'legal.terms.s3_body'.tr()),
    _LegalSection(heading: 'legal.terms.s4_heading'.tr(), body: 'legal.terms.s4_body'.tr()),
    _LegalSection(heading: 'legal.terms.s5_heading'.tr(), body: 'legal.terms.s5_body'.tr()),
    _LegalSection(heading: 'legal.terms.s6_heading'.tr(), body: 'legal.terms.s6_body'.tr()),
  ];

  List<_LegalSection> get _sections =>
      contentKey == 'privacy_policy_text' ? _privacySections : _termsSections;

  String get _webUrl =>
      contentKey == 'privacy_policy_text'
          ? 'https://emrekaramustafa.github.io/cv-maker-pro-legal/privacy-policy.html'
          : 'https://emrekaramustafa.github.io/cv-maker-pro-legal/terms-of-service.html';

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(_webUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
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

            // ── Web URL card ──────────────────────────────────────────
            GestureDetector(
              onTap: _openInBrowser,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [c.primaryStart.withValues(alpha: 0.12), c.primaryMid.withValues(alpha: 0.06)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.primaryStart.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.open_in_browser_rounded, color: c.primaryMid, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'legal.view_online'.tr(),
                      style: TextStyle(
                        color: c.primaryMid,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

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
