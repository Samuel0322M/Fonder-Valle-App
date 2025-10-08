import 'package:data/base/api_source.dart';
import 'package:data/base/db_source.dart';
import 'package:domain/base/save_use_case.dart';
import 'package:models/database_object.dart';

mixin StorageSaveRepositoryAdapter<T extends DatabaseObject, R>
    implements SaveRepository<T, R> {
  ApiSource get apiSource;
  DbSource get dbSource;

  @override
  Future<T> save(R request, [Map? args]) {
    return (apiSource as PostApiSource<T, R>)
        .post(request, args)
        .then((result) async {
      await (dbSource as PutDbSource<T>).put(result, args);
      return result;
    });
  }
}

mixin SaveRepositoryAdapter<T, R> implements SaveRepository<T, R> {
  ApiSource get apiSource;

  @override
  Future<T> save(R request, [Map? args]) {
    return (apiSource as PostApiSource<T, R>).post(request, args);
  }
}
