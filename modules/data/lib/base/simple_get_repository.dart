import 'package:data/base/api_source.dart';
import 'package:data/base/db_source.dart';
import 'package:domain/base/simple_get_use_case.dart';
import 'package:models/database_object.dart';

mixin StorageSimpleGetRepositoryAdapter<T extends DatabaseObject>
    implements SimpleGetRepository<T> {
  ApiSource get apiSource;
  DbSource get dbSource;

  @override
  Future<T?> get([Map? args]) {
    return (apiSource as GetApiSource<T>).get(args).then((result) async {
      if (result != null) {
        await (dbSource as SimplePutDbSource<T>).put(result, args);
      }
      return result;
    });
  }
}

mixin SimpleGetRepositoryAdapter<T> implements SimpleGetRepository<T> {
  ApiSource get apiSource;

  @override
  Future<T?> get([Map? args]) {
    return (apiSource as GetApiSource<T>).get(args);
  }
}
