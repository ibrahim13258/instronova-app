import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  StorageHelper._privateConstructor();
  static final StorageHelper instance = StorageHelper._privateConstructor();

  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save String value
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  /// Get String value
  String? getString(String key) {
    return _prefs?.getString(key);
  }

  /// Save Int value
  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  /// Get Int value
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  /// Save Bool value
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  /// Get Bool value
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  /// Remove a key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Clear all keys
  Future<void> clear() async {
    await _prefs?.clear();
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }
}
