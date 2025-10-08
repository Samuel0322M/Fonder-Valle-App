// packages/db_source/lib/repositories/prospect_local_repository_impl.dart
import 'package:db_source/adapters/create_prospect_data_adapter.dart';
import 'package:db_source/adapters/login_storage_adapter.dart';
import 'package:db_source/adapters/prospect_data_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/prospect_response.dart';
import 'package:domain/repository/prospect_local_repository.dart';

@LazySingleton(as: ProspectLocalRepository)
class ProspectLocalRepositoryImpl implements ProspectLocalRepository {
  final LoginStorageAdapter loginDataAdapter;

  ProspectLocalRepositoryImpl(this.loginDataAdapter);

  @override
  Future<void> saveAll(List<ProspectResponse> prospects) async {
    final session = await loginDataAdapter.get('session');
    if (session == null) return;

    final adapter = ProspectDataAdapter(session.userName);
    for (final p in prospects) {
      await adapter.save(p.numberID, p);
    }
  }

  @override
  Future<List<ProspectResponse>> getAll() async {
    final session = await loginDataAdapter.get('session');
    if (session == null) return [];

    final adapter = ProspectDataAdapter(session.userName);
    return await adapter.getAll();
  }

  @override
  Future<void> saveCreatedProspect(CreateProspectRequest prospect) async {
    final session = await loginDataAdapter.get('session');
    if (session == null) {
      print("❌ No hay sesión activa, no se puede guardar.");
      return;
    }

    if (prospect.idNumber == null || prospect.idNumber!.trim().isEmpty) {
      print("❌ La cédula (idNumber) está vacía o nula. No se puede guardar el prospecto.");
      return;
    }

    print("📤 Guardando prospecto con cédula: ${prospect.idNumber}");

    final adapter = CreateProspectDataAdapter(session.userName);
    try {
      await adapter.save(prospect.idNumber!, prospect);
      print("✅ Prospecto guardado localmente.");
    } catch (e, s) {
      print("❌ Error al guardar en Hive: $e");
      print("🔍 Stacktrace: $s");
      print("📄 Datos: ${prospect.toJson()}");
      rethrow; // deja que lo capture el bloc y muestre error
    }
  }

  @override
  Future<List<CreateProspectRequest>> getCreatedLocalProspects() async {
    final session = await loginDataAdapter.get('session');
    if (session == null) return [];

    final adapter = CreateProspectDataAdapter(session.userName);
    return await adapter.getAll();
  }

  @override
  Future<CreateProspectRequest?> getCreatedProspectById(String idNumber) async {
    final session = await loginDataAdapter.get('session');
    if (session == null) return null;

    final adapter = CreateProspectDataAdapter(session.userName);
    return await adapter.get(idNumber);
  }

  @override
  Future<ProspectResponse?> getProspectByNumberID(String numberID) async {
    final session = await loginDataAdapter.get('session');
    if (session == null) return null;

    final adapter = ProspectDataAdapter(session.userName);
    return await adapter.get(numberID);
  }

  @override
  Future<void> deleteCreatedProspect(String idNumber) async {
    final session = await loginDataAdapter.get('session');
    if (session == null) return;

    final adapter = CreateProspectDataAdapter(session.userName);
    await adapter.delete(idNumber);
  }
}
