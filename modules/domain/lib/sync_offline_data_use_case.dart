import 'package:domain/create_prospect/local/save_create_prospect_local_use_case.dart';
import 'package:domain/create_prospect_tracking_use_case.dart';
import 'package:domain/create_prospect/remote/create_prospect_use_case.dart';
import 'package:domain/create_prospect/local/get_all_create_prospect_local_use_case.dart';
import 'package:domain/get_all_create_tracking_prospect_local_use_case.dart';
import 'package:domain/create_prospect/local/get_create_prospect_local_use_case.dart';
import 'package:domain/delete_create_tracking_local_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/create_tracking_request.dart';

@injectable
class SyncOfflineDataUseCase {
  final CreateProspectUseCase _remoteProspectsUseCase;
  final GetCreateProspectLocalUseCase _getLocalProspectsUseCase;
  final GetAllCreateTrackingProspectLocalUseCase _getLocalTrackingUseCase;
  final CreateProspectTrackingUseCase _remoteTrackingUseCase;
  final DeleteCreateTrackingLocalUseCase _deleteTrackingUseCase;
  final GetAllCreateProspectLocalUseCase _getAllCreateProspectLocalUseCase;

  SyncOfflineDataUseCase(
      this._getAllCreateProspectLocalUseCase,
      this._remoteProspectsUseCase,
      this._getLocalProspectsUseCase,
      this._getLocalTrackingUseCase,
      this._remoteTrackingUseCase,
      this._deleteTrackingUseCase,
      );

  Future<void> execute() async {
    final localCreateProspects = await _getAllCreateProspectLocalUseCase.call();

    for (final prospect in localCreateProspects) {
      try {
        await _remoteProspectsUseCase.save(prospect);
        final trackings = await _getLocalTrackingUseCase.call(prospect.idNumber ?? '');

        for (final tracking in trackings) {
          try {
            await _remoteTrackingUseCase.save(tracking);
            await _deleteTrackingUseCase.call(tracking.idNumber);
          } catch (_) {
            // Handle individual tracking sync error if needed
          }
        }

        // Optionally delete prospect after successful sync
        // await _deleteLocalProspectUseCase.call(prospect.idNumber);
      } catch (_) {
        // Handle sync error for this prospect
      }
    }
  }
}
