// File: tu_aliado/packages/domain/lib/use_cases/save_all_prospect_local_use_case.dart
import 'package:domain/repository/tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/tracking_prospect_model.dart';

@injectable
class SaveTrackingProspectLocalUseCase {
  final TrackingProspectLocalRepository adapter;

  SaveTrackingProspectLocalUseCase(this.adapter);

  Future<void> call(
      TrackingProspectModel trackingProspect, String prospectNumberID) async {
    await adapter.save(prospectNumberID, trackingProspect);
  }
}
