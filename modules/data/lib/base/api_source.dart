mixin ApiSource {}

mixin GetAllApiSource<T> on ApiSource {
  Future<List<T>> getAll([Map? args]);
}

mixin GetByIdApiSource<T> on ApiSource {
  Future<T?> getById(String id, [Map? args]);
}

mixin DeleteByIdApiSource<T> on ApiSource {
  Future<void> delete(String id, [Map? args]);
}

mixin PostApiSource<T, R> on ApiSource {
  Future<T> post(R request, [Map? args]);
}

mixin GetApiSource<T> on ApiSource {
  Future<T?> get([Map? args]);
}

mixin PutApiSource<T, R> on ApiSource {
  Future<T> put(R request, [Map? args]);
}

mixin CancelRequestApiSource on ApiSource {
  void cancelRequest();
}

mixin CancelRequestByIdApiSource on ApiSource {
  void cancelRequest(String id);
}
