import 'package:models/database_object.dart';

mixin DbSource {}

mixin StreamAllDbSource<T> on DbSource {
  Stream<List<T>> streamAll([Map? args]);
}

mixin PutAllDbSource<T extends DatabaseObject> on DbSource {
  Future<List<T>> putAll(
    List<T> items, {
    bool delete = true,
    Map? args,
    bool? useDebounce,
  });
}
mixin PutDbSource<T extends DatabaseObject> on DbSource {
  Future<T> put(T item, [Map? args, bool? useDebounce]);
}

mixin DeleteByIdDbSource<T extends DatabaseObject> on DbSource {
  Future<void> deleteById(String id, [Map? args]);
}

mixin DeleteAllDbSource<T extends DatabaseObject> on DbSource {
  Future<void> deleteAll([Map? args]);
}

mixin SimplePutDbSource<T extends DatabaseObject> on DbSource {
  Future<void> put(T item, [Map? args]);
}

mixin SimpleStreamDbSource<T> on DbSource {
  Stream<T?> stream([Map? args]);
}

mixin StreamByIdDbSource<T> on DbSource {
  Stream<T?> streamById(String id, [Map? args]);
}

mixin ContaintsDbSource<bool> on DbSource {
  Stream<bool> containts(String id, [Map? args]);
}

mixin DisposeDbSource on DbSource {
  Future<void> dispose();
}
