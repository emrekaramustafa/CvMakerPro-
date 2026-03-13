import 'dart:io';
import 'dart:developer';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/constants/app_constants.dart';

/// Real RevenueCat service.
/// - Configure on app startup via [init].
/// - All purchase / restore / status methods delegate to the SDK.
class RevenueCatService {
  bool _isConfigured = false;
  bool get isConfigured => _isConfigured;
  // ─── Init ────────────────────────────────────────────────────────────────

  Future<void> init() async {
    try {
      // Pick the right key for the current platform
      final apiKey = Platform.isIOS
          ? AppConstants.revenueCatIosKey
          : AppConstants.revenueCatAndroidKey;

      if (apiKey.isEmpty) {
        log('⚠️ RevenueCat: API key is empty — purchases will not work. '
            'Pass RC_IOS_KEY / RC_ANDROID_KEY via --dart-define.');
        _isConfigured = false;
        return;
      }

      await Purchases.setLogLevel(LogLevel.info);
      final config = PurchasesConfiguration(apiKey);
      await Purchases.configure(config);
      _isConfigured = true;
      log('✅ RevenueCat configured successfully (${Platform.isIOS ? "iOS" : "Android"})');
    } catch (e) {
      _isConfigured = false;
      log('❌ RevenueCat init error: $e');
    }
  }

  // ─── Status ──────────────────────────────────────────────────────────────

  /// Returns true if the user has an active "premium" entitlement.
  Future<bool> isPremium() async {
    if (!_isConfigured) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active
          .containsKey(AppConstants.revenueCatEntitlement);
    } catch (e) {
      log('❌ RevenueCat isPremium error: $e');
      return false;
    }
  }

  /// Alias kept for compatibility.
  Future<bool> checkStatus() => isPremium();

  // ─── Offerings / Prices ───────────────────────────────────────────────────

  /// Fetches the current offering from RevenueCat.
  /// Returns null if the offering cannot be loaded.
  Future<Offering?> getCurrentOffering() async {
    if (!_isConfigured) return null;
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      log('❌ RevenueCat getOfferings error: $e');
      return null;
    }
  }

  /// Returns a simple {productId → localizedPriceString} map for the current
  /// offering. Falls back to empty map if not available.
  Future<Map<String, String>> getPrices() async {
    try {
      final offering = await getCurrentOffering();
      if (offering == null) return {};

      final result = <String, String>{};
      for (final pkg in offering.availablePackages) {
        result[pkg.storeProduct.identifier] =
            pkg.storeProduct.priceString;
      }
      return result;
    } catch (e) {
      log('❌ RevenueCat getPrices error: $e');
      return {};
    }
  }

  // ─── Purchase ─────────────────────────────────────────────────────────────

  /// Purchases a package by its RevenueCat [Package] object.
  /// Prefer [purchasePackageObject] for type-safety.
  Future<bool> purchasePackage(String productId) async {
    try {
      final offering = await getCurrentOffering();
      if (offering == null) {
        log('❌ RevenueCat: no offering available');
        return false;
      }

      final pkg = offering.availablePackages.firstWhere(
        (p) => p.storeProduct.identifier == productId,
        orElse: () => offering.availablePackages.first,
      );

      return await purchasePackageObject(pkg);
    } catch (e) {
      log('❌ RevenueCat purchasePackage error: $e');
      return false;
    }
  }

  /// Purchases a [Package] object directly (preferred).
  Future<bool> purchasePackageObject(Package package) async {
    try {
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      final isNowPremium = result.customerInfo.entitlements.active
          .containsKey(AppConstants.revenueCatEntitlement);
      log(isNowPremium
          ? '✅ Purchase succeeded — premium unlocked'
          : '⚠️ Purchase completed but entitlement not active');
      return isNowPremium;
    } on PurchasesErrorCode catch (errorCode) {
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        log('ℹ️ Purchase cancelled by user');
        return false;
      }
      log('❌ RevenueCat purchase error: $errorCode');
      return false;
    } catch (e) {
      log('❌ RevenueCat purchasePackageObject error: $e');
      return false;
    }
  }

  /// Legacy method — kept for PaywallPage compatibility.
  Future<bool> purchasePremium() async {
    try {
      final offering = await getCurrentOffering();
      if (offering == null) return false;
      // Default to monthly if available, otherwise first package
      final pkg = offering.monthly ?? offering.availablePackages.first;
      return await purchasePackageObject(pkg);
    } catch (e) {
      log('❌ RevenueCat purchasePremium error: $e');
      return false;
    }
  }

  // ─── Restore ──────────────────────────────────────────────────────────────

  /// Restores previous purchases and returns whether premium is now active.
  Future<bool> restorePurchases() async {
    if (!_isConfigured) return false;
    try {
      final info = await Purchases.restorePurchases();
      final isNowPremium = info.entitlements.active
          .containsKey(AppConstants.revenueCatEntitlement);
      log(isNowPremium
          ? '✅ Restore succeeded — premium unlocked'
          : 'ℹ️ Restore completed but no active premium entitlement');
      return isNowPremium;
    } catch (e) {
      log('❌ RevenueCat restorePurchases error: $e');
      return false;
    }
  }

  // ─── Debug ────────────────────────────────────────────────────────────────

  /// Only useful during development. No-op in this real implementation.
  Future<void> debugClearPremium() async {
    log('ℹ️ debugClearPremium is a no-op in real RevenueCat mode');
  }
}
