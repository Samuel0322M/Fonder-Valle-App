import 'dart:async';

import 'package:domain/auth/get_login_local_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/pages/menu_page.dart';
import 'package:user_interface/pages/onboarding_page.dart';
import 'package:user_interface/utils/application.dart';

@injectable
class SplashBloc extends Bloc {
  final GetLoginLocalUseCase _getLoginLocalUseCase;

  SplashBloc(this._getLoginLocalUseCase);

  final _navigateStream = StreamController<RouteSettings?>.broadcast();
  Stream<RouteSettings?> get navigate => _navigateStream.stream;
  void navigateTo(RouteSettings? route) => _navigateStream.add(route);

  @override
  void dispose() {
    _navigateStream.close();
    super.dispose();
  }

  Future<void> checkSession() async {
    final session = await _getLoginLocalUseCase.call();
    if (session != null) {
      final authenticationData = Application().authenticationData;
      authenticationData.numberID = session.userName;
      authenticationData.userName = session.fullName ?? '';
      Application().authenticationData = authenticationData;

      // navigateTo(HomePage.route);
      navigateTo(RouteSettings(
        name: MenuPage.route,
        arguments: session.permisosApps ?? [],
      ));
    } else {
      navigateTo(const RouteSettings(name: OnboardingPage.route));
    }
  }
}
