import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/authentication/login.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/consent/consent_info.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// "Age 16-20" (Figma frame 36:219) — the self-consent screen shown when
/// the age selection screen's "16-17 ani" or "+18 ani" bracket is chosen.
/// From 16 the user consents to the data processing themselves (art. 8
/// GDPR). An adult then goes on to account creation; a 16-17 year old is
/// still a minor, so the Terms and the purchase go to a parent next.
class AgeSixteenTwentyScreen extends StatefulWidget {
  const AgeSixteenTwentyScreen({super.key});

  @override
  State<AgeSixteenTwentyScreen> createState() => _AgeSixteenTwentyScreenState();
}

class _AgeSixteenTwentyScreenState extends State<AgeSixteenTwentyScreen> {
  bool _agreed = false;

  static const List<String> _points = [
    "Răspunsurile tale personalizează experiența.",
    "Datele tale sunt tratate cu grijă și confidențialitate.",
    "Poți face pauză oricând și reveni când ești pregătit.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset(AppAssets.sunnyDay, width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 16),
                    const PageTitle(content: "Confidențialitatea ta contează"),
                    const SizedBox(height: 16),
                    const Text(
                      "Înainte să continuăm, vrem să știi cum folosim datele tale și ce înseamnă acordul tău.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 16,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        letterSpacing: -0.16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [BoxShadow(color: Color(0x59CFB2A4), blurRadius: 4, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _points.length; i++) ...[
                            if (i > 0) ...[
                              const SizedBox(height: 16),
                              Divider(color: AppColors.border, height: 1, thickness: 1),
                              const SizedBox(height: 16),
                            ],
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(color: AppColors.faint, shape: BoxShape.circle),
                                  child: const Icon(Icons.check, size: 18, color: AppColors.uiHeading),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    _points[i],
                                    style: const TextStyle(
                                      color: AppColors.dashboard,
                                      fontSize: 16,
                                      fontFamily: AppFonts.body,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      letterSpacing: -0.16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "FutureMe nu înlocuiește psihoterapia, diagnosticul medical sau consilierea de criză.",
                      style: TextStyle(
                        color: AppColors.uiHeadingSmall,
                        fontSize: 14,
                        fontFamily: AppFonts.body,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () => setState(() => _agreed = !_agreed),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(top: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _agreed ? AppColors.grad1 : Colors.transparent,
                              border: Border.all(color: AppColors.grad1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _agreed ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: AppColors.dashboard,
                                  fontSize: 16,
                                  fontFamily: AppFonts.body,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  letterSpacing: -0.16,
                                ),
                                children: [
                                  TextSpan(text: "Am citit "),
                                  TextSpan(
                                    text: "detaliile despre confidențialitate",
                                    style: TextStyle(color: AppColors.grad1, decoration: TextDecoration.underline),
                                  ),
                                  TextSpan(text: " și sunt de acord să continui."),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                content: "Continuă",
                color: _agreed ? null : AppColors.borderStrong,
                onpressed: _agreed
                    ? () {
                        PendingSignupData.selfConsentAgreedAt = DateTime.now();
                        final next = PendingSignupData.ageBracket == '16_17' ? const ConsentInfo() : LoginPage();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => next));
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
