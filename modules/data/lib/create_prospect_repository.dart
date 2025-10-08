import 'package:data/base/api_source.dart';
import 'package:data/base/save_repository.dart';
import 'package:domain/create_prospect/remote/create_prospect_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/create_prospect_response.dart';

mixin CreateProspectApiSource
    on PostApiSource<CreateProspectResponse, CreateProspectRequest> {}

@Injectable(as: CreateProspectRepository)
class CreateProspectRepositoryAdapter
    with SaveRepositoryAdapter<CreateProspectResponse, CreateProspectRequest>
    implements CreateProspectRepository {
  @override
  final CreateProspectApiSource apiSource;

  CreateProspectRepositoryAdapter(this.apiSource);
}
