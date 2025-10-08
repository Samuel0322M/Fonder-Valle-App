import 'package:flutter/material.dart';
import 'package:user_interface/l10n/app_localizations.dart';
import 'package:user_interface/pages/splash_page.dart';
import 'package:user_interface/resources/theme/theme.dart';
import 'package:user_interface/routes/routes.dart';
import 'package:user_interface/utils/application.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    Application().appNavigatorKey = appNavigatorKey;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: "restoration_scope_app_id",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: Themes.materialLightTheme,
      themeMode: ThemeMode.light,
      title: 'Finansueños',
      navigatorKey: appNavigatorKey,
      initialRoute: "/",
      onGenerateRoute: _onGenerateRoute,
      home: const SplashPage(),
    );
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    final builder = AppRoutes.routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(
        builder: (context) => Stack(children: [builder(context, settings)]),
        settings: settings,
      );
    }

    assert(false, 'Need to implement ${settings.name}');

    return null;
  }
}
