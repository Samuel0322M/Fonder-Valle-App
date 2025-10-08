import 'package:api_source/api_source.dart';
import 'package:api_source/utils/api_paths.dart';
import 'package:data/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:models/authentication_data.dart';
import 'package:models/login_request.dart';

@Injectable(as: AuthenticationApiSource)
class AuthenticationApiSourceAdapter implements AuthenticationApiSource {
  final ApiSource _apiSource;

  AuthenticationApiSourceAdapter(this._apiSource);

  @override
  Future<AuthenticationData> post(LoginRequest request, [Map? args]) {
    final endpoint = '${_apiSource.authority}${ApiPaths.oauthToken}';
    final Options options = Options(headers: {
      'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
    });

    return _apiSource.postApi(
      "https://finansuenos.cuotasoft.com/api_creacion_prospecto_finan/",
      options: options,
      data: request.toJson(),
      (value) {
        return AuthenticationData.fromJson(value["data"]);
      },
    );
  }
}
