import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

class PlatformTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autocorrect;
  final bool enableSuggestions;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget? prefixIcon;
  final int? maxLines;
  final bool onlyNumbers;
  final String? errorText;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onSubmitted;

  const PlatformTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.width,
    this.height = 50,
    this.controller,
    this.onChanged,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.focusNode,
    this.autofocus = false,
    this.prefixIcon,
    this.maxLines,
    this.onlyNumbers = false,
    this.errorText,
    this.textInputAction,
    this.inputFormatters,
    this.onSubmitted, required bool readOnly, GestureTapCallback? onTap, TextInputType? keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.all(Radius.circular(10));
    return TextField(
      textInputAction: textInputAction,
      keyboardType: onlyNumbers ? TextInputType.number : TextInputType.text,
      inputFormatters: onlyNumbers
          ? [FilteringTextInputFormatter.digitsOnly]
          : inputFormatters ?? [],
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      controller: controller,
      obscureText: obscureText,
      autofocus: autofocus,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(color: AppColors.textSubtitle),
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.textBodyDark),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.buttonPositive),
          borderRadius: borderRadius,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldPositive),
          borderRadius: borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.textFieldFocus),
          borderRadius: borderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: borderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: borderRadius,
        ),
      ),
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: AppColors.textBodyDark),
    );
  }
}
