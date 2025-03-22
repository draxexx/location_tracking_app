abstract class LocalStorageManager<T> {
  Future<void> add(String key, T value);
  Future<T?> get(String key);
  Future<List<T>> getAll();
  Future<void> remove(String key);
  Future<void> clear();
}
