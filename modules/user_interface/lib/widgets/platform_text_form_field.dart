import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/utils/constants/typedefs.dart';

class PlatformTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final ValidatorFunction validator;
  final TextInputType? keyboardType;
  final Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const PlatformTextFormField(
      {super.key,
      required this.hintText,
      this.validator,
      this.keyboardType,
      this.obscureText = false,
      this.width,
      this.height,
      this.controller,
      this.onSaved,
      this.onChanged,
      this.maxLength,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: height,
        width: width,
        child: TextFormField(
          maxLength: maxLength,
          onChanged: onChanged,
          onSaved: onSaved,
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: const TextStyle(color: AppColors.textBodyDark),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonPositive),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonPositive),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.buttonPositive),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
