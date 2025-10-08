import 'package:db_source/adapters/login_storage_adapter.dart';
import 'package:db_source/adapters/tracking_prospect_data_adapter.dart';
import 'package:domain/repository/tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:models/tracking_prospect_model.dart';

@LazySingleton(as: TrackingProspectLocalRepository)
class TrackingLocalRepositoryImpl implements TrackingProspectLocalRepository {
  final LoginStorageAdapter loginStorageAdapter;

  TrackingLocalRepositoryImpl(this.loginStorageAdapter);

  @override
  Future<void> saveAll(List<TrackingProspectModel> trackings, String prospectNumberID) async {
    final session = await loginStorageAdapter.get('session');
    if (session == null) return;

    final adapter = TrackingProspectDataAdapter('${session.userName}$prospectNumberID');
    for (int i = 0; i < trackings.length; i++) {
      await adapter.save('${session.userName}$prospectNumberID${DateTime.now().toIso8601String()}', trackings[i]);
    }
  }

  @override
  Future<void> save(String prospectNumberID, TrackingProspectModel tracking) async {
    final session = await loginStorageAdapter.get('session');
    if (session == null) return;

    final adapter = TrackingProspectDataAdapter('${session.userName}$prospectNumberID');
    await adapter.save('${session.userName}$prospectNumberID${DateTime.now().toIso8601String()}', tracking);
  }

  @override
  Future<List<TrackingProspectModel>> getAll(String prospectNumberID) async {
    final session = await loginStorageAdapter.get('session');
    if (session == null) return [];

    final adapter = TrackingProspectDataAdapter('${session.userName}$prospectNumberID');
    return await adapter.getAll();
  }
}
