import 'package:data/base/db_source.dart';
import 'package:domain/base/simple_stream_use_case.dart';

mixin StorageSimpleStreamRepositoryAdapter<T>
    implements SimpleStreamRepository<T> {
  DbSource get dbSource;

  @override
  Stream<T?> stream([Map? args]) {
    return (dbSource as SimpleStreamDbSource<T>).stream(args);
  }
}
