import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class BasePrefs {
  static late SharedPreferences _prefs;

  static SharedPreferences get prefs => _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance => _prefs;

  static T? getOrSet<T>(String key, T? value, T defaultValue) {
    if (value != null) {
      unawaited(_setValue(key, value));
      return value;
    }
    return _getValue(key, defaultValue: defaultValue);
  }

  static T? getOrSetEnum<T>(
    String key,
    T? value,
    List<T> values,
    T defaultValue,
  ) {
    if (value == null) {
      // Get Enum
      return getEnum(key, values, defaultValue);
    } else {
      // Set Enum
      unawaited(setEnum(key, value, values));
      return null;
    }
    /*final existingValue = getEnum<T>(key, values);
    if (existingValue != null) {
      return existingValue;
    } else {
      setEnum(key, defaultValue, values);
      return defaultValue;
    }*/
  }

  static T? getOrSetModel<T>(
    String key,
    T? value,
    T Function(dynamic) fromJson,
  ) {
    if (value != null) {
      unawaited(setJson(key, value));
      return value;
    }
    return getJson(key: key, fromJson: fromJson);
  }

  static T? _getValue<T>(String key, {T? defaultValue}) {
    final value = _prefs.get(key);
    return value != null ? value as T : defaultValue;
  }

  static Future<void> _setValue<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported value type: $T');
    }
  }

  static T? getEnum<T>(String key, List<T> values, T defaultValue) {
    final index = _prefs.getInt(key);
    if (index == null || index == -1 || index > values.length - 1) {
      return defaultValue;
    } else {
      return values[index];
    }
  }

  static Future<void> setEnum<T>(String key, T value, List<T> values) async {
    final index = values.indexOf(value);
    await _prefs.setInt(key, index);
  }

  // Model Class Get And Save

  static T? getJson<T>({
    required String key,
    required T Function(dynamic) fromJson,
  }) {
    final jsonString = _prefs.getString(key);
    if (jsonString != null) {
      return fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  static Future<void> setJson<T>(String key, T value) async {
    final jsonString = jsonEncode(value);
    await _prefs.setString(key, jsonString);
  }

  // Clear All Prefs Data

  static Future<bool> removeKey(String key) async => _prefs.remove(key);

  static Future<bool> clearAllPrefs() async => _prefs.clear();

  ///=================
  /// Other Utility Functions:
  ///=================

  // Calculate number of items
  static int getItemCount() => _prefs.getKeys().length;

  // Calculate size allocated in bytes
  static int getAllocatedSize() {
    var totalSize = 0;
    for (final key in _prefs.getKeys()) {
      final value = _prefs.get(key);
      if (value is String) {
        totalSize += value.length;
      } else if (value is int) {
        totalSize += 8; // Size of int in bytes
      } else if (value is double) {
        totalSize += 8; // Size of double in bytes
      } else if (value is bool) {
        totalSize += 1; // Size of bool in bytes
      } else if (value is List<String>) {
        for (final item in value) {
          totalSize += item.length;
        }
      }
    }
    return totalSize;
  }

  // Check if key exists
  static bool containsKey(String key) => _prefs.containsKey(key);

  // Get all keys
  static Set<String> getAllKeys() => _prefs.getKeys();

  // Get all values
  static Map<String, dynamic> getAllValues() {
    final values = <String, dynamic>{};
    for (final key in _prefs.getKeys()) {
      values[key] = _prefs.get(key);
    }
    return values;
  }

  // Get key type
  static String getKeyType(String key) {
    final value = _prefs.get(key);
    if (value is String) {
      return 'String';
    } else if (value is int) {
      return 'int';
    } else if (value is double) {
      return 'double';
    } else if (value is bool) {
      return 'bool';
    } else if (value is List<String>) {
      return 'List<String>';
    } else {
      return 'Unknown';
    }
  }

  // Export preferences to JSON
  static String exportPrefsToJson() {
    final values = getAllValues();
    return jsonEncode(values);
  }

  // Import preferences from JSON
  static Future<void> importPrefsFromJson(String jsonString) async {
    final values = jsonDecode(jsonString) as Map<String, dynamic>;
    for (final key in values.keys) {
      final value = values[key];
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, List<String>.from(value));
      }
    }
  }
}
