import 'package:data/base/api_source.dart';
import 'package:data/base/save_repository.dart';
import 'package:domain/get_all_tracking_prospect_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_request.dart';
import 'package:models/tracking_prospect_model.dart';

mixin GetAllTrackingProspectApiSource
    on PostApiSource<List<TrackingProspectModel>, ProspectRequest> {}

@Injectable(as: GetAllTrackingProspectRepository)
class GetAllTrackingProspectRepositoryAdapter
    with SaveRepositoryAdapter<List<TrackingProspectModel>, ProspectRequest>
    implements GetAllTrackingProspectRepository {
  @override
  final GetAllTrackingProspectApiSource apiSource;

  GetAllTrackingProspectRepositoryAdapter(this.apiSource);
}
