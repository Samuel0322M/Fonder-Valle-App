import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const PlatformAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    );
  }
}
