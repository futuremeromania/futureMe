import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/constants/backend.dart';
import 'package:futureme/core/di/injectable_init.dart';

/// Saves the end-of-journey feedback: one score and two open answers.
///
/// Written under the user's own document because that is the only place
/// firestore.rules lets a signed-in client write. A collection group query
/// on `feedback` still reads every response at once, so keeping it there
/// costs nothing when the answers are read back.
///
/// Fire-and-forget, like `saveModuleAnswer`: the screen moves on straight
/// away, and a failed write must never strand someone on the last page of
/// the app.
void saveAppFeedback({int? score, String? reason, String? oneChange}) {
  final uid = getIt<AuthService>().currentUser?.uid;
  if (uid == null) return;

  String? clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  final cleanReason = clean(reason);
  final cleanChange = clean(oneChange);

  appFirestore.collection('users').doc(uid).collection('feedback').doc('app').set({
    'version': 'app-feedback-v1',
    // Null rather than an empty string, so "moved on without answering"
    // and "answered with nothing" stay distinguishable.
    'score': score,
    'reason': cleanReason,
    'oneChange': cleanChange,
    'skipped': score == null && cleanReason == null && cleanChange == null,
    'submittedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
