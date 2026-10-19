import 'package:flutter/material.dart';
import 'package:futureme/core/auth/account_deletion.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/core/theme/app_fonts.dart';
import 'package:futureme/feature/splash/splash_screen.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/primary_button.dart';

/// In-app account deletion, required by the App Store and Google Play for
/// apps where an account can be created. Explains what is deleted, asks
/// for a second confirmation, then runs [deleteMyAccount].
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _deleting = false;

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ștergi definitiv contul?"),
        content: const Text("Toate datele tale vor fi șterse și nu mai pot fi recuperate."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Renunț")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Șterge", style: TextStyle(color: AppColors.errorFg, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await deleteMyAccount();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _deleting = false);
      if (isAccountDeletionCancel(error)) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accountDeletionErrorMessage(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    const body = TextStyle(color: AppColors.uiHeadingSmall, fontSize: 16, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5);

    return PopScope(
      canPop: !_deleting,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ștergerea contului",
                        style: TextStyle(color: AppColors.uiHeading, fontSize: 28, fontFamily: AppFonts.heading, fontWeight: FontWeight.w600, height: 1.21),
                      ),
                      const SizedBox(height: 16),
                      const Text("Dacă îți ștergi contul, se șterg definitiv:", style: body),
                      const SizedBox(height: 8),
                      for (final item in const [
                        "contul tău FutureMe și datele de autentificare",
                        "răspunsurile tale din toate modulele",
                        "rezultatele, feedback-ul și raportul final",
                        "conversațiile din chat",
                        "cererea de acord trimisă părintelui, dacă a existat",
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("•  ", style: body),
                              Expanded(child: Text(item, style: body)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.faint,
                          border: Border.all(color: AppColors.borderStrong),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Ștergerea nu poate fi anulată. Dacă ai plătit accesul la FutureMe, îl pierzi odată cu contul. Pentru o nouă evaluare va trebui să îți creezi un cont nou.",
                          style: TextStyle(color: AppColors.uiHeadingSmall, fontSize: 14, fontFamily: AppFonts.body, fontWeight: FontWeight.w400, height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: _deleting
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text("Se șterge contul...", style: body),
                          ],
                        ),
                      )
                    : PrimaryButton(
                        content: "Șterge definitiv contul",
                        color: AppColors.errorFg,
                        onpressed: _confirmAndDelete,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
