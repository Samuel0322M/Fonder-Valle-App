import 'package:data/base/api_source.dart';
import 'package:data/base/db_source.dart';
import 'package:domain/base/get_by_id_use_case.dart';
import 'package:models/database_object.dart';

mixin StorageGetByIdRepositoryAdapter<T extends DatabaseObject>
    implements GetByIdRepository<T> {
  ApiSource get apiSource;
  DbSource get dbSource;

  @override
  Future<T?> getById(String id, [Map? args]) {
    return (apiSource as GetByIdApiSource<T>)
        .getById(id, args)
        .then((result) async {
      if (result != null) {
        await (dbSource as PutDbSource<T>).put(result, args);
      }
      return result;
    });
  }
}

mixin GetByIdRepositoryAdapter<T> implements GetByIdRepository<T> {
  ApiSource get apiSource;

  @override
  Future<T?> getById(String id, [Map? args]) {
    return (apiSource as GetByIdApiSource<T>).getById(id, args);
  }
}
