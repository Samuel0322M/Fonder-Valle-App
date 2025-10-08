import 'package:domain/auth/save_login_local_use_case.dart';
import 'package:domain/authentication_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:models/login_request.dart';
import 'package:models/exceptions/connection_exception.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

@injectable
class LoginBloc extends Bloc {
  LoginBloc(
    this._authenticationUseCase,
    this._saveLoginLocalUseCase,
  );

  final AuthenticationUseCase _authenticationUseCase;
  final SaveLoginLocalUseCase _saveLoginLocalUseCase;

  static const grantType = 'password';

  final _showCircularProgressBehaviorSubject = BehaviorSubject<bool?>();
  final ValueNotifier<String?> userError = ValueNotifier(null);
  final ValueNotifier<String?> passwordError = ValueNotifier(null);

  ValueStream<bool?> get circularProgressIndicatorStream =>
      _showCircularProgressBehaviorSubject.stream;

  final _authenticationBehaviorSubject = BehaviorSubject<bool?>();

  ValueStream<bool?> get authenticationValueStream => _authenticationBehaviorSubject.stream;

  @override
  void dispose() {
    _showCircularProgressBehaviorSubject.close();
    _authenticationBehaviorSubject.close();

    userError.dispose();
    passwordError.dispose();
  }

  void updateUser(String value) {
    if (value.trim().isEmpty) {
      userError.value = l10n.requiredField;
    } else {
      userError.value = null;
    }
  }

  void updatePassword(String value) {
    if (value.trim().isEmpty) {
      passwordError.value = l10n.requiredField;
    } else {
      passwordError.value = null;
    }
  }

  Future<void> login(String userName, String password) async {
    try {
      _showCircularProgressBehaviorSubject.add(true);

      final LoginRequest loginRequest = LoginRequest(
        operation: 'logueo',
        userName: userName,
        password: password,
        permisosApps: [],
      );

      final authenticationData = await _authenticationUseCase.save(loginRequest);
      authenticationData.numberID = userName;
      Application().authenticationData = authenticationData;


      print('[PERMISOS API] ${authenticationData.permisos}');
      final allowedApps = authenticationData.permisos
          .where((p) => p.privAccess == 'Y')
          .map((p) => p.appName)
          .toList();

      final loginRequestLocal = LoginRequest(
        userName: userName,
        password: password,
        fullName: authenticationData.userName,
        permisosApps: allowedApps,
      );
      print('Permisos guardados: $allowedApps');
      _saveLoginLocalUseCase(loginRequestLocal);

      _showCircularProgressBehaviorSubject.add(false);
      _authenticationBehaviorSubject.add(true);
    } catch (error) {
      _showCircularProgressBehaviorSubject.add(false);
      _showError(error);
    }
  }

  void _showError(Object error) {
    final String title;
    final String message;

    if (error is ConnectionException) {
      title = l10n.networkError;
      message = l10n.networkErrorMessage;
    } else {
      title = l10n.titleError;
      message = l10n.messageErrorGeneral;
    }

    dialogSubject.addSecure(DialogContent(
      title: title,
      message: message,
      positiveButtonText: l10n.allAccept,
    ));
  }
}
