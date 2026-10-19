import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:futureme/core/constants/assets.dart';
import 'package:futureme/core/theme/app_colors.dart';
import 'package:futureme/feature/dashboard/module_info.dart';
import 'package:futureme/feature/onboarding/onboarding_screen.dart';

/// Shows the logo with a brief fade/scale-in, then moves on automatically —
/// no tap required. Where it goes depends on [isSignedIn]: a returning user
/// lands on the dashboard rather than being walked through onboarding,
/// the age gate and the paywall again.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.isSignedIn = false});

  final bool isSignedIn;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Total time the splash stays on screen before auto-navigating.
  static const _holdDuration = Duration(milliseconds: 2200);
  static const _animationDuration = Duration(milliseconds: 700);

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animationDuration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _scheduleTransition();
  }

  Future<void> _scheduleTransition() async {
    await Future.delayed(_holdDuration);
    if (!mounted) return;
    // Onboarding keeps the original plain push, so back-button behavior
    // from there onward is unchanged. The dashboard replaces the splash
    // instead — there's nothing useful to go back to.
    if (widget.isSignedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ModuleInfo()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: SvgPicture.asset(AppAssets.splashImage),
            ),
          ),
        ),
      ),
    );
  }
}