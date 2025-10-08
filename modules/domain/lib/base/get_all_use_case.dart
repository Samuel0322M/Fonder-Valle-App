import 'package:domain/base/repository.dart';

mixin GetAllRepository<T> on Repository {
  Future<List<T>> getAll([Map? args]);
}

mixin GetAllUseCase<T> {
  Future<List<T>> getAll([Map? args]);
}

mixin GetAllUseCaseAdapter<T> implements GetAllUseCase<T> {
  Repository get repository;

  @override
  Future<List<T>> getAll([Map? args]) {
    return (repository as GetAllRepository<T>).getAll(args);
  }
}
