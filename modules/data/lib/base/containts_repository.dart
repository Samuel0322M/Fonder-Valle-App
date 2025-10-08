import 'package:data/base/db_source.dart';
import 'package:domain/base/containts_use_case.dart';

mixin ContaintsRepositoryAdapter<bool> implements ContaintsRepository<bool> {
  DbSource get dbSource;
  @override
  Stream<bool> containts(String id, [Map? args]) {
    return (dbSource as ContaintsDbSource<bool>).containts(id);
  }
}
