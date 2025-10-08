import 'package:data/base/api_source.dart';
import 'package:data/base/db_source.dart';
import 'package:domain/base/delete_by_id_use_case.dart';
import 'package:models/database_object.dart';

mixin StorageDeleteByIdRepositoryAdapter<T extends DatabaseObject>
    implements DeleteByIdRepository<T> {
  ApiSource get apiSource;
  DbSource get dbSource;

  @override
  Future<void> delete(String id, [Map? args]) {
    return (apiSource as DeleteByIdApiSource<T>)
        .delete(id, args)
        .then((result) async {
      await (dbSource as DeleteByIdDbSource<T>).deleteById(id, args);
      return result;
    });
  }
}

mixin DeleteByIdRepositoryAdapter<T> implements DeleteByIdRepository {
  ApiSource? get apiSource;

  @override
  Future<void> delete(String id, [Map? args]) {
    return (apiSource as DeleteByIdApiSource<T>).delete(id, args);
  }
}
