abstract class LocalStorageManager<T> {
  Future<void> add(String key, T value);
  T? get(String key);
  List<T> getAll();
  Future<void> remove(String key);
  Future<void> clear();
}
