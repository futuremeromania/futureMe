import 'package:flutter/material.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/onboarding/onboarding_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/icon_divider.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// "Under 14 - Restricted" (Figma frame 36:129) — shown when the age
/// selection screen's "Sub 14 ani" bracket is chosen. FutureMe doesn't
/// support under-14 users yet, so this is a dead end back to the start.
class UnderFourteenRestrictedScreen extends StatelessWidget {
  const UnderFourteenRestrictedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 60),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(AppAssets.sunnyDay, width: 100, height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(height: 32),
              const PageTitle(content: "FutureMe nu este disponibil încă pentru vârsta ta"),
              const SizedBox(height: 24),
              const CenterText(content: "Momentan, FutureMe este creat pentru persoanele de cel puțin 14 ani."),
              const SizedBox(height: 16),
              const IconDivider(),
              const SizedBox(height: 16),
              const CenterText(content: "Îți mulțumim că ai vrut să începi. Te așteptăm cu drag când va fi momentul potrivit."),
              const Spacer(),
              PrimaryButton(
                content: "Am înțeles",
                onpressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()), (route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
