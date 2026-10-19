import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:futureme/core/auth/social_auth_config.dart';
import 'package:futureme/core/subscription/subscription_service.dart';

@lazySingleton
class AuthService {
  AuthService(this._firebaseAuth, this._subscriptionService);

  final FirebaseAuth _firebaseAuth;
  final SubscriptionService _subscriptionService;
  bool _googleSignInInitialized = false;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _subscriptionService.logOut();
    await _firebaseAuth.signOut();
  }

  /// Apple requires apps that offer Sign in with Apple to revoke the
  /// user's Apple tokens when the account is deleted. Revoking needs a
  /// fresh authorization code, so the Apple sheet is shown once more.
  /// Does nothing for accounts that did not sign in with Apple.
  ///
  /// Throws [SignInWithAppleAuthorizationException] if the user cancels the
  /// sheet, which the caller treats as "don't delete".
  Future<void> revokeAppleIfLinked() async {
    final user = _firebaseAuth.currentUser;
    final linked = user?.providerData.any((p) => p.providerId == 'apple.com') ?? false;
    if (!linked || defaultTargetPlatform != TargetPlatform.iOS) return;
    final credential = await SignInWithApple.getAppleIDCredential(scopes: const []);
    await _firebaseAuth.revokeTokenWithAuthorizationCode(credential.authorizationCode);
  }

  /// Local clean-up once the account no longer exists on the server: the
  /// Firebase session ends, and a Google account is
  /// disconnected rather than only signed out, which also withdraws the
  /// app's access to it.
  Future<void> signOutAfterDeletion() async {
    await _subscriptionService.logOut();
    try {
      await _ensureGoogleSignInInitialized();
      await GoogleSignIn.instance.disconnect();
    } catch (_) {
      // Not a Google account, or already disconnected.
    }
    await _firebaseAuth.signOut();
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: SocialAuthConfig.hasAndroidServerClientId
          ? SocialAuthConfig.androidServerClientId
          : null,
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? SocialAuthConfig.iosClientId
          : null,
    );
    _googleSignInInitialized = true;
  }

  /// Returns `null` if the user cancels the Google account picker.
  Future<UserCredential?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  /// iOS/macOS only — see [SocialAuthConfig] docs for why Android isn't
  /// supported. Callers must guard with `Platform.isIOS` before showing the
  /// Apple button.
  Future<UserCredential> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = _sha256(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      nonce: hashedNonce,
    );

    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

    return _firebaseAuth.signInWithCredential(oauthCredential);
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String _sha256(String input) => sha256.convert(utf8.encode(input)).toString();
}

/// Maps [FirebaseAuthException] codes to Romanian, user-facing messages.
String authErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'Adresa de email nu este validă.';
    case 'email-already-in-use':
      return 'Există deja un cont cu acest email.';
    case 'weak-password':
      return 'Parola este prea slabă. Alege una cu cel puțin 6 caractere.';
    case 'user-not-found':
      return 'Nu există niciun cont cu acest email.';
    case 'wrong-password':
    case 'invalid-credential':
      return 'Email sau parolă incorectă.';
    case 'user-disabled':
      return 'Acest cont a fost dezactivat.';
    case 'account-exists-with-different-credential':
      return 'Există deja un cont cu acest email, creat cu altă metodă de autentificare.';
    case 'too-many-requests':
      return 'Prea multe încercări. Te rugăm să încerci mai târziu.';
    case 'network-request-failed':
      return 'Verifică-ți conexiunea la internet și încearcă din nou.';
    default:
      return 'A apărut o eroare. Te rugăm să încerci din nou.';
  }
}
