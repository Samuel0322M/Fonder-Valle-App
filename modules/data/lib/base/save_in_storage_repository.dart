import 'package:data/base/db_source.dart';
import 'package:domain/base/save_in_storage_use_case.dart';
import 'package:models/database_object.dart';

mixin SaveInStorageRepositoryAdapter<T extends DatabaseObject>
    implements SaveInStorageRepository<T> {
  DbSource get dbSource;

  @override
  Future<T> saveInStorage(T request, [Map? args, bool? useDebounce]) {
    return (dbSource as PutDbSource<T>).put(request, args, useDebounce);
  }
}
