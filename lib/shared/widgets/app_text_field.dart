import 'package:flutter/material.dart';
import 'package:futureme/core/theme/app_colors.dart';

/// Always used inside a [RoundedCard], which already supplies the white
/// filled/bordered/rounded surface — this only needs to render the input
/// itself with no additional decoration.
class AppTextField extends StatefulWidget {
  const AppTextField({super.key, this.hintText, this.isPassword = false, this.controller, this.keyboardType});

  final String? hintText;

  /// When true, the field obscures its text and shows a show/hide toggle
  /// button, matching the plain (e.g. email) field's height and padding.
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscured,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: AppColors.container /* ui-text-muted */),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () => setState(() => _obscured = !_obscured),
                child: Icon(
                  _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.container,
                  size: 20,
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      style: const TextStyle(color: AppColors.dashboard /* ui-text-primary */),
      cursorColor: AppColors.dashboard,
    );
  }
}
