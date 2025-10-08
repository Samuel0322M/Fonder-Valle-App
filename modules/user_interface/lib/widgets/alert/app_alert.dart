import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/values.dart';
import 'package:user_interface/utils/extensions/context_extensions.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';
import 'package:user_interface/widgets/platform_alert_dialog.dart';
import 'package:user_interface/widgets/platform_dialog_action.dart';

class AppAlert {
  AppAlert._();

  static Future<T?> _setupPlatformDialog<T>(
      BuildContext context, WidgetBuilder builder, dismissible) {
    if (kIsWeb || Platform.isAndroid || Platform.isWindows) {
      return showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: dismissible,
      );
    } else {
      return showCupertinoDialog<T>(
        context: context,
        builder: builder,
      );
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? content,
    String? positiveTextButton,
    final VoidCallback? positiveOnPressed,
    String? destructiveTextButton,
    final VoidCallback? destructiveOnPressed,
    String? negativeTextButton,
    final VoidCallback? negativeOnPressed,
    bool dismissible = false,
  }) {
    final titleWidget = _getTitle(title, context);
    final contentWidget = _getContent(content, dismissible);

    var actions = _getActions(
      positiveTextButton,
      positiveOnPressed,
      negativeTextButton,
      negativeOnPressed,
      destructiveTextButton,
      destructiveOnPressed,
    );

    return _setupPlatformDialog(
      context,
      (context) => PlatformAlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: actions,
      ),
      dismissible,
    );
  }

  static Future<T?> showDialogContent<T>(
      BuildContext context, DialogContent dialogContent) {
    final titleWidget = _getTitle(dialogContent.title, context);
    final contentWidget =
        _getContent(dialogContent.message, dialogContent.dismissible);

    var actions = _getActions(
      dialogContent.positiveButtonText,
      () {
        Navigator.of(context).pop();
        dialogContent.positiveButtonCallback?.call();
      },
      dialogContent.negativeButtonText,
      () {
        Navigator.of(context).pop();
        dialogContent.negativeButtonCallback?.call();
      },
      dialogContent.destructiveButtonText,
      () {
        Navigator.of(context).pop();
        dialogContent.destructiveButtonCallback?.call();
      },
    );

    return _setupPlatformDialog(
      context,
      (context) => PlatformAlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: actions,
      ),
      dialogContent.dismissible,
    );
  }

  static Future<T?> showDialogWidget<T>(BuildContext context,
      DialogContent dialogContent, Widget? contentWidget) {
    final titleWidget = _getTitle(dialogContent.title, context);

    var actions = _getActions(
      dialogContent.positiveButtonText,
      () {
        Navigator.of(context).pop();
        dialogContent.positiveButtonCallback?.call();
      },
      dialogContent.negativeButtonText,
      () {
        Navigator.of(context).pop();
        dialogContent.negativeButtonCallback?.call();
      },
      dialogContent.destructiveButtonText,
      () {
        Navigator.of(context).pop();
        dialogContent.destructiveButtonCallback?.call();
      },
    );
    return _setupPlatformDialog(
      context,
      (context) => PlatformAlertDialog(
        title: titleWidget,
        content: contentWidget,
        actions: actions,
      ),
      dialogContent.dismissible,
    );
  }

  static Widget? _getTitle(String? title, BuildContext context) {
    if (title == null) {
      return null;
    }

    return Text(title,
        style: context.textTheme.titleMedium
            ?.copyWith(color: AppColors.textBodyDark));
  }

  static Widget? _getContent(String? content, bool dismissible) {
    if (content == null) {
      return null;
    }

    return PopScope(
      canPop: dismissible,
      child: Padding(
        padding: EdgeInsets.only(top: Values.marginShort),
        child: Text(
          content,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static List<Widget>? _getActions(
    String? positiveTextButton,
    VoidCallback? positiveOnPressed,
    String? negativeTextButton,
    VoidCallback? negativeOnPressed,
    String? destructiveTextButton,
    VoidCallback? destructiveOnPressed,
  ) {
    var actions = <Widget>[];
    if (negativeTextButton != null) {
      actions.add(PlatformDialogAction(
        type: TypeButtonDialog.negative,
        text: negativeTextButton,
        onPressed: negativeOnPressed,
      ));
    }
    if (positiveTextButton != null) {
      actions.add(PlatformDialogAction(
        type: TypeButtonDialog.positive,
        text: positiveTextButton,
        onPressed: positiveOnPressed,
        isDefaultAction: true,
      ));
    }
    if (destructiveTextButton != null) {
      actions.add(PlatformDialogAction(
        text: destructiveTextButton,
        onPressed: destructiveOnPressed,
        isDestructiveAction: true,
      ));
    }
    return actions.isEmpty ? null : actions;
  }
}
