import 'package:flutter/material.dart';
import 'package:models/app_toast_content.dart';
import 'package:user_interface/l10n/app_localizations.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/values.dart';

extension ContextExtension on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;
  AppLocalizations get appLocalizations => AppLocalizations.of(this)!;
  TextTheme get textTheme => Theme.of(this).textTheme;

  void showSnackBar(ToastContent message) {
    if (ScaffoldMessenger.of(this).mounted) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          showCloseIcon: true,
          backgroundColor: _getColor(message),
          content: Row(
            children: [
              _getIcon(message),
              const SizedBox(width: Values.paddingShort),
              Text(
                message.message ?? "",
                style: textTheme.bodyMedium!.copyWith(
                  color: _getTextColor(message),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
  }

  Color _getTextColor(ToastContent content) {
    Color color;

    switch (content.type) {
      case ToastType.success:
      case ToastType.error:
        color = Colors.white;
      case ToastType.warning:
      default:
        color = AppColors.textBodyDark;
    }

    return color;
  }

  Color _getColor(ToastContent content) {
    Color color;

    switch (content.type) {
      case ToastType.warning:
        color = AppColors.warningToast;
      case ToastType.success:
        color = AppColors.segmentedControlUnselected;
      case ToastType.error:
        color = AppColors.errorToast;
      default:
        color = content.backgroundColor ?? Colors.white;
    }

    return color;
  }

  Icon _getIcon(ToastContent content) {
    Icon icon;

    switch (content.type) {
      case ToastType.warning:
        icon = const Icon(
          Icons.warning,
          color: AppColors.iconDark,
        );

        break;
      case ToastType.success:
        icon = const Icon(
          Icons.check,
          color: Colors.white,
        );

        break;
      case ToastType.error:
        icon = const Icon(
          Icons.error,
          color: Colors.white,
        );

      case ToastType.custom:
        icon = Icon(content.icon ?? Icons.info, color: AppColors.iconDark);
        break;
    }

    return icon;
  }
}

extension MediaQueryExtension on BuildContext {
  double get height => mediaQuerySize.height;
  double get width => mediaQuerySize.width;

  double dynamicWidth(double val) => width * val;
  double dynamicHeight(double val) => height * val;
}
