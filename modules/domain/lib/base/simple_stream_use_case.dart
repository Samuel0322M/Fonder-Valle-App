import 'package:domain/base/repository.dart';

mixin SimpleStreamRepository<T> on Repository {
  Stream<T?> stream([Map? args]);
}

mixin SimpleStreamUseCase<T> {
  Stream<T?> stream([Map? args]);
}

mixin SimpleStreamUseCaseAdapter<T> implements SimpleStreamUseCase<T> {
  Repository get repository;

  @override
  Stream<T?> stream([Map? args]) {
    return (repository as SimpleStreamRepository<T>).stream(args);
  }
}
