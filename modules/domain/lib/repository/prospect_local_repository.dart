// packages/domain/lib/repositories/prospect_local_repository.dart
import 'package:models/create_prospect_request.dart';
import 'package:models/prospect_response.dart';

abstract class ProspectLocalRepository {
  Future<void> saveAll(List<ProspectResponse> prospects);

  Future<List<ProspectResponse>> getAll();

  Future<void> saveCreatedProspect(CreateProspectRequest prospect);

  Future<List<CreateProspectRequest>> getCreatedLocalProspects();

  Future<CreateProspectRequest?> getCreatedProspectById(String idNumber);

  Future<ProspectResponse?> getProspectByNumberID(String numberID);

  Future<void> deleteCreatedProspect(String idNumber);
}
