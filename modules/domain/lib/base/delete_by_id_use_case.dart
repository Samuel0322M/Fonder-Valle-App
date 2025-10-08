import 'package:domain/base/repository.dart';

mixin DeleteByIdRepository<T> on Repository {
  Future<void> delete(String id, [Map? args]);
}

mixin DeleteByIdUseCase<T> {
  Future<void> delete(String id, [Map<String, dynamic>? params]);
}

mixin DeleteByIdUseCaseAdapter<T> implements DeleteByIdUseCase<T> {
  Repository get repository;

  @override
  Future<void> delete(String id, [Map<String, dynamic>? params]) {
    return (repository as DeleteByIdRepository<T>).delete(id, params);
  }
}
