import 'package:domain/base/repository.dart';

mixin SimpleGetRepository<T> on Repository {
  Future<T?> get([Map? args]);
}

mixin SimpleGetUseCase<T> {
  Future<T?> get([Map? args]);
}

mixin SimpleGetUseCaseAdapter<T> implements SimpleGetUseCase<T> {
  Repository get repository;

  @override
  Future<T?> get([Map? args]) {
    return (repository as SimpleGetRepository<T>).get(args);
  }
}
