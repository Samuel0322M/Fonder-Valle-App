// File: db_source/lib/adapters/tracking_prospect_data_adapter.dart
import 'package:db_source/adapters/base_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:models/tracking_prospect_model.dart';

@LazySingleton()
class TrackingProspectDataAdapter extends BaseAdapter<TrackingProspectModel> {
  final String userId;

  TrackingProspectDataAdapter(this.userId);

  @override
  String get boxName => 'tracking_prospects_box_$userId';
}
