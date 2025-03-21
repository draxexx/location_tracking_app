import 'package:hive/hive.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

class HiveLocalStorage<T> implements LocalStorageManager<T> {
  final Box<T> box;

  HiveLocalStorage(this.box);

  @override
  Future<void> add(String key, T value) async {
    await box.put(key, value);
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  @override
  T? get(String key) {
    return box.get(key);
  }

  @override
  List<T> getAll() {
    return box.values.toList();
  }

  @override
  Future<void> remove(String key) async {
    await box.delete(key);
  }
}
