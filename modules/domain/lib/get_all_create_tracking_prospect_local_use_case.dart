// File: tu_aliado/packages/domain/lib/use_cases/save_all_prospect_local_use_case.dart
import 'package:domain/repository/create_tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_tracking_request.dart';

@injectable
class GetAllCreateTrackingProspectLocalUseCase {
  final CreateTrackingProspectLocalRepository adapter;

  GetAllCreateTrackingProspectLocalUseCase(this.adapter);

  Future<List<CreateTrackingRequest>> call(String prospectNumberID) async {
    return await adapter.getAll(prospectNumberID);
  }
}
