import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';

/// Owns `users/{uid}` — the account profile doc. Onboarding data (age
/// bracket, consent, first name) is captured before the account exists, so
/// it's buffered in [PendingSignupData] and folded in here the moment a new
/// account is created (email/password signup or first social sign-in).
@lazySingleton
class UserRepository {
  UserRepository(this._firestore, this._functions);

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) => _firestore.collection('users').doc(uid);

  Future<void> createOrUpdateProfileOnSignIn(User user, {required bool isNewUser}) async {
    final doc = _userDoc(user.uid);
    final now = FieldValue.serverTimestamp();

    if (!isNewUser) {
      await doc.set({'lastLoginAt': now}, SetOptions(merge: true));
      return;
    }

    final consentRequired = PendingSignupData.consentRequired;

    await doc.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': PendingSignupData.firstName ?? user.displayName,
      'photoUrl': user.photoURL,
      'authProvider': user.providerData.isNotEmpty ? user.providerData.first.providerId : 'password',
      'createdAt': now,
      'updatedAt': now,
      'lastLoginAt': now,
      if (PendingSignupData.ageBracket != null) 'ageBracket': PendingSignupData.ageBracket,
      if (PendingSignupData.ageSignalSource != null)
        'ageSignal': {
          'source': PendingSignupData.ageSignalSource,
          if (PendingSignupData.ageSignalBracket != null) 'bracket': PendingSignupData.ageSignalBracket,
          if (PendingSignupData.ageSignalDeclarationSource != null)
            'declarationSource': PendingSignupData.ageSignalDeclarationSource,
          if (PendingSignupData.ageSignalCheckedAt != null)
            'checkedAt': Timestamp.fromDate(PendingSignupData.ageSignalCheckedAt!),
        },
      'consent': {
        'required': consentRequired,
        // What the parent was asked for: everything at 14-15; at 16-17 the
        // teen consented to the data and the parent to the Terms and purchase.
        if (consentRequired)
          'parentScope': PendingSignupData.ageBracket == '16_17' ? ['terms', 'purchase'] : ['data', 'terms', 'purchase'],
        'status': !consentRequired
            ? 'not_required'
            : (PendingSignupData.consentConfirmedAt != null ? 'confirmed' : 'pending'),
        if (PendingSignupData.parentEmail != null) 'parentEmail': PendingSignupData.parentEmail,
        // Lets account deletion remove exactly this request (deleteAccount).
        if (PendingSignupData.consentRequestId != null) 'requestId': PendingSignupData.consentRequestId,
        if (PendingSignupData.consentRequestedAt != null)
          'requestedAt': Timestamp.fromDate(PendingSignupData.consentRequestedAt!),
        if (PendingSignupData.consentConfirmedAt != null)
          'confirmedAt': Timestamp.fromDate(PendingSignupData.consentConfirmedAt!),
      },
      if (PendingSignupData.selfConsentAgreedAt != null)
        'selfConsentAgreedAt': Timestamp.fromDate(PendingSignupData.selfConsentAgreedAt!),
      'subscription': {'status': 'none'},
    }, SetOptions(merge: true));

    PendingSignupData.reset();
  }

  /// The raw `users/{uid}` profile document, or null if it doesn't exist yet.
  Future<Map<String, dynamic>?> fetchProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    return snap.data();
  }

  /// The `users/{uid}/reports/finalReport` document, written only by the
  /// `generateFinalReport` Cloud Function. `status` is `'generating'`,
  /// `'ready'` (with `summary`, `sections` and `blocks`) or `'failed'`; older
  /// documents may still say `'not_generated'`. Null if never requested.
  Future<Map<String, dynamic>?> fetchFinalReport(String uid) async {
    final snap = await _userDoc(uid).collection('reports').doc('finalReport').get();
    return snap.data();
  }

  /// The Module 5 career plan the user saw, saved by `generateCareerPlan`
  /// at `users/{uid}/reports/careerPlan`, or null.
  Future<Map<String, dynamic>?> fetchCareerPlan(String uid) async {
    final snap = await _userDoc(uid).collection('reports').doc('careerPlan').get();
    return snap.data();
  }

  /// Live view of the same document, so a report still being generated
  /// shows up as soon as the server finishes it.
  ///
  /// With [serverOnly], snapshots served from the local cache are skipped:
  /// the cache can still hold an earlier `failed` state that would otherwise
  /// look like the outcome of the run being waited on.
  Stream<Map<String, dynamic>?> watchFinalReport(String uid, {bool serverOnly = false}) {
    final ref = _userDoc(uid).collection('reports').doc('finalReport');
    if (!serverOnly) return ref.snapshots().map((snap) => snap.data());
    return ref.snapshots(includeMetadataChanges: true).where((snap) => !snap.metadata.isFromCache).map((snap) => snap.data());
  }

  Future<void> updateDisplayName(String uid, String name) {
    return _userDoc(
      uid,
    ).set({'displayName': name, 'updatedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
  }

  /// Records the plan the user picked on the pricing screen, before real
  /// purchases existed. Kept only so pre-RevenueCat accounts that already
  /// have this flag stay grandfathered in by [isSubscriptionActive] — new
  /// purchases should call [recordVerifiedPurchase] instead.
  ///
  /// `subscription` is server-write-only (see `firestore.rules` and
  /// `functions/account.js`'s `confirmSubscription`) — a user can't grant
  /// themselves access by writing to their own document directly, so this
  /// goes through that callable instead of a direct Firestore write. [uid]
  /// is unused (the function always acts on the caller's own account) but
  /// kept in the signature so call sites didn't need to change.
  Future<void> recordSubscriptionSelection(String uid, {required String plan}) => _confirmSubscription(plan: plan, verified: false);

  /// Records a completed Apple/Google in-app purchase confirmed client-side
  /// by RevenueCat. Still not server-verified (no webhook yet — see
  /// docs/BACKEND_API_SPEC.md), but reflects a real store purchase rather
  /// than just a plan tap. See [recordSubscriptionSelection] for why this
  /// calls a Cloud Function rather than writing Firestore directly.
  Future<void> recordVerifiedPurchase(String uid, {required String plan}) => _confirmSubscription(plan: plan, verified: true);

  Future<void> _confirmSubscription({required String plan, required bool verified}) async {
    final callable = _functions.httpsCallable('confirmSubscription');
    await callable.call<Map<String, dynamic>>({'plan': plan, 'verified': verified});
  }

  /// True if `users/{uid}` carries either a verified purchase or the
  /// legacy pre-RevenueCat "active_unverified" flag (grandfathered so
  /// existing accounts aren't locked out by this gate).
  Future<bool> isSubscriptionActive(String uid) async {
    final profile = await fetchProfile(uid);
    final status = (profile?['subscription'] as Map?)?['status'];
    return status == 'active' || status == 'active_unverified';
  }
}
