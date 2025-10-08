import 'package:flutter/material.dart';

class LeftAlignedLabel extends StatelessWidget {
  final String text;

  const LeftAlignedLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}