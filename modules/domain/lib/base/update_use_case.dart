import 'package:domain/base/repository.dart';

mixin UpdateRepository<T, R> on Repository {
  Future<T> update(R request, [Map? args]);
}

mixin UpdateUseCase<T, R> {
  Future<T> update(R request, [Map? args]);
}

mixin UpdateUseCaseAdapter<T, R> implements UpdateUseCase<T, R> {
  Repository get repository;

  @override
  Future<T> update(R request, [Map? args]) {
    return (repository as UpdateRepository<T, R>).update(request, args);
  }
}
