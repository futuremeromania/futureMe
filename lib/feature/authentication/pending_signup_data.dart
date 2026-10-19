/// Buffers onboarding data captured *before* a Firebase account exists
/// (age-gate, consent, self-consent) plus the post-signup name-entry step,
/// so it can be written into the user's Firestore profile in one shot right
/// after the account is created. Same "static in-memory holder" pattern as
/// [ModuleProgress] — there's nowhere to persist this until an `uid` exists.
class PendingSignupData {
  PendingSignupData._();

  static String? ageBracket; // 'under14' | '14_15' | '16_17' | '18_plus'
  static bool consentRequired = false;

  // Apple's Declared Age Range signal (iOS 26+, see AgeRangeSignalService),
  // recorded alongside ageBracket purely as a corroborating audit trail —
  // ageBracket above is already the resolved value once this was
  // considered. null when unavailable/declined (Android, iOS <26, etc.).
  static String? ageSignalSource; // 'declaredAgeRange' | null
  static String? ageSignalBracket; // same coding as ageBracket
  static String? ageSignalDeclarationSource; // AgeRangeDeclarationSource.name
  static DateTime? ageSignalCheckedAt;

  static String? parentEmail;
  static String? consentRequestId; // Cloud Functions `consentRequests` doc id, see ConsentRepository
  static DateTime? consentRequestedAt;
  static DateTime? consentConfirmedAt;
  static DateTime? selfConsentAgreedAt;
  static String? firstName;

  static void reset() {
    ageBracket = null;
    consentRequired = false;
    ageSignalSource = null;
    ageSignalBracket = null;
    ageSignalDeclarationSource = null;
    ageSignalCheckedAt = null;
    parentEmail = null;
    consentRequestId = null;
    consentRequestedAt = null;
    consentConfirmedAt = null;
    selfConsentAgreedAt = null;
    firstName = null;
  }
}
