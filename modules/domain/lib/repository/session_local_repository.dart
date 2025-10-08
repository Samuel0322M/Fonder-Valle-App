// File: packages/domain/lib/repositories/session_repository.dart

import 'package:models/login_request.dart';

abstract class SessionLocalRepository {
  Future<LoginRequest?> getSession();

  Future<void> saveSession(LoginRequest data);

  Future<void> deleteSession();
}
