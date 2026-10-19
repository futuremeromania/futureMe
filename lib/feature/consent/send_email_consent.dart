import 'package:flutter/material.dart';
import 'package:futureme/core/data/consent_repository.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/authentication/pending_signup_data.dart';
import 'package:futureme/feature/consent/confirm_consent_info.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/sun_badge_icon.dart';
import 'package:futureme/shared/widgets/tag_button.dart';


class SendEmailConsent extends StatefulWidget{
  const SendEmailConsent({super.key});

  @override
  State<SendEmailConsent> createState() => SendEmailConsentState();
}

class SendEmailConsentState extends State<SendEmailConsent>{

    bool _isChecking = false;

    void goToNextPage(Widget nextPage){
      Navigator.push(context,MaterialPageRoute(builder: (context) => nextPage ));
    }

    Future<void> _verifyConsent() async {
      if (_isChecking) return;
      final requestId = PendingSignupData.consentRequestId;
      if (requestId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cererea de acord a expirat. Revin la pasul anterior.')),
        );
        Navigator.pop(context);
        return;
      }

      setState(() => _isChecking = true);
      try {
        final result = await getIt<ConsentRepository>().checkStatus(requestId: requestId);
        if (!mounted) return;
        if (result.isConfirmed) {
          PendingSignupData.consentConfirmedAt = result.confirmedAt ?? DateTime.now();
          goToNextPage(ConfirmConsent());
        } else if (result.status == 'not_found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cererea de acord nu a fost găsită. Trimite-o din nou.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Încă așteptăm confirmarea părintelui sau tutorelui.')),
          );
        }
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nu am putut verifica acordul. Încearcă din nou.')),
        );
      } finally {
        if (mounted) setState(() => _isChecking = false);
      }
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
                        const SizedBox(height: 24),
                        SunBadgeIcon(badgeIcon: Icons.access_time_rounded, badgeColor: AppColors.statusInfoFg),
                        const SizedBox(height: 32),
                        PageTitle(content: "Așteptăm acordul", width: 274),
                        const SizedBox(height: 24),
                        CenterText(content: "Am trimis linkul către părintele sau tutorele tău. După confirmare, vei putea continua în FutureMe.", width: 315,),
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
                        content: _isChecking ? "Se verifică..." : "Verifică acordul",
                        onpressed: _isChecking ? null : _verifyConsent,
                      ),
                      const SizedBox(height: 8),
                      TagButton(
                        content: "Schimbă adresa de email",
                        onTap: () => Navigator.pop(context)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
    }
}
