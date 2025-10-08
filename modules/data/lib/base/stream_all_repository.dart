import 'package:data/base/db_source.dart';
import 'package:domain/base/stream_all_use_case.dart';

mixin StorageStreamAllRepositoryAdapter<T> implements StreamAllRepository<T> {
  DbSource get dbSource;

  @override
  Stream<List<T>> streamAll([Map? args]) {
    return (dbSource as StreamAllDbSource<T>).streamAll(args);
  }
}
