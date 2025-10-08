import 'package:domain/base/repository.dart';

mixin SimpleSaveInStorageRepository<T> on Repository {
  Future<void> saveInStorage(T request, [Map? args]);
}

mixin SimpleSaveInStorageUseCase<T> {
  Future<void> saveInStorage(T request, [Map? args]);
}

mixin SimpleSaveInStorageUseCaseAdapter<T> implements SimpleSaveInStorageUseCase<T> {
  Repository get repository;

  @override
  Future<void> saveInStorage(T request, [Map? args]) {
    return (repository as SimpleSaveInStorageRepository<T>)
        .saveInStorage(request, args);
  }
}
