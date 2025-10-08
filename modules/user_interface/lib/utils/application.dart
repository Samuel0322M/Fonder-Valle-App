import 'dart:async';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/widgets.dart';
import 'package:models/authentication_data.dart';

class Application {
  static Application? _singleton;
  late String platform;
  late AuthenticationData authenticationData;
  late String? timeZone;

  late GlobalKey<NavigatorState> appNavigatorKey;

  // ignore: close_sinks
  final StreamController<bool?> tokenExpired = StreamController.broadcast();

  factory Application() {
    _singleton ??= Application._();

    return _singleton!;
  }

  void logout() {
    authenticationData = AuthenticationData.empty();
  }

  Application._() {
    authenticationData = AuthenticationData.empty();
    platform = defaultTargetPlatform.name;
  }
}
