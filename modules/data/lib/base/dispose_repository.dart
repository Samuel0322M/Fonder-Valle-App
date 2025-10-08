import 'package:data/base/db_source.dart';
import 'package:domain/base/dispose_use_case.dart';

mixin DisposeRepositoryAdapter implements DisposeRepository {
  DbSource get dbSource;

  @override
  Future<void> dispose() {
    return (dbSource as DisposeDbSource).dispose();
  }
}
