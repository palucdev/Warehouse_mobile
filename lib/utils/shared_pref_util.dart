import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
	static Future<void> saveString(String key, String value) async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		await prefs.setString(key, value);
	}

	static Future<String> getStringValue(String key) async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return prefs.getString(key);
	}
}