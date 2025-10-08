// File: tu_aliado/packages/domain/lib/use_cases/save_all_prospect_local_use_case.dart
import 'package:domain/repository/prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_response.dart';

@injectable
class GetAllProspectLocalUseCase {
  final ProspectLocalRepository adapter;

  GetAllProspectLocalUseCase(this.adapter);

  Future<List<ProspectResponse>> call() async {
    return await adapter.getAll();
  }
}
