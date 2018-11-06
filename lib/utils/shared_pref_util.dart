import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
	static const TOKEN_KEY = 'TOKEN';

	static Future<void> saveToken(String value) async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		await prefs.setString(TOKEN_KEY, value);
	}

	static Future<String> getToken() async {
		SharedPreferences prefs = await SharedPreferences.getInstance();
		return prefs.getString(TOKEN_KEY);
	}
}