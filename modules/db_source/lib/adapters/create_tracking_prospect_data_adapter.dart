// File: db_source/lib/adapters/tracking_prospect_data_adapter.dart
import 'package:db_source/adapters/base_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_tracking_request.dart';

@LazySingleton()
class CreateTrackingProspectDataAdapter
    extends BaseAdapter<CreateTrackingRequest> {
  final String userId;

  CreateTrackingProspectDataAdapter(this.userId);

  @override
  String get boxName => 'create_tracking_prospects_box_$userId';
}
