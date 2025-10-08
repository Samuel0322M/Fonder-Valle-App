import 'package:domain/base/repository.dart';

mixin CancelRequestByIdRepository on Repository {
  void cancelRequest(String id);
}

mixin CancelRequesByIdUseCase {
  void cancelRequest(String id);
}

mixin CancelRequestByIdUseCaseAdapter<T> implements CancelRequesByIdUseCase {
  Repository get repository;

  @override
  void cancelRequest(String id) {
    return (repository as CancelRequestByIdRepository).cancelRequest(id);
  }
}
