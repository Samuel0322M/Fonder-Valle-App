// authentication_repository.dart

import 'package:models/authentication_data.dart';

abstract class AuthenticationRepository {
  Future<void> save(AuthenticationData data);

  AuthenticationData? get();

  Future<void> delete();
}
