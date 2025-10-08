import 'package:data/base/api_source.dart';
import 'package:data/base/save_repository.dart';
import 'package:domain/create_prospect_tracking_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_response.dart';
import 'package:models/create_tracking_request.dart';

mixin CreateProspectTrackingApiSource
    on PostApiSource<CreateProspectResponse, CreateTrackingRequest> {}

@Injectable(as: CreateProspectTrackingRepository)
class CreateProspectTrackingRepositoryAdapter
    with SaveRepositoryAdapter<CreateProspectResponse, CreateTrackingRequest>
    implements CreateProspectTrackingRepository {
  @override
  final CreateProspectTrackingApiSource apiSource;

  CreateProspectTrackingRepositoryAdapter(this.apiSource);
}
