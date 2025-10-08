import 'package:data/base/db_source.dart';
import 'package:domain/base/save_all_in_storage_use_case.dart';
import 'package:models/database_object.dart';

mixin SaveAllInStorageRepositoryAdapter<T extends DatabaseObject>
    implements SaveAllInStorageRepository<T> {
  DbSource get dbSource;

  @override
  Future<List<T>> saveAllInStorage(List<T> request,
      [Map? args, bool? useDebounce]) {
    return (dbSource as PutAllDbSource<T>)
        .putAll(request, args: args, useDebounce: useDebounce);
  }
}
