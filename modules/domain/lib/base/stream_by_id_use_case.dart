import 'package:domain/base/repository.dart';

mixin StreamByIdRepository<T> on Repository {
  Stream<T?> streamById(String id, [Map? args]);
}

mixin StreamByIdUseCase<T> {
  Stream<T?> streamById(String id, [Map? args]);
}

mixin StreamByIdUseCaseAdapter<T> implements StreamByIdUseCase<T> {
  Repository get repository;

  @override
  Stream<T?> streamById(String id, [Map? args]) {
    return (repository as StreamByIdRepository<T>).streamById(id, args);
  }
}
