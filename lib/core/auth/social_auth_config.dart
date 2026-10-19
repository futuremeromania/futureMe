import 'package:flutter/foundation.dart';

/// Google OAuth client IDs — Google Sign-In cannot work until these are
/// filled in. They only exist once you enable "Google" as a sign-in
/// provider for the `futureme-a6ea7` Firebase project:
///
/// Firebase Console → Authentication → Sign-in method → enable Google.
/// That auto-creates the OAuth clients below (Google Cloud Console →
/// APIs & Services → Credentials also lists them):
///  - `androidServerClientId`: the "Web client ID" shown under Google's
///    "Web SDK configuration" in the Firebase Console — Android needs this
///    as the audience for the ID token it requests, even though it's not
///    itself an Android client. Still a placeholder: Android Google
///    Sign-In stays disabled until it's filled in.
///  - `iosClientId`: the separate "iOS client" OAuth client ID for this
///    project's iOS app (`ro.futureme.app`). The matching reversed client
///    id is already set as a `CFBundleURLTypes` scheme in
///    `ios/Runner/Info.plist`.
class SocialAuthConfig {
  SocialAuthConfig._();

  static const androidServerClientId = 'REPLACE_WITH_FIREBASE_WEB_CLIENT_ID';
  static const iosClientId =
      '283516933465-jnd8rlgt5beu1sib5gbrjmjeiv0s0npr.apps.googleusercontent.com';

  static bool get hasAndroidServerClientId =>
      androidServerClientId != 'REPLACE_WITH_FIREBASE_WEB_CLIENT_ID';

  static bool get hasIosClientId =>
      iosClientId != 'REPLACE_WITH_FIREBASE_IOS_CLIENT_ID';

  static bool get isGoogleConfigured =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? hasIosClientId
          : hasAndroidServerClientId;
}