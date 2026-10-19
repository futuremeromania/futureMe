import 'package:flutter/material.dart';
import 'package:futureme/core/age/age_range_signal_service.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/age_gate/age_sixteen_twenty_screen.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/consent/consent_info.dart';
import 'package:futureme/feature/age_gate/under_fourteen_restricted_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

// Bracket string codes, ordered most-to-least restrictive — matches
// PendingSignupData.ageBracket's coding exactly.
const _bracketOrder = ['under14', '14_15', '16_17', '18_plus'];

String _codeFor(AgeBracket bracket) {
  switch (bracket) {
    case AgeBracket.youngest:
      return 'under14';
    case AgeBracket.younger:
      return '14_15';
    case AgeBracket.young:
      return '16_17';
    case AgeBracket.older:
      return '18_plus';
  }
}

/// Corroborating-signal policy: when Apple's OS-level Declared Age Range
/// check (see [AgeRangeSignalService]) disagrees with what the user
/// self-reported, the more restrictive (younger) of the two wins. The
/// self-report UI above is unchanged either way — this only affects which
/// bracket actually gets recorded and which screen comes next.
String _resolveBracketCode(String selfReportedCode, AgeRangeSignalResult? signal) {
  if (signal == null) return selfReportedCode;
  final selfIndex = _bracketOrder.indexOf(selfReportedCode);
  final signalIndex = _bracketOrder.indexOf(signal.ageBracketCode);
  if (selfIndex == -1 || signalIndex == -1) return selfReportedCode;
  return signalIndex < selfIndex ? signal.ageBracketCode : selfReportedCode;
}

enum AgeBracket {
  youngest, 
  younger,
  young,
  older
}


class AgeSet extends StatefulWidget{
  const AgeSet({super.key});

  @override
  State<AgeSet> createState() => AgeSetState();
}

class AgeSetState extends State<AgeSet>{

    AgeBracket selectedAge = AgeBracket.younger;

    // Kicked off as soon as the screen loads so it's (usually) already
    // resolved by the time the user taps "Continuă". Never throws — see
    // AgeRangeSignalService.
    late final Future<AgeRangeSignalResult?> _ageSignal;

    void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
    }

    @override
    void initState(){
      super.initState();
      _ageSignal = getIt<AgeRangeSignalService>().checkDeclaredAgeRange();
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
          backgroundColor : AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                CustomAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        PageTitle(content: "Pentru o experiență potrivită"),
                        const SizedBox(height: 16),
                        CenterText(content: "FutureMe este creat pentru tineri începând cu vârsta de 14 ani. Alege intervalul tău de vârstă, ca să adaptăm pașii următori."),
                        const SizedBox(height: 40),
                        _AgeOption(
                          label: "Sub 14 ani",
                          selected: selectedAge == AgeBracket.youngest,
                          onTap: () => setState(() => selectedAge = AgeBracket.youngest),
                        ),
                        const SizedBox(height: 16),
                        _AgeOption(
                          label: "14-15 ani",
                          selected: selectedAge == AgeBracket.younger,
                          onTap: () => setState(() => selectedAge = AgeBracket.younger),
                        ),
                        const SizedBox(height: 16),
                        _AgeOption(
                          label: "16-17 ani",
                          selected: selectedAge == AgeBracket.young,
                          onTap: () => setState(() => selectedAge = AgeBracket.young),
                        ),
                        const SizedBox(height: 16),
                        _AgeOption(
                          label: "18 ani sau peste",
                          selected: selectedAge == AgeBracket.older,
                          onTap: () => setState(() => selectedAge = AgeBracket.older),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: PrimaryButton(content: "Continuă", onpressed: () async {
                   final selfReportedCode = _codeFor(selectedAge);

                   AgeRangeSignalResult? signal;
                   try {
                     // A corroborating signal should never make onboarding
                     // hang — give it a few seconds, then move on without it.
                     signal = await _ageSignal.timeout(const Duration(seconds: 3));
                   } catch (_) {
                     signal = null;
                   }
                   if (!mounted) return;

                   final resolvedCode = _resolveBracketCode(selfReportedCode, signal);

                   PendingSignupData.ageBracket = resolvedCode;
                   // Both minor brackets need a parent: at 14-15 for the data as well,
                   // at 16-17 only for the Terms and the purchase (see ConsentInfo).
                   PendingSignupData.consentRequired = resolvedCode == '14_15' || resolvedCode == '16_17';
                   PendingSignupData.ageSignalSource = signal != null ? 'declaredAgeRange' : null;
                   PendingSignupData.ageSignalBracket = signal?.ageBracketCode;
                   PendingSignupData.ageSignalDeclarationSource = signal?.declarationSource.name;
                   PendingSignupData.ageSignalCheckedAt = signal != null ? DateTime.now() : null;

                   switch (resolvedCode) {
                     case 'under14':
                       goToNextPage(const UnderFourteenRestrictedScreen());
                     case '14_15':
                       goToNextPage(ConsentInfo());
                     case '16_17':
                     case '18_plus':
                     default:
                       goToNextPage(const AgeSixteenTwentyScreen());
                   }
                  }),
                ),
              ],
            ),
          ),
        );
    }
}

class _AgeOption extends StatelessWidget {
  const _AgeOption({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.faint /* ui-surface-tint */ : Colors.white /* ui-surface-card */,
          border: Border.all(color: selected ? AppColors.grad1 : AppColors.border),
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))]
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.dashboard /* ui-text-primary */,
                  fontSize: 16,
                  fontFamily: AppFonts.body,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  height: 1.375,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.grad1 : null,
                shape: BoxShape.circle,
                border: selected ? null : Border.all(color: AppColors.border, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
