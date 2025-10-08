// File: tu_aliado/packages/db_source/lib/adapters/prospect_data_adapter.dart

import 'package:db_source/adapters/base_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_response.dart';

@LazySingleton()
class ProspectDataAdapter extends BaseAdapter<ProspectResponse> {
  final String userId;

  ProspectDataAdapter(this.userId);

  @override
  String get boxName => 'prospects_box_$userId';
}
