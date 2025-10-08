import 'package:data/base/api_source.dart';
import 'package:data/base/save_repository.dart';
import 'package:domain/authentication_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/authentication_data.dart';
import 'package:models/login_request.dart';

mixin AuthenticationApiSource on PostApiSource<AuthenticationData, LoginRequest> {}

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryAdapter
    with SaveRepositoryAdapter<AuthenticationData, LoginRequest>
    implements AuthenticationRepository {
  @override
  final AuthenticationApiSource apiSource;

  AuthenticationRepositoryAdapter(this.apiSource);
}
