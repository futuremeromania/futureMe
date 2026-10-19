import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/paywall/pricing_package.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/check_icon_row.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/video_lesson_card.dart';

class FunctionVideo extends StatefulWidget{
    const FunctionVideo({super.key});

    @override
    State<FunctionVideo> createState() => FunctionVideoState();
}

class FunctionVideoState extends State<FunctionVideo>{
  void goToNextPage(Widget? nextPage){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage!));
  }

@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
    padding: EdgeInsets.all(0),
    scrollDirection:Axis.vertical,
    child: Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
            color: AppColors.background
        ),
      child:  Column(
        children: [

              CustomAppBar(context),
               SizedBox(height:30),
          Container(
            padding:EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            child: Column(children: [
                          PageTitle(content: "Cum funcționează FutureMe"),
             SizedBox(height: 16),
          CenterText(content: "Înainte să mergem mai departe, ți-am pregătit un mesaj care să îți arate ce urmează și să te ajute să pornești cu mai multă încredere."),
            SizedBox(height: 20),
          VideoLessonCard(
            title: "Cum va decurge experiența",
            duration: "2 min",
            assetPath: "assets/videos/explanation.mp4",
          ),
            SizedBox(height: 20,),

            CheckIconRow(text: "Fără presiune sau răspunsuri perfecte", color: AppColors.grad1),

             SizedBox(height: 10,),

            CheckIconRow(text: "Te descoperi în ritmul tău", color: AppColors.grad1),

             SizedBox(height: 10,),

            CheckIconRow(text: "Primești claritate la final", color: AppColors.grad1),

            SizedBox(height: 100),
           PrimaryButton(content:"Continuă",onpressed: (){
              goToNextPage(PricingPackage());
            }),
         ] )
          )
    ],)
    )
  )

  );
  }

}