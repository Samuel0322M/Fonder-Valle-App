import 'package:models/app_toast_content.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/l10n/app_localizations.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

abstract class Bloc {
  late AppLocalizations l10n;
  final dialogSubject = BehaviorSubject<DialogContent>();

  ValueStream<DialogContent> get dialog => dialogSubject.stream;
  final snackbarMessageSubject = BehaviorSubject<ToastContent>();

  ValueStream<ToastContent> get snackbarMessage =>
      snackbarMessageSubject.stream;

  Function(ToastContent) get showSnackBar => snackbarMessageSubject.sink.add;
  final closePageSubject = BehaviorSubject<bool>();

  ValueStream<bool> get closePage => closePageSubject.stream;
  final BehaviorSubject<bool> progressDialogSubject = BehaviorSubject<bool>();

  ValueStream<bool> get progressDialogStream => progressDialogSubject.stream;
  final _loadingSubject = BehaviorSubject<bool>();

  ValueStream<bool> get loadingStream => _loadingSubject.stream;

  void dispose() {
    dialogSubject.close();
    snackbarMessageSubject.close();
    closePageSubject.close();
    progressDialogSubject.close();
    _loadingSubject.close();
  }

  /// Used for all page loading
  void updateProgressDialog(bool loading) async {
    if (!progressDialogSubject.hasValue ||
        progressDialogSubject.value != loading) {
      progressDialogSubject.sink.add(loading);
      await progressDialogSubject.first;
    }
  }

  /// Used for BlockingCircularProgressWidget
  void handleLoading(bool loading) {
    if (_loadingSubject.valueOrNull != loading) {
      _loadingSubject.addSecure(loading);
    }
  }

  void setL10n(AppLocalizations l10n) {
    this.l10n = l10n;
  }

  void offlineMessage() {
    showSnackBar(
      ToastContent(
        message: l10n.messageOfflineMode,
        type: ToastType.warning,
      ),
    );
  }
}
