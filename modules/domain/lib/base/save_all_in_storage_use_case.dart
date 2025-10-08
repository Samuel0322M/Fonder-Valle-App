import 'package:domain/base/repository.dart';

mixin SaveAllInStorageRepository<T> on Repository {
  Future<List<T>> saveAllInStorage(List<T> request,
      [Map? args, bool? useDebounce]);
}

mixin SaveAllInStorageUseCase<T> {
  Future<List<T>> saveAllInStorage(List<T> request,
      [Map? args, bool? useDebounce]);
}

mixin SaveAllInStorageUseCaseAdapter<T> implements SaveAllInStorageUseCase<T> {
  Repository get repository;

  @override
  Future<List<T>> saveAllInStorage(List<T> request,
      [Map? args, bool? useDebounce]) {
    return (repository as SaveAllInStorageRepository<T>).saveAllInStorage(
      request,
      args,
      useDebounce,
    );
  }
}
