// File: tu_aliado/packages/domain/lib/use_cases/local/delete_login_local_use_case.dart
import 'package:domain/repository/session_local_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteLoginLocalUseCase {
  final SessionLocalRepository repository;

  DeleteLoginLocalUseCase(this.repository);

  Future<void> call() async {
    await repository.deleteSession();
  }
}
