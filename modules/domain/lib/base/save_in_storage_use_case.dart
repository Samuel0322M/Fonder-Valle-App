import 'package:domain/base/repository.dart';

mixin SaveInStorageRepository<T> on Repository {
  Future<T> saveInStorage(T request, [Map? args, bool? useDebounce]);
}

mixin SaveInStorageUseCase<T> {
  Future<T> saveInStorage(T request, [Map? args, bool? useDebounce]);
}

mixin SaveInStorageUseCaseAdapter<T> implements SaveInStorageUseCase<T> {
  Repository get repository;

  @override
  Future<T> saveInStorage(T request, [Map? args, bool? useDebounce]) {
    return (repository as SaveInStorageRepository<T>).saveInStorage(
      request,
      args,
      useDebounce,
    );
  }
}
