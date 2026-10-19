import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';
import 'package:futureme/shared/widgets/tag_button.dart';

class FailedPayment extends StatefulWidget {
  const FailedPayment({super.key});

  @override
  State<FailedPayment> createState() => FailedPaymentState();
}

class FailedPaymentState extends State<FailedPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SunBadgeIcon(badgeIcon: Icons.error_outline, badgeColor: AppColors.errorFg),
                      const SizedBox(height: 32),
                      PageTitle(content: "Plata nu a fost finalizată", width: 274),
                      const SizedBox(height: 24),
                      CenterText(content: "Se pare că plata nu a fost finalizată. Poți încerca din nou sau poți alege alt plan."),
                      const SizedBox(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: AppColors.statusInfoBg, shape: BoxShape.circle),
                            child: const Icon(Icons.info_outline, size: 12, color: AppColors.statusInfoFg),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Dacă ți-a fost retrasă suma, verifică istoricul plăților din App Store sau Google Play.",
                              style: TextStyle(
                                color: AppColors.statusInfoFg,
                                fontSize: 14,
                                fontFamily: AppFonts.body,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  PrimaryButton(content: "Încearcă din nou", onpressed: (){
                    Navigator.pop(context);
                  }),
                  const SizedBox(height: 8),
                  TagButton(content: "Alege alt plan", onTap: () => Navigator.pop(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
