import 'package:hive/hive.dart';
import 'package:location_tracking_app/utils/helpers/log_helper.dart';
import 'package:location_tracking_app/services/local_storage/local_storage_manager.dart';

class HiveLocalStorage<T> implements LocalStorageManager<T> {
  final Box<T> box;

  HiveLocalStorage(this.box);

  @override
  Future<void> add(String key, T value) async {
    try {
      await box.put(key, value);
      LogHelper.info("$key added to the box, value: $value");
    } catch (e) {
      LogHelper.error("Error while adding to the box: $e");
    }
  }

  @override
  Future<void> clear() async {
    try {
      await box.clear();
      LogHelper.info("Box cleared");
    } catch (e) {
      LogHelper.error("Error while clearing the box: $e");
    }
  }

  @override
  Future<T?> get(String key) async {
    try {
      return box.get(key);
    } catch (e) {
      LogHelper.error("Error while getting from the box: $e");
      return null;
    }
  }

  @override
  Future<List<T>> getAll() async {
    try {
      return box.values.toList();
    } catch (e) {
      LogHelper.error("Error while getting all from the box: $e");
      return [];
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await box.delete(key);
      LogHelper.info("$key removed from the box");
    } catch (e) {
      LogHelper.error("Error while removing from the box: $e");
    }
  }
}
