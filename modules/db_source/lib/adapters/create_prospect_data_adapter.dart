// File: db_source/lib/adapters/create_prospect_data_adapter.dart
import 'package:db_source/adapters/base_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';

@LazySingleton()
class CreateProspectDataAdapter extends BaseAdapter<CreateProspectRequest> {
  final String userId;

  CreateProspectDataAdapter(this.userId);

  @override
  String get boxName => 'create_prospects_box_$userId';
}
