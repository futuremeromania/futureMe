/// RevenueCat API keys — Apple App Store / Google Play subscription
/// purchases can't work until these are filled in. Get them once you've:
///  1. Created a RevenueCat project (https://app.revenuecat.com).
///  2. Created the monthly subscription product in App Store Connect and
///     Google Play Console, and attached both to RevenueCat.
///  3. Created an Entitlement in the RevenueCat dashboard (Entitlements tab)
///     that both store products unlock, and set [entitlementId] to match it.
///  4. Copied the iOS and Android *public* API keys from
///     RevenueCat dashboard → Project settings → API keys.
class RevenueCatConfig {
  RevenueCatConfig._();

  static const iosApiKey = 'REPLACE_WITH_REVENUECAT_IOS_API_KEY';
  static const androidApiKey = 'REPLACE_WITH_REVENUECAT_ANDROID_API_KEY';

  /// Must match the entitlement identifier configured in the RevenueCat
  /// dashboard that the monthly plan unlocks.
  static const entitlementId = 'premium';

  static bool get isConfigured =>
      iosApiKey != 'REPLACE_WITH_REVENUECAT_IOS_API_KEY' && androidApiKey != 'REPLACE_WITH_REVENUECAT_ANDROID_API_KEY';
}
