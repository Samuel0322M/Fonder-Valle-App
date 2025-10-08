import 'package:flutter/material.dart';

class ToastContent {
  final String? message;
  final Color? backgroundColor;
  final IconData? icon;
  final ToastType type;

  ToastContent({
    this.message,
    this.type = ToastType.custom,
    this.backgroundColor,
    this.icon,
  });
}

enum ToastType { warning, success, error, custom }