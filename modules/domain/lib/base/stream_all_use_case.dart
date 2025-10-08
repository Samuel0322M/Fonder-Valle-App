import 'package:domain/base/repository.dart';

mixin StreamAllRepository<T> on Repository {
  Stream<List<T>> streamAll([Map? args]);
}

mixin StreamAllUseCase<T> {
  Stream<List<T>> streamAll([Map? args]);
}

mixin StreamAllUseCaseAdapter<T> implements StreamAllUseCase<T> {
  Repository get repository;

  @override
  Stream<List<T>> streamAll([Map? args]) {
    return (repository as StreamAllRepository<T>).streamAll(args);
  }
}
