import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/chat/chat_api_service.dart';
import 'package:futureme/core/constants/backend.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/feature/dashboard/module_progress.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Permanently deletes the signed-in user's account and data, in an order
/// where any failure leaves the user signed in and able to retry:
///
/// 1. Apple tokens are revoked, for accounts that use Sign in with Apple
///    (first, because the user can still cancel the Apple sheet);
/// 2. the chat server deletes the conversations it keeps;
/// 3. the `deleteAccount` function deletes the Firestore data and, last,
///    the Firebase account;
/// 4. the local sessions are closed.
///
/// Throws on failure; see [accountDeletionErrorMessage].
Future<void> deleteMyAccount() async {
  final auth = getIt<AuthService>();

  // A failed revoke must not block the deletion itself (for example when
  // the Apple provider's key is not configured in Firebase); only a
  // cancelled Apple sheet does: it is rethrown and nothing is deleted.
  try {
    await auth.revokeAppleIfLinked();
  } on SignInWithAppleAuthorizationException catch (e) {
    if (e.code == AuthorizationErrorCode.canceled) rethrow;
  } catch (_) {
    // Revocation failed for another reason; the deletion goes ahead.
  }

  await getIt<ChatApiService>().deleteMyData();

  await appFunctions.httpsCallable('deleteAccount').call<Map<String, dynamic>>();

  ModuleProgress.completedModules = 0;
  ModuleProgress.hasResume = false;
  await auth.signOutAfterDeletion();
}

/// True when [error] is the user closing the Apple sheet, not a failure.
bool isAccountDeletionCancel(Object error) =>
    error is SignInWithAppleAuthorizationException && error.code == AuthorizationErrorCode.canceled;

String accountDeletionErrorMessage(Object error) {
  if (error is ChatApiException) return error.message;
  return 'Nu am putut șterge contul acum. Verifică conexiunea și încearcă din nou.';
}
