import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/sign_in_screen.dart';
import 'package:futureme/feature/onboarding/video_welcome_screen.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/tag_button.dart';

class OnboardingScreen extends StatelessWidget{
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        scrollDirection:Axis.vertical,
        padding: EdgeInsets.all(0),
        child:  Container(
          padding: EdgeInsets.all(0),
        child:Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 335,
              child: Image.asset(AppAssets.onboardingImage, fit: BoxFit.cover),
            ),
            SvgPicture.asset(
              AppAssets.splashImage
            ),
            SizedBox(
              height:20
            ),
            PageTitle(
              content:"Aici ești \nîn siguranță",
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
             SizedBox(
              height:16
            ),
              CenterText(content: "FutureMe te ghidează pas cu pas să te înțelegi mai bine și să îți clarifici direcția, fără presiune și fără răspunsuri perfecte.", width: 305,),
              SizedBox(
              height:20
            ),
             PrimaryButton(content: "Încep în ritmul meu",
             gradient: AppColors.specialGradient,
             onpressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => VideoWelcome()));
             }
             ),

              SizedBox(height:8,),
              TagButton(
                content: "Am deja cont",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                },
              ),
              SizedBox(height:20)

          ],
      )

      )
       )

      ) ; }
}
