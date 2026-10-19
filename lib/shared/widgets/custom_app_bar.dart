import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';

/// Mirrors the previous `AssetData.customAppBar(context)` static builder.
/// Note: this is rendered as a plain body child (not `Scaffold.appBar`) at
/// every call site, matching existing screen layouts exactly.
class CustomAppBar extends StatelessWidget {
  const CustomAppBar(this.callerContext, {super.key});

  final BuildContext callerContext;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(callerContext);
        },
        child: const Icon(Icons.chevron_left, color: AppColors.dashboard),
      ),
    );
  }
}
