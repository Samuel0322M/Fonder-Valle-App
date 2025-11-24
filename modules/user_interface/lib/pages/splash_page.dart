import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_interface/blocs/splash_bloc.dart';
import 'package:user_interface/pages/base_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

  static const String route = '/';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const SplashPage();
  }
}

class _SplashPageState extends BaseState<SplashPage, SplashBloc> {
  late final StreamSubscription<RouteSettings?> _navigationSubscription;

  @override
  void dispose() {
    _navigationSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() {
    _navigationSubscription = bloc.navigate.listen((routeSettings) {
      if (routeSettings != null) {
        Navigator.of(context).pushReplacementNamed(
          routeSettings.name!,
          arguments: routeSettings.arguments,
        );
      }
    });

    bloc.checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/fondervalle_logo.png',
          width: 340,
        ),
      ),
    );
  }
}
