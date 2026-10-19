import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/login.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/icon_divider.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';


class ConfirmConsent extends StatefulWidget{
  const ConfirmConsent({super.key});

  @override
  State<ConfirmConsent> createState() => ConfirmConsentState();
}

class ConfirmConsentState extends State<ConfirmConsent>{


    void goToNextPage(Widget nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage ));
    }

    @override
    void initState(){
      super.initState();
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
                        const SizedBox(height: 16),
                        SunBadgeIcon(badgeIcon: Icons.check_circle, badgeColor: AppColors.successFg),
                        const SizedBox(height: 32),
                        PageTitle(content: "Acordul a fost confirmat", width: 274),
                        const SizedBox(height: 24),
                        CenterText(content: "Mulțumim! Acum poți continua experiența FutureMe.", width: 226,),
                        const SizedBox(height: 16),
                        const IconDivider(),
                        const SizedBox(height: 16),
                        CenterText(content: "Răspunsurile tale sunt în siguranță. Le folosim pentru a personaliza pașii, interpretările și raportul tău final. Poți merge mai departe în ritmul tău."),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: PrimaryButton(content: "Continuă", onpressed: (){
                    // consentConfirmedAt is already set (from the server) by
                    // SendEmailConsent once the parent's confirmation was verified.
                    goToNextPage(LoginPage());
                  }),
                ),
              ],
            ),
          ),
        );
    }
}
