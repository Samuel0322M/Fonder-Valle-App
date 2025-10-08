import 'package:domain/base/save_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/create_prospect_response.dart';

mixin CreateProspectRepository
    on SaveRepository<CreateProspectResponse, CreateProspectRequest> {}

mixin CreateProspectUseCase
    on SaveUseCase<CreateProspectResponse, CreateProspectRequest> {}

@Injectable(as: CreateProspectUseCase)
class CreateProspectUseCaseAdapter
    with SaveUseCaseAdapter<CreateProspectResponse, CreateProspectRequest>
    implements CreateProspectUseCase {
  @override
  final CreateProspectRepository repository;

  CreateProspectUseCaseAdapter(this.repository);
}
