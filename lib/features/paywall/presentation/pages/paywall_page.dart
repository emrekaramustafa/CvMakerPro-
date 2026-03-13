import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../data/services/revenue_cat_service.dart';
import '../../settings/presentation/pages/legal_page.dart';

class PaywallPage extends StatefulWidget {
  final bool allowDismiss;
  const PaywallPage({super.key, this.allowDismiss = true});

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

// ─── Demo pricing data (replace with RC values when ready) ───────────────────
class _DemoPlan {
  final String id;
  final String period;
  final String price;
  final String pricePerWeek;
  final String? badge;
  final String? savingsBadge;
  final bool isPopular;

  const _DemoPlan({
    required this.id,
    required this.period,
    required this.price,
    required this.pricePerWeek,
    this.badge,
    this.savingsBadge,
    this.isPopular = false,
  });
}

class _PaywallPageState extends State<PaywallPage> with TickerProviderStateMixin {
  final RevenueCatService _service = RevenueCatService();

  bool _isLoadingOfferings = true;
  bool _isPurchasing = false;
  bool _isRestoring = false;

  Offering? _offering;
  Package? _selectedPackage;

  // Demo plans — swap with RC packages when available
  List<_DemoPlan> get _demoPlans => [
    _DemoPlan(
      id: 'weekly',
      period: 'paywall.plan_weekly_label'.tr(),
      price: '₺49,99',
      pricePerWeek: '₺49,99/${'paywall.plan_per_week'.tr()}',
    ),
    _DemoPlan(
      id: 'monthly',
      period: 'paywall.plan_monthly_label'.tr(),
      price: '₺149,99',
      pricePerWeek: '₺37,50/${'paywall.plan_per_week'.tr()}',
      badge: 'paywall.badge_popular'.tr(),
      isPopular: true,
    ),
    _DemoPlan(
      id: 'annual',
      period: 'paywall.plan_annual_label'.tr(),
      price: '₺699,99',
      pricePerWeek: '₺13,46/${'paywall.plan_per_week'.tr()}',
      badge: 'paywall.badge_best_value'.tr(),
      savingsBadge: 'paywall.badge_save'.tr(),
    ),
  ];

  String _selectedDemoPlanId = 'annual';

  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _loadOfferings();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadOfferings() async {
    try {
      final offering = await _service.getCurrentOffering();
      if (mounted) {
        setState(() {
          _offering = offering;
          _selectedPackage = offering?.annual ?? offering?.monthly ?? offering?.availablePackages.firstOrNull;
          _isLoadingOfferings = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingOfferings = false);
    }
  }

  Future<void> _handlePurchase() async {
    if (_offering != null && _selectedPackage != null) {
      // Mocking premium purchase
      setState(() => _isPurchasing = true);
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      if (!mounted) return;
      
      setState(() => _isPurchasing = false);
      
      // Simulate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Analysis Successful'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } else {
      // Demo: just pop
      Navigator.pop(context, true);
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
            colors: [Color(0xFF0A0F1E), Color(0xFF1A1040), Color(0xFF0D1B3E)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(top: -60, right: -40, child: _glowCircle(200, const Color(0xFF6C47FF), 0.12)),
            Positioned(bottom: 120, left: -60, child: _glowCircle(180, const Color(0xFFFFD700), 0.07)),

            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          _buildHero(),
                          const SizedBox(height: 16),
                          _buildSocialProof(),
                          const SizedBox(height: 16),
                          _buildFeatures(),
                          const SizedBox(height: 20),
                          _buildPricingCards(),
                          const SizedBox(height: 18),
                          _buildCTA(),
                          const SizedBox(height: 10),
                          _buildRestoreButton(),
                          const SizedBox(height: 8),
                          _buildTrustBar(),
                          const SizedBox(height: 12),
                          _buildLegalNote(),
                          const SizedBox(height: 12),
                          _buildLegalLinks(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowCircle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
        boxShadow: [BoxShadow(color: color.withOpacity(opacity * 1.5), blurRadius: 80, spreadRadius: 20)],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          if (widget.allowDismiss)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
              ),
            )
          else
            const SizedBox(width: 40),
          const Spacer(),
          // Premium badge in header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.35), blurRadius: 12)],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.black, size: 14),
                SizedBox(width: 4),
                Text('PRO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1)),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (_, __) => Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.22 + _pulseController.value * 0.22),
                  blurRadius: 20 + _pulseController.value * 14,
                  spreadRadius: 2 + _pulseController.value * 3,
                ),
              ],
            ),
            child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'paywall.hero_title'.tr(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.8, height: 1.2),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'paywall.hero_subtitle'.tr(),
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.55)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSocialProof() {
    // Real face photos via pravatar.cc
    final avatarUrls = [
      'https://i.pravatar.cc/60?img=47',
      'https://i.pravatar.cc/60?img=32',
      'https://i.pravatar.cc/60?img=12',
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 28,
                  child: Stack(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Positioned(
                          left: i * 18.0,
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF0A0F1E), width: 2),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                avatarUrls[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: [const Color(0xFF6C47FF), const Color(0xFFFF6B6B), const Color(0xFF11998E)][i],
                                  child: const Icon(Icons.person, color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('paywall.social_count'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis),
                      Text('paywall.social_subtitle'.tr(), style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 12),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 12),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 12),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 12),
                Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 12),
              ]),
              Text('4.9/5', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      (Icons.auto_awesome_rounded, 'paywall.feature_ai_magic'.tr()),
      (Icons.picture_as_pdf_rounded, 'paywall.feature_unlimited_pdf'.tr()),
      (Icons.style_rounded, 'paywall.feature_all_templates'.tr()),
      (Icons.share_rounded, 'paywall.feature_share'.tr()),
      (Icons.psychology_rounded, 'paywall.feature_ats'.tr()),
      (Icons.block_rounded, 'paywall.feature_no_watermark'.tr()),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('paywall.features_title'.tr(), style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: features.map((f) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF6C47FF), Color(0xFF3B82F6)]),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(f.$1, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 7),
                  Text(f.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCards() {
    // Pull RC packages if available
    final rcPackages = _offering?.availablePackages ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'paywall.plan_select'.tr(),
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 14),
        if (rcPackages.isNotEmpty)
          ...rcPackages.map((pkg) => _buildRCPackageTile(pkg))
        else
          ..._demoPlans.map((plan) => _buildDemoPlanTile(plan)),
      ],
    );
  }

  Widget _buildDemoPlanTile(_DemoPlan plan) {
    final isSelected = _selectedDemoPlanId == plan.id;
    final isAnnual = plan.id == 'annual';

    return GestureDetector(
      onTap: () => setState(() => _selectedDemoPlanId = plan.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isAnnual
                      ? [const Color(0xFFFFD700).withOpacity(0.18), const Color(0xFFFFA000).withOpacity(0.08)]
                      : [const Color(0xFF6C47FF).withOpacity(0.22), const Color(0xFF3B82F6).withOpacity(0.08)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? (isAnnual ? const Color(0xFFFFD700) : const Color(0xFF6C47FF))
                : Colors.white.withOpacity(0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Radio
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? (isAnnual
                          ? const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA000)])
                          : const LinearGradient(colors: [Color(0xFF6C47FF), Color(0xFF3B82F6)]))
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.period,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        if (plan.badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isAnnual
                                    ? [const Color(0xFFFFD700), const Color(0xFFFFA000)]
                                    : [const Color(0xFF6C47FF), const Color(0xFF3B82F6)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              plan.badge!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      plan.pricePerWeek,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Price + savings
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    plan.price,
                    style: TextStyle(
                      color: isSelected
                          ? (isAnnual ? const Color(0xFFFFD700) : const Color(0xFF8B73FF))
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (plan.savingsBadge != null)
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.green.withOpacity(0.4)),
                      ),
                      child: Text(
                        plan.savingsBadge!,
                        style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRCPackageTile(Package pkg) {
    final isSelected = _selectedPackage?.identifier == pkg.identifier;
    final product = pkg.storeProduct;
    String period;
    String? badge;
    bool isAnnual = false;
    switch (pkg.packageType) {
      case PackageType.weekly:
        period = 'paywall.plan_weekly_label'.tr();
        break;
      case PackageType.monthly:
        period = 'paywall.plan_monthly_label'.tr();
        badge = 'paywall.badge_popular'.tr();
        break;
      case PackageType.annual:
        period = 'paywall.plan_annual_label'.tr();
        badge = 'paywall.badge_best_value'.tr();
        isAnnual = true;
        break;
      default:
        period = product.title;
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = pkg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isAnnual
                      ? [const Color(0xFFFFD700).withOpacity(0.18), const Color(0xFFFFA000).withOpacity(0.08)]
                      : [const Color(0xFF6C47FF).withOpacity(0.22), const Color(0xFF3B82F6).withOpacity(0.08)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? (isAnnual ? const Color(0xFFFFD700) : const Color(0xFF6C47FF))
                : Colors.white.withOpacity(0.12),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? LinearGradient(colors: isAnnual
                    ? [const Color(0xFFFFD700), const Color(0xFFFFA000)]
                    : [const Color(0xFF6C47FF), const Color(0xFF3B82F6)]) : null,
                color: isSelected ? null : Colors.transparent,
                border: Border.all(color: isSelected ? Colors.transparent : Colors.white38, width: 2),
              ),
              child: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Text(period, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.w700, fontSize: 16)),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: isAnnual
                            ? [const Color(0xFFFFD700), const Color(0xFFFFA000)]
                            : [const Color(0xFF6C47FF), const Color(0xFF3B82F6)]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ],
              ),
            ),
            Text(product.priceString, style: TextStyle(
              color: isSelected ? (isAnnual ? const Color(0xFFFFD700) : const Color(0xFF8B73FF)) : Colors.white,
              fontSize: 18, fontWeight: FontWeight.w800,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA() {
    final selectedAnnual = _selectedDemoPlanId == 'annual' || _selectedPackage?.packageType == PackageType.annual;

    return GestureDetector(
      onTap: (_isPurchasing || _isRestoring) ? null : _handlePurchase,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: selectedAnnual
                ? [const Color(0xFFFFD700), const Color(0xFFFF8C00)]
                : [const Color(0xFF6C47FF), const Color(0xFF3B82F6)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: (selectedAnnual ? const Color(0xFFFFD700) : const Color(0xFF6C47FF)).withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: _isPurchasing
            ? const Center(
                child: SizedBox(
                  width: 24, height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                ),
              )
            : Column(
                children: [
                  Text(
                    'paywall.cta_button'.tr(),
                    style: TextStyle(
                      color: selectedAnnual ? Colors.black : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'paywall.cta_cancel'.tr(),
                    style: TextStyle(
                      color: (selectedAnnual ? Colors.black : Colors.white).withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return GestureDetector(
      onTap: (_isRestoring || _isPurchasing) ? null : _restore,
      child: Text(
        _isRestoring ? 'paywall.restore_checking'.tr() : 'paywall.restore_purchases'.tr(),
        style: TextStyle(color: Colors.white.withOpacity(0.38), fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTrustBar() {
    final items = [
      (Icons.lock_rounded, 'paywall.trust_secure'.tr()),
      (Icons.cancel_rounded, 'paywall.trust_cancel'.tr()),
      (Icons.devices_rounded, 'paywall.trust_devices'.tr()),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: items.map((item) => Column(
        children: [
          Icon(item.$1, color: Colors.white.withOpacity(0.35), size: 18),
          const SizedBox(height: 4),
          Text(item.$2, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10), textAlign: TextAlign.center),
        ],
      )).toList(),
    );
  }

  Widget _buildLegalNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'paywall.legal_note'.tr(),
        style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 10, height: 1.4),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLegalLinks() {
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.4),
      fontSize: 11,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LegalPage(
                title: 'settings.privacy_policy'.tr(),
                contentKey: 'privacy_policy_text',
              ),
            ),
          ),
          child: Text('settings.privacy_policy'.tr(), style: textStyle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('•', style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10)),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LegalPage(
                title: 'settings.terms_of_service'.tr(),
                contentKey: 'terms_of_service_text',
              ),
            ),
          ),
          child: Text('settings.terms_of_service'.tr(), style: textStyle),
        ),
      ],
    );
  }
}
