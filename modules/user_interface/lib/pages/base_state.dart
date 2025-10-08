import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/l10n/app_localizations.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/utils/extensions/context_extensions.dart';
import 'package:user_interface/widgets/alert/app_alert.dart';
import 'package:user_interface/widgets/dialogs.dart';

abstract class BaseState<T extends StatefulWidget, B extends Bloc>
    extends State<T> {
  late B bloc;
  late AppLocalizations l10n;

  @override
  void initState() {
    super.initState();

    bloc = _createBlocInstance();

    bloc.dialog.listen(
      (dialogContent) {
        AppAlert.showDialogContent(context, dialogContent);
      },
    );
    bloc.closePage.listen(
      (close) {
        if (close) {
          Navigator.pop(context);
        }
      },
    );
    bloc.snackbarMessage.listen(
      (message) {
        Application().appNavigatorKey.currentContext?.showSnackBar(message);
      },
    );

    bloc.loadingStream.listen((showCircularProgress) {
      if (showCircularProgress) {
        Dialogs.showLoadingDialog();
      } else {
        Dialogs.dismissLoadingDialog();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
    bloc.setL10n(l10n);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  B _createBlocInstance() {
    return GetIt.instance<B>();
  }
}
