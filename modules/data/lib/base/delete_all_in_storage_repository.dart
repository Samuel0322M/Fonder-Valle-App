import 'package:data/base/db_source.dart';
import 'package:domain/base/delete_all_in_storage_use_case.dart';
import 'package:models/database_object.dart';

mixin DeleteAllInStorageRepositoryAdapter<T extends DatabaseObject>
    implements DeleteAllInStorageRepository<T> {
  DbSource get dbSource;

  @override
  Future deleteAll([Map? args]) {
    return (dbSource as DeleteAllDbSource<T>).deleteAll(args);
  }
}
