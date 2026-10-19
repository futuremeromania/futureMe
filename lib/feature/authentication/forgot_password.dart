import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/data/user_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/onboarding/function_video.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';
import 'package:futureme/shared/widgets/app_text_field.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';



class ForgotPassword extends StatefulWidget{
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword>{

    final _firstNameController = TextEditingController();

    void goToNextPage(Widget? nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage! ));
    }

    Future<void> _saveNameAndContinue() async {
      final name = _firstNameController.text.trim();
      final uid = getIt<AuthService>().currentUser?.uid;
      if (name.isNotEmpty && uid != null) {
        await getIt<UserRepository>().updateDisplayName(uid, name);
      }
      if (!mounted) return;
      goToNextPage(FunctionVideo());
    }

    @override
    void initState(){
      super.initState();
    }

    @override
    void dispose(){
      _firstNameController.dispose();
      super.dispose();
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
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PageTitle(content:"Hai să ne cunoaștem"),
                          const SizedBox(height:16),
                          CenterText(content: "Spune-ne prenumele tău, ca fiecare pas să se simtă puțin mai aproape de tine.", width: 293,),
                          const SizedBox(height:40),
                          LeftBoldText(content: "Prenume"),
                          const SizedBox(height:8),
                          RoundedCard(contents: [
                            AppTextField(hintText: "Ex. Andreea", controller: _firstNameController),
                          ]),
                          const SizedBox(height:8),
                          LeftLightText(content:"Îl poți schimba oricând din contul tău."),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: PrimaryButton(content: "Continuă", onpressed: _saveNameAndContinue),
                ),
              ],
            ),
          )
        );
    }
}
