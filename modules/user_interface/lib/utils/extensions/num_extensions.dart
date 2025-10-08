import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';

extension NumExtension on num {
  Color interspersedColor() =>
      this % 2 == 0 ? AppColors.divider.withOpacity(0.2) : Colors.white;

  String get gradeNumberFormat {
    if (truncateToDouble() == this) {
      return toStringAsFixed(0);
    }

    return toString();
  }

  String percentage({int? decimals}) =>
      '${(this * 100).toStringAsFixed(decimals ?? 0)}%';
}
