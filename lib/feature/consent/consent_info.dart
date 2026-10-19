import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/consent/email_consent.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/icon_divider.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';
import 'package:futureme/shared/widgets/tag_button.dart';


class ConsentInfo extends StatefulWidget{
  const ConsentInfo({super.key});

  @override
  State<ConsentInfo> createState() => ConsentInfoState();
}

class ConsentInfoState extends State<ConsentInfo>{


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
                        const SunBadgeIcon(),
                        const SizedBox(height: 32),
                        PageTitle(content: "Avem nevoie de acordul unui părinte", width: 274),
                        const SizedBox(height: 24),
                        CenterText(
                          content: PendingSignupData.ageBracket == '16_17'
                              ? "Despre datele tale ai decis deja tu. Pentru că încă nu ai 18 ani, Termenii de utilizare și achiziționarea accesului au nevoie de acordul unui părinte sau tutore legal."
                              : "Pentru vârsta ta, este nevoie ca un părinte sau tutore legal să își dea acordul înainte să continui evaluarea.",
                        ),
                        const SizedBox(height: 16),
                        const IconDivider(),
                        const SizedBox(height: 16),
                        CenterText(content: "După acest pas, vei putea merge mai departe în ritmul tău."),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      PrimaryButton(content: "Continuă cu acordul", onpressed: (){
                        goToNextPage(EmailConsent());
                      }),
                      const SizedBox(height: 8),
                      TagButton(content: "Revin mai târziu", onTap: () => Navigator.pop(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
}
