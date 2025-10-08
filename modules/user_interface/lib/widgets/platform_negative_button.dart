import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/values.dart';
import 'package:user_interface/utils/extensions/context_extensions.dart';

class PlatformNegativeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final bool underline;
  final EdgeInsetsGeometry? padding;

  const PlatformNegativeButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.underline = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.buttonDisabled;
            }

            return AppColors.buttonTextPositive;
          },
        ),
        overlayColor: WidgetStateColor.resolveWith(
          (states) => AppColors.buttonPositive.withOpacity(0.3),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Values.circularRadius),
            side: const BorderSide(color: AppColors.buttonPositive),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: context.textTheme.bodyLarge
            ?.copyWith(color: AppColors.buttonPositive),
      ),
    );
  }
}
