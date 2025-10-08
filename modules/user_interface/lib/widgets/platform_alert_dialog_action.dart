import 'package:flutter/material.dart';

class PlatformAlertDialogAction extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;

  const PlatformAlertDialogAction(
      {super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(title));
  }
}
