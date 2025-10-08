// modules/domain/lib/authentication_use_case.dart
import 'package:domain/base/save_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/authentication_data.dart';
import 'package:models/login_request.dart';

mixin AuthenticationRepository
    on SaveRepository<AuthenticationData, LoginRequest> {}

mixin AuthenticationUseCase on SaveUseCase<AuthenticationData, LoginRequest> {}

@Injectable(as: AuthenticationUseCase)
class AuthenticationUseCaseAdapter
    with SaveUseCaseAdapter<AuthenticationData, LoginRequest>
    implements AuthenticationUseCase {
  @override
  final AuthenticationRepository repository;

  AuthenticationUseCaseAdapter(this.repository);
}
