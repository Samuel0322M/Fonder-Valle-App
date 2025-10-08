import 'package:data/base/api_source.dart';
import 'package:data/base/db_source.dart';
import 'package:domain/base/get_all_use_case.dart';
import 'package:models/database_object.dart';

mixin StorageGetAllRepositoryAdapter<T extends DatabaseObject>
    implements GetAllRepository<T> {
  ApiSource get apiSource;
  DbSource get dbSource;

  @override
  Future<List<T>> getAll([Map? args]) async {
    final result = await (apiSource as GetAllApiSource<T>).getAll(args);
    await (dbSource as PutAllDbSource<T>).putAll(result, args: args);
    return result;
  }
}

mixin GetAllRepositoryAdapter<T> implements GetAllRepository<T> {
  ApiSource get apiSource;

  @override
  Future<List<T>> getAll([Map? args]) {
    return (apiSource as GetAllApiSource<T>).getAll(args);
  }
}
