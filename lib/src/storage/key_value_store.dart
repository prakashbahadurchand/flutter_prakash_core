import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight typed key-value storage abstraction over [SharedPreferences].
class KeyValueStore {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> ensureInitialized() async {
    if (_prefs == null) await init();
  }

  Future<void> setString(String key, String value) async {
    await ensureInitialized();
    await _prefs!.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await ensureInitialized();
    return _prefs!.getString(key);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await ensureInitialized();
    await _prefs!.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    await ensureInitialized();
    return _prefs!.getStringList(key);
  }

  Future<void> setBool(String key, bool value) async {
    await ensureInitialized();
    await _prefs!.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await ensureInitialized();
    return _prefs!.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await ensureInitialized();
    await _prefs!.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    await ensureInitialized();
    return _prefs!.getInt(key);
  }

  Future<void> remove(String key) async {
    await ensureInitialized();
    await _prefs!.remove(key);
  }

  Future<void> clearAll() async {
    await ensureInitialized();
    await _prefs!.clear();
  }
}
