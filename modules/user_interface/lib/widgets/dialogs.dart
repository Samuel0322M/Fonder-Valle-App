import 'package:flutter/material.dart';
import 'package:user_interface/resources/values.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/widgets/platform_alert_dialog.dart';
import 'package:user_interface/widgets/platform_alert_dialog_action.dart';
import 'package:user_interface/widgets/platform_circular_progress_indicator_widget.dart';

class Dialogs {
  static Map<dynamic, bool> visibleProgress = {};

  static bool isProgressVisible = false;

  static Future<void> showLoadingDialog({
    BuildContext? context,
  }) async {
    visibleProgress[context ?? Application().appNavigatorKey.currentContext!] =
        true;

    return showDialog<void>(
      context: context ?? Application().appNavigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: PlatformCircularProgressIndicatorWidget(),
          ),
        );
      },
    );
  }

  static void dismissLoadingDialog({
    bool rootNavigator = false,
    BuildContext? context,
  }) {
    final currentContext = context ?? Application().appNavigatorKey.currentContext;

    if (currentContext == null) return;

    final entry = visibleProgress.entries.firstWhere(
          (x) => x.key == currentContext,
      orElse: () => const MapEntry(null, false),
    );

    if (entry.key != null && entry.value == true) {
      visibleProgress.remove(currentContext);

      if (Navigator.canPop(currentContext)) {
        Navigator.of(currentContext, rootNavigator: rootNavigator).pop();
      }
    }
  }


  static Future<void> showAlertDialog(BuildContext context, String? title,
      String message, List<Widget> actions) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
              canPop: false,
              child: Center(
                child: PlatformAlertDialog(
                  title: title != null ? Text(title) : null,
                  content: Text(message),
                  actions: actions,
                ),
              ));
        });
  }

  static Future<void> showAlertDialogOneAction(
      BuildContext context,
      String? title,
      String message,
      String titleAction,
      VoidCallback onPressed) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
              canPop: false,
              child: Center(
                child: PlatformAlertDialog(
                  title: title != null ? Text(title) : null,
                  content: Text(message),
                  actions: <Widget>[
                    PlatformAlertDialogAction(
                        title: titleAction,
                        onPressed: () {
                          onPressed();
                          Navigator.of(context).pop();
                        })
                  ],
                ),
              ));
        });
  }

  static Future<void> showAlertDialogActionDissmis(
    BuildContext context,
    String? title,
    String message,
    String titleAction,
  ) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: PlatformAlertDialog(
              title: title != null ? Text(title) : null,
              content: Text(message),
              actions: <Widget>[
                PlatformAlertDialogAction(
                  title: titleAction,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  static Future<void> showCustomDialog(BuildContext context,
      {String? title, required Widget child, List<Widget>? actions}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Values.borderRadiusShort),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Values.paddingMedium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(title),
                  const SizedBox(height: Values.marginVertical),
                ],
                child,
                if (actions != null) ...[
                  const SizedBox(height: Values.marginVertical),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: actions,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
