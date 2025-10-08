import 'package:domain/base/repository.dart';

mixin DeleteAllInStorageRepository<T> on Repository {
  Future deleteAll([Map? args]);
}

mixin DeleteAllInStorageUseCase<T> {
  Future deleteAll([Map<String, dynamic>? params]);
}

mixin DeleteAllInStorageUseCaseAdapter<T>
    implements DeleteAllInStorageUseCase<T> {
  Repository get repository;

  @override
  Future deleteAll([Map<String, dynamic>? params]) {
    return (repository as DeleteAllInStorageRepository<T>).deleteAll(params);
  }
}
