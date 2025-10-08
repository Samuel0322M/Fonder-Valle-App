import 'package:api_source/di/api_source_di.module.dart';
import 'package:data/di/data_di.module.dart';
import 'package:domain/di/domain_di.module.dart';
import 'package:infivalle/app_di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:user_interface/di/ui_di.module.dart';
import 'package:db_source/db_source.module.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  externalPackageModulesAfter: [
    ExternalModule(ApiSourcePackageModule),
    ExternalModule(DataPackageModule),
    ExternalModule(DbSourcePackageModule),
    ExternalModule(DomainPackageModule),
    ExternalModule(UserInterfacePackageModule),
  ],
)
void configureDependencies() => getIt.init();
