// File: tu_aliado/packages/domain/lib/use_cases/local/get_login_local_use_case.dart

import 'package:domain/repository/session_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/login_request.dart';

@injectable
class GetLoginLocalUseCase {
  final SessionLocalRepository repository;

  GetLoginLocalUseCase(this.repository);

  Future<LoginRequest?> call() async {
    return await repository.getSession();
  }
}
