import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.dart';

class AppPreferencesIMPL implements AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferencesIMPL(this._sharedPreferences);

  @override
  bool? getBool(String key) {
    try {
      return _sharedPreferences.getBool(key);
    } catch (e) {
      log("Unable to get $key bool value \n$e");
      return false;
    }
  }

  @override
  double? getDouble(String key) {
    try {
      return _sharedPreferences.getDouble(key);
    } catch (e) {
      log("Unable to get $key double value \n$e");
      return 0.00;
    }
  }

  @override
  int? getInt(String key) {
    try {
      return _sharedPreferences.getInt(key);
    } catch (e) {
      log("Unable to get $key int value \n$e");
      return 0;
    }
  }

  @override
  String getString(String key) {
    try {
      return _sharedPreferences.getString(key) ?? "";
    } catch (e) {
      log("Unable to get $key string value \n$e");
      return "";
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      return await _sharedPreferences.remove(key);
    } catch (e) {
      log("Unable to remove $key \n$e");
      rethrow;
    }
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _sharedPreferences.setBool(key, value);
    } catch (e) {
      log("Unable to set $key \n$e");
      rethrow;
    }
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _sharedPreferences.setDouble(key, value);
    } catch (e) {
      log("Unable to set $key \n$e");
      rethrow;
    }
  }

  @override
  Future<bool> setInt(String key, int value) async {
    try {
      return await _sharedPreferences.setInt(key, value);
    } catch (e) {
      log("Unable to set $key \n$e");
      rethrow;
    }
  }

  @override
  Future<bool> setString(String key, String value) async {
    try {
      return await _sharedPreferences.setString(key, value);
    } catch (e) {
      log("Unable to set $key \n$e");
      rethrow;
    }
  }

  @override
  Future<bool> clearAllPreferences() async {
    try {
      return await _sharedPreferences.clear();
    } catch (e) {
      log("Unable to clear all data \n$e");
      rethrow;
    }
  }
}
