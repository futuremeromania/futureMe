import 'package:cloud_functions/cloud_functions.dart';
import 'package:injectable/injectable.dart';

/// Result of a consent-status check — mirrors what the `checkConsentStatus`
/// Cloud Function returns (see `functions/index.js`).
class ConsentStatus {
  const ConsentStatus({required this.status, this.confirmedAt});

  /// 'pending' | 'confirmed' | 'not_found'
  final String status;
  final DateTime? confirmedAt;

  bool get isConfirmed => status == 'confirmed';
}

/// Backs the parent/guardian consent flow (ages 14–17) via Cloud Functions
/// instead of direct Firestore access — the consent request is created and
/// polled *before* a Firebase account exists, so it's addressed by an opaque
/// `requestId` rather than a uid, and only the server ever flips it to
/// 'confirmed' (via the link the parent clicks in their email). See
/// `functions/index.js` for `requestConsent` / `checkConsentStatus` /
/// `confirmConsent`.
@lazySingleton
class ConsentRepository {
  ConsentRepository(this._functions);

  final FirebaseFunctions _functions;

  /// Sends the real consent email to [parentEmail] and returns the
  /// `requestId` to poll via [checkStatus]. [ageBracket] ('14_15' or
  /// '16_17') decides what the parent is asked to confirm.
  Future<String> requestConsent({required String parentEmail, required String ageBracket}) async {
    final callable = _functions.httpsCallable('requestConsent');
    final result = await callable.call<Map<String, dynamic>>({'parentEmail': parentEmail, 'ageBracket': ageBracket});
    return result.data['requestId'] as String;
  }

  /// Polls whether the parent has clicked the confirmation link yet.
  Future<ConsentStatus> checkStatus({required String requestId}) async {
    final callable = _functions.httpsCallable('checkConsentStatus');
    final result = await callable.call<Map<String, dynamic>>({'requestId': requestId});
    final data = result.data;
    final confirmedAtRaw = data['confirmedAt'] as String?;
    return ConsentStatus(
      status: data['status'] as String,
      confirmedAt: confirmedAtRaw != null ? DateTime.parse(confirmedAtRaw) : null,
    );
  }
}
