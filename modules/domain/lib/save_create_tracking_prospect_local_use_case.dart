// File: tu_aliado/packages/domain/lib/use_cases/save_all_prospect_local_use_case.dart
import 'package:domain/repository/create_tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_tracking_request.dart';

@injectable
class SaveCreateTrackingProspectLocalUseCase {
  final CreateTrackingProspectLocalRepository adapter;

  SaveCreateTrackingProspectLocalUseCase(this.adapter);

  Future<void> call(
    String prospectNumberID,
    CreateTrackingRequest createTracking,
  ) async {
    await adapter.save(prospectNumberID, createTracking);
  }
}
