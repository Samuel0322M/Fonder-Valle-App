import 'package:db_source/adapters/login_storage_adapter.dart';
import 'package:db_source/adapters/create_tracking_prospect_data_adapter.dart';
import 'package:domain/repository/create_tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_tracking_request.dart';

@LazySingleton(as: CreateTrackingProspectLocalRepository)
class CreateTrackingLocalRepositoryImpl
    implements CreateTrackingProspectLocalRepository {
  final LoginStorageAdapter loginStorageAdapter;

  CreateTrackingLocalRepositoryImpl(this.loginStorageAdapter);

  @override
  Future<void> save(
    String prospectNumberID,
    CreateTrackingRequest createTracking,
  ) async {
    final session = await loginStorageAdapter.get('session');
    if (session == null) return;

    final adapter = CreateTrackingProspectDataAdapter(
      '${session.userName}$prospectNumberID',
    );

    await adapter.save(
      '${session.userName}$prospectNumberID${DateTime.now().toIso8601String()}',
      createTracking,
    );
  }

  @override
  Future<List<CreateTrackingRequest>> getAll(String prospectNumberID) async {
    final session = await loginStorageAdapter.get('session');
    if (session == null) return [];

    print( '_______________________:::::::::::::${session.userName}$prospectNumberID');
    final adapter = CreateTrackingProspectDataAdapter(
      '${session.userName}$prospectNumberID',
    );
    return await adapter.getAll();
  }

  @override
  Future<void> deleteAll(String prospectNumberID) async {
    final session = await loginStorageAdapter.get('session');
    if (session == null) return;

    print( '___deleteAll____________________:::::::::::::${session.userName}$prospectNumberID');
    final adapter = CreateTrackingProspectDataAdapter(
      '${session.userName}$prospectNumberID',
    );
    await adapter.clear();
  }
}
