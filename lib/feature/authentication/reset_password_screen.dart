import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futureme/core/auth/auth_service.dart';
import 'package:futureme/core/di/injectable_init.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/shared/widgets/app_text_field.dart';
import 'package:futureme/shared/widgets/center_text.dart';
import 'package:futureme/shared/widgets/custom_app_bar.dart';
import 'package:futureme/shared/widgets/left_bold_text.dart';
import 'package:futureme/shared/widgets/left_light_text.dart';
import 'package:futureme/shared/widgets/page_title.dart';
import 'package:futureme/shared/widgets/primary_button.dart';
import 'package:futureme/shared/widgets/rounded_card.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await getIt<AuthService>().sendPasswordResetEmail(_emailController.text.trim());
      if (!mounted) return;
      setState(() => _emailSent = true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                      PageTitle(content: "Resetează parola"),
                      const SizedBox(height: 16),
                      CenterText(
                        content: "Introdu adresa de email și îți trimitem un link pentru a-ți reseta parola.",
                        width: 293,
                      ),
                      const SizedBox(height: 40),
                      LeftBoldText(content: "Email"),
                      const SizedBox(height: 8),
                      RoundedCard(contents: [
                        AppTextField(
                          hintText: "exemplu@email.com",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ]),
                      if (_emailSent) ...[
                        const SizedBox(height: 8),
                        LeftLightText(content: "Ți-am trimis un email cu instrucțiuni de resetare."),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: PrimaryButton(
                content: _isLoading ? "Se trimite..." : "Trimite link de resetare",
                onpressed: _isLoading ? null : _sendResetEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
