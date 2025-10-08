import 'package:flutter/material.dart';
import 'package:user_interface/l10n/app_localizations.dart';

class DialogContent {
  final String? title;
  final String? message;
  final String? positiveButtonText;
  final VoidCallback? positiveButtonCallback;
  final String? negativeButtonText;
  final VoidCallback? negativeButtonCallback;
  final String? destructiveButtonText;
  final VoidCallback? destructiveButtonCallback;
  final bool dismissible;

  DialogContent({
    this.title,
    this.message,
    this.positiveButtonText,
    this.positiveButtonCallback,
    this.negativeButtonText,
    this.negativeButtonCallback,
    this.destructiveButtonText,
    this.destructiveButtonCallback,
    this.dismissible = false,
  });

  DialogContent.defaultValues(AppLocalizations l10n)
      : title = "Information",
        message = l10n.titleError,
        positiveButtonText = l10n.allAccept,
        positiveButtonCallback = null,
        negativeButtonText = null,
        negativeButtonCallback = null,
        destructiveButtonText = null,
        destructiveButtonCallback = null,
        dismissible = true;
}
