// File: tu_aliado/modules/domain/lib/create_prospect/local/create_prospect_local_use_case.dart

import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';

import 'get_all_create_prospect_local_use_case.dart';
import 'get_create_prospect_local_use_case.dart';
import 'save_create_prospect_local_use_case.dart';
import 'delete_create_prospect_local_use_case.dart';

@injectable
class CreateProspectLocalUseCase {
  final SaveCreateProspectLocalUseCase _saveCreateProspectLocalUseCase;
  final GetAllCreateProspectLocalUseCase _getAllCreateProspectLocalUseCase;
  final GetCreateProspectLocalUseCase _getCreateProspectLocalUseCase;
  final DeleteCreateProspectLocalUseCase _deleteCreateProspectLocalUseCase;

  CreateProspectLocalUseCase(
    this._saveCreateProspectLocalUseCase,
    this._getAllCreateProspectLocalUseCase,
    this._getCreateProspectLocalUseCase,
    this._deleteCreateProspectLocalUseCase,
  );

  Future<void> save(CreateProspectRequest prospect) {
    return _saveCreateProspectLocalUseCase(prospect);
  }

  Future<List<CreateProspectRequest>> getAll() {
    return _getAllCreateProspectLocalUseCase();
  }

  Future<CreateProspectRequest?> getById(String numberId) {
    return _getCreateProspectLocalUseCase(numberId);
  }

  Future<void> delete(String numberId) {
    return _deleteCreateProspectLocalUseCase(numberId);
  }
}
