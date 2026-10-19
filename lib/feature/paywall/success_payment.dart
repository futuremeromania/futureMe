import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/dashboard/module_info.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';

class SuccessPayment extends StatefulWidget{
    const SuccessPayment({super.key});

    @override
    State<SuccessPayment> createState() => SuccessPaymentState();
}

class SuccessPaymentState extends State<SuccessPayment>{
   void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
  }

@override
Widget build(BuildContext context){
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
                    SunBadgeIcon(badgeIcon: Icons.check_circle, badgeColor: AppColors.successFg),
                    const SizedBox(height: 32),
                    PageTitle(content: "Abonamentul tău este activ", width: 274),
                    const SizedBox(height: 24),
                    CenterText(content: "Totul este pregătit. Poți începe experiența FutureMe și parcurge pașii în ritmul tău."),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: PrimaryButton(content: "Începe experiența", gradient: AppColors.specialGradient, onpressed: (){
              goToNextPage(ModuleInfo());
            }),
          ),
        ],
      ),
    ),
  );
  }

}
