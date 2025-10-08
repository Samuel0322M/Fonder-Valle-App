import 'package:data/base/db_source.dart';
import 'package:domain/base/delete_by_id_in_storage_use_case.dart';
import 'package:models/database_object.dart';

mixin DeleteByIdInStorageRepositoryAdapter<T extends DatabaseObject>
    implements DeleteByIdInStorageRepository<T> {
  DbSource get dbSource;

  @override
  Future deleteInStorage(String id, [Map? args]) {
    return (dbSource as DeleteByIdDbSource<T>).deleteById(id, args);
  }
}
