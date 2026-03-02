import 'package:flutter/foundation.dart';
import '../../../paywall/data/services/revenue_cat_service.dart';
import '../../../paywall/data/services/usage_limit_service.dart';
import '../../../../core/constants/app_constants.dart';

/// Global premium state provider.
/// Tracks whether the user is premium & handles weekly AI limits.
class PremiumProvider extends ChangeNotifier {
  final RevenueCatService _rcService;
  final UsageLimitService _usageService;

  bool _isPremium = false;
  int _weeklyAiUsage = 0;
  Map<String, String> _prices = {};
  bool _isLoading = false;

  PremiumProvider({
    RevenueCatService? rcService,
    UsageLimitService? usageService,
  })  : _rcService = rcService ?? RevenueCatService(),
        _usageService = usageService ?? UsageLimitService();

  // ─── Getters ─────────────────────────────────
  bool get isPremium => _isPremium;
  int get weeklyAiUsage => _weeklyAiUsage;
  int get weeklyAiRemaining =>
      (_isPremium ? AppConstants.weeklyAiLimitPremium - _weeklyAiUsage : 0).clamp(0, AppConstants.weeklyAiLimitPremium);
  bool get canUseAI => _isPremium && _weeklyAiUsage < AppConstants.weeklyAiLimitPremium;
  bool get isLoading => _isLoading;
  Map<String, String> get prices => _prices;

  // ─── Init (call from main.dart) ───────────────
  Future<void> initialize() async {
    await _rcService.init();
    await _refresh();
    _prices = await _rcService.getPrices();
    notifyListeners();
  }

  Future<void> _refresh() async {
    _isPremium = await _rcService.isPremium();
    _weeklyAiUsage = await _usageService.getWeeklyAiUsage();
  }

  // ─── Purchase ─────────────────────────────────
  Future<bool> purchasePackage(String productId) async {
    _isLoading = true;
    notifyListeners();

    final success = await _rcService.purchasePackage(productId);

    if (success) {
      await _refresh();
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ─── Restore ──────────────────────────────────
  Future<bool> restorePurchases() async {
    _isLoading = true;
    notifyListeners();

    final success = await _rcService.restorePurchases();

    if (success) {
      await _refresh();
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ─── AI Gate (for premium users) ─────────────
  /// Returns true and records usage if premium user still has AI quota.
  /// Returns false if limit reached (caller should show limit dialog).
  Future<bool> consumeAiCall() async {
    if (!_isPremium) return false; // caller should use free-trial gate instead
    if (_weeklyAiUsage >= AppConstants.weeklyAiLimitPremium) return false;

    await _usageService.recordWeeklyAiUsage();
    _weeklyAiUsage++;
    notifyListeners();
    return true;
  }

  // ─── Free Trial Gate (for free users) ─────────
  /// Returns true and records usage if the user still has a free trial for [featureKey].
  Future<bool> consumeFreeTrial(String featureKey) async {
    final hasRemaining = await _usageService.hasFreeTrialRemaining(featureKey);
    if (!hasRemaining) return false;

    await _usageService.recordFreeTrialUsage(featureKey);
    notifyListeners();
    return true;
  }

  /// Returns true if the user still has a free trial for [featureKey].
  Future<bool> hasFreeTrialRemaining(String featureKey) =>
      _usageService.hasFreeTrialRemaining(featureKey);

  // ─── Debug helpers ──────────────────────────
  Future<void> debugClearAll() async {
    await _rcService.debugClearPremium();
    await _usageService.resetAll();
    await _refresh();
    notifyListeners();
  }
}
