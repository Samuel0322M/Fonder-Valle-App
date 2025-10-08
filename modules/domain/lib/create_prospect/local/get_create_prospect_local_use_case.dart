// File: tu_aliado/modules/domain/lib/create_prospect/local/get_create_prospect_local_use_case.dart
import 'package:domain/repository/prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';

@injectable
class GetCreateProspectLocalUseCase {
  final ProspectLocalRepository adapter;

  GetCreateProspectLocalUseCase(this.adapter);

  Future<CreateProspectRequest?> call(String numberId) async {
    return await adapter.getCreatedProspectById(numberId);
  }
}
