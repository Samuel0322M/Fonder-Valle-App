import 'package:data/base/db_source.dart';
import 'package:domain/base/stream_by_id_use_case.dart';

mixin StorageStreamByIdRepositoryAdapter<T> implements StreamByIdRepository<T> {
  DbSource get dbSource;

  @override
  Stream<T?> streamById(String id, [Map? args]) {
    return (dbSource as StreamByIdDbSource<T>).streamById(id, args);
  }
}
