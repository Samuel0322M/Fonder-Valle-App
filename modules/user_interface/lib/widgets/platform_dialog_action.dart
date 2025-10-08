import 'package:flutter/material.dart';
import 'package:user_interface/widgets/platform_negative_button.dart';
import 'package:user_interface/widgets/platform_positive_button.dart';

enum TypeButtonDialog {
  positive,
  negative,
  destructive;
}

class PlatformDialogAction extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TypeButtonDialog? type;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  const PlatformDialogAction({
    super.key,
    required this.text,
    required this.onPressed,
    this.type,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });

  @override
  Widget build(BuildContext context) {
    if (type == TypeButtonDialog.positive) {
      return PlatformPositiveButton(
        title: text,
        onPressed: onPressed!,
      );
    }

    if (type == TypeButtonDialog.negative) {
      return PlatformNegativeButton(
        title: text,
        onPressed: onPressed!,
      );
    }

    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
