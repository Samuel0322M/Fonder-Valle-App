import 'package:domain/base/repository.dart';

mixin CancelRequestRepository on Repository {
  void cancelRequest();
}

mixin CancelRequestUseCase {
  void cancelRequest();
}

mixin CancelRequestUseCaseAdapter<T> implements CancelRequestUseCase {
  Repository get repository;

  @override
  void cancelRequest() {
    return (repository as CancelRequestRepository).cancelRequest();
  }
}
