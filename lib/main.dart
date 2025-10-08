import 'package:db_source/hive_config.dart';
import 'package:db_source/registrars/hive_type_adapter_registrar.dart';
import 'package:flutter/material.dart';
import 'package:infivalle/app_di.dart';

import 'base_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();
  HiveTypeAdapterRegistrar.registerAll();
  configureDependencies();

  runApp(const BaseApp());
}