import 'package:data/base/api_source.dart';
import 'package:domain/base/update_use_case.dart';

mixin UpdateRepositoryAdapter<T, R> implements UpdateRepository<T, R> {
  ApiSource get apiSource;

  @override
  Future<T> update(R request, [Map? args]) {
    return (apiSource as PutApiSource<T, R>).put(request, args);
  }
}
