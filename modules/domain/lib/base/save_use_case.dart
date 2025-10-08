import 'package:domain/base/repository.dart';

mixin SaveRepository<T, R> on Repository {
  Future<T> save(R request, [Map? args]);
}

mixin SaveUseCase<T, R> {
  Future<T> save(R request, [Map? args]);
}

mixin SaveUseCaseAdapter<T, R> implements SaveUseCase<T, R> {
  Repository get repository;

  @override
  Future<T> save(R request, [Map? args]) {
    return (repository as SaveRepository<T, R>).save(request, args);
  }
}
