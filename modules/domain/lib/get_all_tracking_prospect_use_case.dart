import 'package:domain/base/save_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_request.dart';
import 'package:models/tracking_prospect_model.dart';

mixin GetAllTrackingProspectRepository
    on SaveRepository<List<TrackingProspectModel>, ProspectRequest> {}

mixin GetAllTrackingProspectUseCase
    on SaveUseCase<List<TrackingProspectModel>, ProspectRequest> {}

@Injectable(as: GetAllTrackingProspectUseCase)
class GetAllTrackingProspectUseCaseAdapter
    with SaveUseCaseAdapter<List<TrackingProspectModel>, ProspectRequest>
    implements GetAllTrackingProspectUseCase {
  @override
  final GetAllTrackingProspectRepository repository;

  GetAllTrackingProspectUseCaseAdapter(this.repository);
}
