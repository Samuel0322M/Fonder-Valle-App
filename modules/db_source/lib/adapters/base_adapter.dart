// File: tu_aliado/packages/db_source/lib/adapters/base_adapter.dart
import 'package:hive/hive.dart';

abstract class BaseAdapter<T> {
  String get boxName;

  Future<Box<T>> _openBox() async {
    return await Hive.openBox<T>(boxName);
  }

  Future<void> save(String key, T value) async {
    final box = await _openBox();
    await box.put(key, value);
  }

  Future<T?> get(String key) async {
    final box = await _openBox();
    return box.get(key);
  }

  Future<void> delete(String key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  Future<List<T>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }
}
