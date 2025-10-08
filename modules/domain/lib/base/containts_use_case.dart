import 'package:domain/base/repository.dart';

mixin ContaintsRepository<bool> on Repository {
  Stream<bool> containts(String id, [Map? args]);
}

mixin ContanintsUseCase<T> {
  Stream<bool> containts(String id, [Map? args]);
}

mixin ContaintsUseCaseAdapter<T> implements ContanintsUseCase<bool> {
  Repository get repository;

  @override
  Stream<bool> containts(String id, [Map? args]) {
    return (repository as ContaintsRepository<bool>).containts(id, args);
  }
}
