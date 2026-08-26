import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class BasePrefs {
  static SharedPreferences? _prefs;

  static SharedPreferences get prefs {
    final instance = _prefs;
    if (instance == null) {
      throw StateError(
        'BasePrefs has not been initialized. Call `await BasePrefs.init()` during app bootstrap.',
      );
    }
    return instance;
  }

  static SharedPreferences get instance => prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

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
    final value = prefs.get(key);
    return value != null ? value as T : defaultValue;
  }

  static Future<void> _setValue<T>(String key, T value) async {
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception('Unsupported value type: $T');
    }
  }

  static T? getEnum<T>(String key, List<T> values, T defaultValue) {
    final index = prefs.getInt(key);
    if (index == null || index == -1 || index > values.length - 1) {
      return defaultValue;
    } else {
      return values[index];
    }
  }

  static Future<void> setEnum<T>(String key, T value, List<T> values) async {
    final index = values.indexOf(value);
    await prefs.setInt(key, index);
  }

  // Model Class Get And Save

  static T? getJson<T>({
    required String key,
    required T Function(dynamic) fromJson,
  }) {
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  static Future<void> setJson<T>(String key, T value) async {
    final jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }

  // Clear All Prefs Data

  static Future<bool> removeKey(String key) async => prefs.remove(key);

  static Future<bool> clearAllPrefs() async => prefs.clear();

  ///=================
  /// Other Utility Functions:
  ///=================

  // Calculate number of items
  static int getItemCount() => prefs.getKeys().length;

  // Calculate size allocated in bytes
  static int getAllocatedSize() {
    var totalSize = 0;
    for (final key in prefs.getKeys()) {
      final value = prefs.get(key);
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
  static bool containsKey(String key) => prefs.containsKey(key);

  // Get all keys
  static Set<String> getAllKeys() => prefs.getKeys();

  // Get all values
  static Map<String, dynamic> getAllValues() {
    final values = <String, dynamic>{};
    for (final key in prefs.getKeys()) {
      values[key] = prefs.get(key);
    }
    return values;
  }

  // Get key type
  static String getKeyType(String key) {
    final value = prefs.get(key);
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
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(key, List<String>.from(value));
      }
    }
  }
}
