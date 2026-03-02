import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../data/services/revenue_cat_service.dart';

/// Full paywall page with real RevenueCat offerings.
///
/// Shows packages loaded from the current RC offering.
/// Falls back to a single "Unlock Premium" button if offerings
/// can't be loaded (e.g. no network, key not yet set).
class PaywallPage extends StatefulWidget {
  const PaywallPage({super.key});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  final RevenueCatService _service = RevenueCatService();

  bool _isLoadingOfferings = true;
  bool _isPurchasing = false;
  bool _isRestoring = false;

  Offering? _offering;
  Package? _selectedPackage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() {
      _isLoadingOfferings = true;
      _errorMessage = null;
    });
    try {
      final offering = await _service.getCurrentOffering();
      if (mounted) {
        setState(() {
          _offering = offering;
          // Pre-select the monthly package (or first available)
          _selectedPackage =
              offering?.monthly ?? offering?.availablePackages.firstOrNull;
          _isLoadingOfferings = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingOfferings = false;
          _errorMessage = 'paywall.offerings_error'.tr();
        });
      }
    }
  }

  Future<void> _purchase(Package package) async {
    setState(() => _isPurchasing = true);
    final success = await _service.purchasePackageObject(package);
    if (!mounted) return;
    setState(() => _isPurchasing = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('paywall.purchase_failed'.tr())),
      );
    }
  }

  Future<void> _restore() async {
    setState(() => _isRestoring = true);
    final success = await _service.restorePurchases();
    if (!mounted) return;
    setState(() => _isRestoring = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('paywall.restore_success'.tr())),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('paywall.restore_none'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B2A4A), Color(0xFF2D1B69)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Close button ───────────────────────────────────────────
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // ── Hero ───────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildHeroSection(),
                      const SizedBox(height: 32),
                      _buildFeatureList(),
                      const SizedBox(height: 32),
                      _buildPackagesSection(),
                      const SizedBox(height: 24),
                      _buildPurchaseButton(),
                      const SizedBox(height: 16),
                      _buildRestoreButton(),
                      const SizedBox(height: 8),
                      _buildLegalNote(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(Icons.workspace_premium, color: Colors.white, size: 44),
        ),
        const SizedBox(height: 20),
        Text(
          'paywall.title'.tr(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'paywall.subtitle'.tr(),
          style: const TextStyle(fontSize: 15, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [
      ('paywall.feature_unlimited_pdf', Icons.picture_as_pdf_outlined),
      ('paywall.feature_ai_tools', Icons.auto_awesome),
      ('paywall.feature_all_templates', Icons.style_outlined),
      ('paywall.feature_no_watermark', Icons.block),
    ];

    return Column(
      children: features.map((f) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(f.$2, color: const Color(0xFFFFD700), size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                f.$1.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPackagesSection() {
    if (_isLoadingOfferings) {
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(_errorMessage!, style: const TextStyle(color: Colors.white54), textAlign: TextAlign.center),
      );
    }

    final packages = _offering?.availablePackages ?? [];
    if (packages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: packages.map((pkg) => _buildPackageTile(pkg)).toList(),
    );
  }

  Widget _buildPackageTile(Package pkg) {
    final isSelected = _selectedPackage?.identifier == pkg.identifier;
    final product = pkg.storeProduct;

    // Human-readable period label
    String period;
    switch (pkg.packageType) {
      case PackageType.weekly:
        period = 'paywall.period_weekly'.tr();
        break;
      case PackageType.monthly:
        period = 'paywall.period_monthly'.tr();
        break;
      case PackageType.annual:
        period = 'paywall.period_yearly'.tr();
        break;
      default:
        period = product.title;
    }

    final isPopular = pkg.packageType == PackageType.monthly;

    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = pkg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFFD700).withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFD700) : Colors.white38,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        period,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (isPopular) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'paywall.popular'.tr(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (product.description.isNotEmpty)
                    Text(
                      product.description,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                ],
              ),
            ),
            Text(
              product.priceString,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFD700) : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton() {
    final canPurchase = _selectedPackage != null && !_isPurchasing && !_isRestoring;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          disabledBackgroundColor: const Color(0xFFFFD700).withOpacity(0.4),
        ),
        onPressed: canPurchase
            ? () => _purchase(_selectedPackage!)
            : null,
        child: _isPurchasing
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Text(
                'paywall.unlock_now'.tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return TextButton(
      onPressed: (_isRestoring || _isPurchasing) ? null : _restore,
      child: _isRestoring
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
            )
          : Text(
              'paywall.restore_purchases'.tr(),
              style: const TextStyle(color: Colors.white54),
            ),
    );
  }

  Widget _buildLegalNote() {
    return Text(
      'paywall.legal_note'.tr(),
      style: const TextStyle(color: Colors.white24, fontSize: 10),
      textAlign: TextAlign.center,
    );
  }
}
