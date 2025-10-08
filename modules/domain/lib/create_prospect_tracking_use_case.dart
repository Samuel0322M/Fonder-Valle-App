import 'package:domain/base/save_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_response.dart';
import 'package:models/create_tracking_request.dart';

mixin CreateProspectTrackingRepository
    on SaveRepository<CreateProspectResponse, CreateTrackingRequest> {}

mixin CreateProspectTrackingUseCase
    on SaveUseCase<CreateProspectResponse, CreateTrackingRequest> {}

@Injectable(as: CreateProspectTrackingUseCase)
class CreateProspectTrackingUseCaseAdapter
    with SaveUseCaseAdapter<CreateProspectResponse, CreateTrackingRequest>
    implements CreateProspectTrackingUseCase {
  @override
  final CreateProspectTrackingRepository repository;

  CreateProspectTrackingUseCaseAdapter(this.repository);
}
