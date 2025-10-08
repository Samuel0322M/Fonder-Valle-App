// File: tu_aliado/modules/domain/lib/create_prospect/local/get_all_create_prospect_local_use_case.dart
import 'package:domain/repository/prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';

@injectable
class GetAllCreateProspectLocalUseCase {
  final ProspectLocalRepository adapter;

  GetAllCreateProspectLocalUseCase(this.adapter);

  Future<List<CreateProspectRequest>> call() async {
    return await adapter.getCreatedLocalProspects();
  }
}
