// File: tu_aliado/packages/domain/lib/use_cases/save_all_prospect_local_use_case.dart
import 'package:domain/repository/tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/tracking_prospect_model.dart';

@injectable
class GetAllTrackingProspectLocalUseCase {
  final TrackingProspectLocalRepository adapter;

  GetAllTrackingProspectLocalUseCase(this.adapter);

  Future<List<TrackingProspectModel>> call(String prospectNumberID) async {
    return await adapter.getAll(prospectNumberID);
  }
}
