// File: tu_aliado/packages/domain/lib/use_cases/save_all_prospect_local_use_case.dart
import 'package:domain/repository/tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/tracking_prospect_model.dart';

@injectable
class SaveAllTrackingProspectLocalUseCase {
  final TrackingProspectLocalRepository adapter;

  SaveAllTrackingProspectLocalUseCase(this.adapter);

  Future<void> call(List<TrackingProspectModel> trackingProspects,
      String prospectNumberID) async {
    await adapter.saveAll(trackingProspects, prospectNumberID);
  }
}
