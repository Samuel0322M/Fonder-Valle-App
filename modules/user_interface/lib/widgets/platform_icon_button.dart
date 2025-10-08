import 'package:flutter/material.dart';

class PlatformIconButton extends StatelessWidget {
  const PlatformIconButton({
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.hoverColor,
    super.key,
  });

  final Function()? onPressed;
  final Widget icon;
  final Color? backgroundColor;
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: icon,
      hoverColor: hoverColor,
    );
  }
}
