import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

class PlatformPositiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool underline;
  final EdgeInsetsGeometry? padding;

  const PlatformPositiveButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.underline = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.textBodyLight,
          backgroundColor: AppColors.buttonPositive,
          disabledBackgroundColor: AppColors.buttonDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          padding: padding,
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
