import 'dart:io';

import 'package:models/exceptions/connection_exception.dart';
import 'package:user_interface/l10n/app_localizations.dart';
import 'package:user_interface/utils/errors/error_data.dart';

class ErrorsUtils {
  ErrorsUtils._();

  static ErrorData iconFromError(Object error, AppLocalizations l10n) {
    final String title;
    final String message;

    switch (error.runtimeType) {
      case const (ConnectionException):
      case const (SocketException):
        title = l10n.networkError;
        message = l10n.networkErrorMessage;
        break;
      default:
        title = l10n.titleError;
        message = error.toString();
    }

    return ErrorData(title: title, message: message);
  }
}
