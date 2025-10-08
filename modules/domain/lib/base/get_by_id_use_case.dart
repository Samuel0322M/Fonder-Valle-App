import 'package:domain/base/repository.dart';

mixin GetByIdRepository<T> on Repository {
  Future<T?> getById(String id, [Map? args]);
}

mixin GetByIdUseCase<T> {
  Future<T?> getById(String id, [Map? args]);
}

mixin GetByIdUseCaseAdapter<T> implements GetByIdUseCase<T> {
  Repository get repository;

  @override
  Future<T?> getById(String id, [Map? args]) {
    return (repository as GetByIdRepository<T>).getById(id, args);
  }
}
