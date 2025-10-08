// File: tu_aliado/modules/domain/lib/create_prospect/local/delete_create_prospect_local_use_case.dart

import 'package:injectable/injectable.dart';
import 'package:domain/repository/prospect_local_repository.dart';

@injectable
class DeleteCreateProspectLocalUseCase {
  final ProspectLocalRepository adapter;

  DeleteCreateProspectLocalUseCase(this.adapter);

  Future<void> call(String numberId) async {
    await adapter.deleteCreatedProspect(numberId);
  }
}
