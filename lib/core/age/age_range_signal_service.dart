import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// How the OS learned this age range — mirrors Apple's `AgeRangeDeclaration`
/// enum (see `ios/Runner/AgeRangeSignalChannel.swift`).
enum AgeRangeDeclarationSource {
  selfDeclared,
  guardianDeclared,
  checkedByOtherMethod,
  guardianCheckedByOtherMethod,
  governmentIdChecked,
  guardianGovernmentIdChecked,
  paymentChecked,
  guardianPaymentChecked,
  unknown;

  static AgeRangeDeclarationSource fromNative(String? raw) {
    switch (raw) {
      case 'selfDeclared':
        return selfDeclared;
      case 'guardianDeclared':
        return guardianDeclared;
      case 'checkedByOtherMethod':
        return checkedByOtherMethod;
      case 'guardianCheckedByOtherMethod':
        return guardianCheckedByOtherMethod;
      case 'governmentIDChecked':
        return governmentIdChecked;
      case 'guardianGovernmentIDChecked':
        return guardianGovernmentIdChecked;
      case 'paymentChecked':
        return paymentChecked;
      case 'guardianPaymentChecked':
        return guardianPaymentChecked;
      default:
        return unknown;
    }
  }
}

/// Result of a successful Declared Age Range check. [ageBracketCode]
/// matches the string codes [PendingSignupData.ageBracket] already uses:
/// 'under14' | '14_15' | '16_17' | '18_plus'.
class AgeRangeSignalResult {
  const AgeRangeSignalResult({required this.ageBracketCode, required this.declarationSource});

  final String ageBracketCode;
  final AgeRangeDeclarationSource declarationSource;
}

/// Bridges Apple's `DeclaredAgeRange` framework (iOS 26+) via a hand-rolled
/// method channel — see `ios/Runner/AgeRangeSignalChannel.swift` for the
/// native side and why this isn't a pub.dev plugin.
///
/// This is a **corroborating signal**, not a hard gate: the app's own
/// self-reported age bracket (`AgeSet`) keeps working exactly as before on
/// Android, on iOS < 26, and whenever the user declines to share or the
/// framework isn't available — every one of those paths just resolves to
/// `null` here.
@lazySingleton
class AgeRangeSignalService {
  static const _channel = MethodChannel('futureme/age_range_signal');

  /// The three thresholds that split the app's four brackets — under 14,
  /// 14-15, 16-17, 18+ — matching [PendingSignupData.ageBracket]'s coding.
  static const _gates = [14, 16, 18];

  Future<AgeRangeSignalResult?> checkDeclaredAgeRange() async {
    if (!Platform.isIOS) return null;
    try {
      final raw = await _channel.invokeMapMethod<String, Object?>('requestAgeRange', {'gates': _gates});
      if (raw == null || raw['shared'] != true) return null;

      final upperBound = raw['upperBound'] as int?;
      final declaration = AgeRangeDeclarationSource.fromNative(raw['declaration'] as String?);

      return AgeRangeSignalResult(ageBracketCode: _bracketFor(upperBound), declarationSource: declaration);
    } catch (_) {
      // Never let a platform/channel failure block onboarding.
      return null;
    }
  }

  String _bracketFor(int? upperBound) {
    // upperBound is null when the person is at/above the highest gate (18).
    if (upperBound == null) return '18_plus';
    if (upperBound <= 13) return 'under14';
    if (upperBound <= 15) return '14_15';
    return '16_17';
  }
}
