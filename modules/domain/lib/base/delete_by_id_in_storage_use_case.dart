import 'package:domain/base/repository.dart';

mixin DeleteByIdInStorageRepository<T> on Repository {
  Future deleteInStorage(String id, [Map? args]);
}

mixin DeleteByIdInStorageUseCase<T> {
  Future deleteInStorage(String id, [Map<String, dynamic>? params]);
}

mixin DeleteByIdInStorageUseCaseAdapter<T>
    implements DeleteByIdInStorageUseCase<T> {
  Repository get repository;

  @override
  Future deleteInStorage(String id, [Map<String, dynamic>? params]) {
    return (repository as DeleteByIdInStorageRepository<T>)
        .deleteInStorage(id, params);
  }
}
