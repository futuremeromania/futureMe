import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:futureme/core/subscription/revenue_cat_config.dart';

/// Wraps the RevenueCat SDK, which brokers real Apple App Store / Google
/// Play subscription purchases and tells us whether a user has an active
/// entitlement. Every call no-ops (or returns a safe default) while
/// [RevenueCatConfig.isConfigured] is false, so the app keeps working
/// before those keys are filled in — see [RevenueCatConfig] for setup.
@lazySingleton
class SubscriptionService {
  bool _configured = false;

  bool get isAvailable => !kIsWeb && RevenueCatConfig.isConfigured;

  /// Call once at app startup, after Firebase is initialized.
  Future<void> configure() async {
    if (!isAvailable || _configured) return;
    final apiKey = Platform.isIOS ? RevenueCatConfig.iosApiKey : RevenueCatConfig.androidApiKey;
    await Purchases.configure(PurchasesConfiguration(apiKey));
    _configured = true;
  }

  /// Aliases the RevenueCat app user with the Firebase [uid] so entitlement
  /// state follows the account across devices/reinstalls.
  Future<void> logIn(String uid) async {
    if (!_configured) return;
    await Purchases.logIn(uid);
  }

  Future<void> logOut() async {
    if (!_configured) return;
    try {
      await Purchases.logOut();
    } catch (_) {
      // Already logged out / anonymous — nothing to do.
    }
  }

  Future<bool> hasActiveEntitlement() async {
    if (!_configured) return false;
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(RevenueCatConfig.entitlementId);
  }

  /// The current offering configured in the RevenueCat dashboard (expected
  /// to contain the monthly plan package), or null if unavailable/not
  /// configured yet.
  Future<Offering?> getCurrentOffering() async {
    if (!_configured) return null;
    final offerings = await Purchases.getOfferings();
    return offerings.current;
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  /// Re-links a previous App Store/Google Play purchase to this account
  /// (e.g. after a reinstall). Returns whether the entitlement is active.
  Future<bool> restorePurchases() async {
    if (!_configured) return false;
    final info = await Purchases.restorePurchases();
    return info.entitlements.active.containsKey(RevenueCatConfig.entitlementId);
  }
}
