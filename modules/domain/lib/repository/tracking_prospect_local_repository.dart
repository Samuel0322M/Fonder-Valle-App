import 'package:models/tracking_prospect_model.dart';

abstract class TrackingProspectLocalRepository {
  Future<void> saveAll(List<TrackingProspectModel> trackings, String prospectNumberID);

  Future<void> save(String prospectNumberID, TrackingProspectModel tracking);

  Future<List<TrackingProspectModel>> getAll(String prospectNumberID);
}
