import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:models/authentication_data.dart';
import 'package:user_interface/utils/application.dart';

@module
abstract class AppModule {
  @Named('authority')
  String get authority => const String.fromEnvironment('authority');

  @Named('key')
  String get keyAuthorization =>
      const String.fromEnvironment('keyAuthorization');

  @Named('isWeb')
  bool get isWeb => kIsWeb;

  AuthenticationData get authenticationData => Application().authenticationData;

  Dio get dio {
    Dio dio = Dio();

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }

    return dio;
  }
}
