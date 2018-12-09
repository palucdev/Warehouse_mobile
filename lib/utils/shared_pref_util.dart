import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const TOKEN_KEY = 'TOKEN';
  static const INIT_FLAG = 'INIT_FLAG';

  static Future<void> saveToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, value);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  static Future<void> setInitFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(INIT_FLAG, true);
  }

  static Future<bool> getInitFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().contains(INIT_FLAG)) {
      return prefs.getBool(INIT_FLAG);
    } else {
      return false;
    }
  }
}
