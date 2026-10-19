import 'package:flutter/material.dart';
import 'package:futureme/feature/dashboard/module_info.dart';

/// Every "Acasă" / "Revin mai târziu" / "Înapoi Acasă" action across the
/// app used `Navigator.popUntil(context, (route) => route.isFirst)`,
/// which actually pops all the way to the Splash screen (the app's real
/// `home:` route) rather than the Dashboard — a pre-existing bug. This
/// clears the stack and pushes a fresh Dashboard instead, so it also
/// picks up the latest [ModuleProgress] state.
void goToDashboard(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const ModuleInfo()),
    (route) => false,
  );
}
