// File: tu_aliado/packages/domain/lib/use_cases/local/save_login_local_use_case.dart
import 'package:domain/repository/session_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/login_request.dart';

@injectable
class SaveLoginLocalUseCase {
  final SessionLocalRepository adapter;

  SaveLoginLocalUseCase(this.adapter);

  Future<void> call(LoginRequest data) async {
    await adapter.saveSession(data);
  }
}
