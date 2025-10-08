// File: tu_aliado/packages/db_source/lib/adapters/login_storage_adapter.dart

import 'package:db_source/adapters/base_adapter.dart';
import 'package:injectable/injectable.dart';
import 'package:models/login_request.dart';

@LazySingleton()
class LoginStorageAdapter extends BaseAdapter<LoginRequest> {
  LoginStorageAdapter();

  @override
  String get boxName => 'login_data_box';
}
