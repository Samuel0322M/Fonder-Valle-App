import 'package:domain/base/repository.dart';

mixin DisposeRepository on Repository {
  Future<void> dispose();
}

mixin DisposeUseCase {
  Future<void> dispose();
}

mixin DisposeUseCaseAdapter implements DisposeUseCase {
  Repository get repository;

  @override
  Future<void> dispose() {
    return (repository as DisposeRepository).dispose();
  }
}
