// File: packages/db_source/lib/repositories/session_repository_impl.dart

import 'package:injectable/injectable.dart';
import 'package:db_source/adapters/login_storage_adapter.dart';
import 'package:domain/repository/session_local_repository.dart';
import 'package:models/login_request.dart';

@LazySingleton(as: SessionLocalRepository)
class SessionLocalRepositoryImpl implements SessionLocalRepository {
  final LoginStorageAdapter adapter;

  SessionLocalRepositoryImpl(this.adapter);

  @override
  Future<LoginRequest?> getSession() async {
    return await adapter.get('session');
  }

  @override
  Future<void> deleteSession() async {
    await adapter.delete('session');
  }

  @override
  Future<void> saveSession(LoginRequest data) async {
    await adapter.save('session', data);
  }
}
