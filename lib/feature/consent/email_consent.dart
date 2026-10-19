import 'package:flutter/material.dart';
import 'package:futureme/core/data/consent_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/consent/send_email_consent.dart';
import 'package:futureme/shared/widgets/app_text_field.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';
import 'package:futureme/shared/widgets/tag_button.dart';

class EmailConsent extends StatefulWidget{
  const EmailConsent({super.key});

  @override
  State<EmailConsent> createState() => EmailConsentState();
}

class EmailConsentState extends State<EmailConsent>{

    final _parentEmailController = TextEditingController();
    bool _isSending = false;

    void goToNextPage(Widget nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage ));
    }

    Future<void> _sendConsentRequest() async {
      if (_isSending) return;
      final parentEmail = _parentEmailController.text.trim();
      if (!parentEmail.contains('@') || !parentEmail.contains('.')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Introdu o adresă de email validă pentru părinte/tutore.')),
        );
        return;
      }

      setState(() => _isSending = true);
      try {
        final requestId = await getIt<ConsentRepository>().requestConsent(
          parentEmail: parentEmail,
          ageBracket: PendingSignupData.ageBracket ?? '14_15',
        );
        PendingSignupData.parentEmail = parentEmail;
        PendingSignupData.consentRequestId = requestId;
        PendingSignupData.consentRequestedAt = DateTime.now();
        if (!mounted) return;
        goToNextPage(SendEmailConsent());
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nu am putut trimite cererea. Încearcă din nou.')),
        );
      } finally {
        if (mounted) setState(() => _isSending = false);
      }
    }

    @override
    void initState(){
      super.initState();
    }

    @override
    void dispose(){
      _parentEmailController.dispose();
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        SunBadgeIcon(badgeIcon: Icons.mail_outline, badgeColor: AppColors.highlightClarity),
                        const SizedBox(height: 32),
                        PageTitle(content:"Trimitem cererea pentru acord", width: 274),
                        const SizedBox(height: 24),
                        CenterText(content: "Introdu adresa de email a unui părinte sau tutore. Îi vom trimite un link unde poate citi informțiile despre FutureMe și își poate da acordul."),
                        const SizedBox(height: 24),
                        LeftBoldText(content: "Email părinte/tutore"),
                        const SizedBox(height: 8),
                        RoundedCard(
                          contents: [
                            AppTextField(hintText: "exemplu@email.com", controller: _parentEmailController, keyboardType: TextInputType.emailAddress)
                          ]
                        ),
                        const SizedBox(height: 4),
                        LeftLightText(content: "Nu vom trimite materiale promoționale pe această adresă."),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Column(
                    children: [
                      PrimaryButton(
                        content: _isSending ? "Se trimite..." : "Trimite cererea",
                        onpressed: _isSending ? null : _sendConsentRequest,
                      ),
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
