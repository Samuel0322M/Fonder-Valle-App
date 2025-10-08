import 'package:models/create_tracking_request.dart';

abstract class CreateTrackingProspectLocalRepository {
  Future<void> save(
    String prospectNumberID,
    CreateTrackingRequest createTracking,
  );

  Future<List<CreateTrackingRequest>> getAll(String prospectNumberID);

  Future<void> deleteAll(String prospectNumberID);
}
