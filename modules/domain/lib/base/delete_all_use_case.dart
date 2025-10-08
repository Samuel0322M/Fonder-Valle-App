import 'package:domain/base/repository.dart';

mixin DeleteAllRepository<T> on Repository {
  Future<void> deleteAll([Map? args]);
}

mixin DeleteAllUseCase<T> {
  Future<void> deleteAll([Map<String, dynamic>? params]);
}

mixin DeleteByIdUseCaseAdapter<T> implements DeleteAllUseCase<T> {
  Repository get repository;

  @override
  Future<void> deleteAll([Map<String, dynamic>? params]) {
    return (repository as DeleteAllRepository<T>).deleteAll(params);
  }
}
