// File: tu_aliado/modules/domain/lib/create_prospect/local/save_create_prospect_local_use_case.dart
import 'package:domain/repository/prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';

@injectable
class SaveCreateProspectLocalUseCase {
  final ProspectLocalRepository adapter;

  SaveCreateProspectLocalUseCase(this.adapter);

  Future<void> call(CreateProspectRequest prospect) async {
    await adapter.saveCreatedProspect(prospect);
  }
}
