import 'package:data/base/db_source.dart';
import 'package:domain/base/simple_save_in_storage_use_case.dart';
import 'package:models/database_object.dart';

mixin SimpleSaveInStorageRepositoryAdapter<T extends DatabaseObject>
    implements SimpleSaveInStorageRepository<T> {
  DbSource get dbSource;

  @override
  Future<void> saveInStorage(T request, [Map? args, bool? useDebounce]) {
    return (dbSource as SimplePutDbSource<T>).put(request, args);
  }
}
