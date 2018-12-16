import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:warehouse_mobile/services/navigation_service.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class NetworkUtil {
  // making NetworkUtil a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  void _checkForTokenRefresh(http.Response response) async {
    String token = await SharedPreferencesUtil.getToken();
    if (token != null &&
        response.headers.containsKey('authorization') &&
        response.headers['authorization'] != token) {
      print('Access_token refreshed!');
      await SharedPreferencesUtil.saveToken(response.headers['authorization']);
    }
  }

  void _checkForUnauthorizedAttempt(http.Response response) {
    if (response.statusCode == 401) {
      new NavigationService().popToLogin();
    }
  }

  void _checkForConflictErrorCode(int statusCode, String res) {
    if (statusCode == 409) {
			throw res;
		} else if (statusCode < 200 || statusCode > 400) {
      throw new Exception("Error while fetching data: " + res);
    }
  }

  Future<dynamic> get(String url, Map headers) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _checkForUnauthorizedAttempt(response);
			_checkForConflictErrorCode(statusCode, res);
      _checkForTokenRefresh(response);

      return res;
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _checkForUnauthorizedAttempt(response);
			_checkForConflictErrorCode(statusCode, res);
      _checkForTokenRefresh(response);

      return res;
    });
  }

  Future<dynamic> patch(String url, {Map headers, body, encoding}) {
    return http
      .patch(url, body: body, headers: headers, encoding: encoding)
      .then((http.Response response){
      final String res = response.body;
      final int statusCode = response.statusCode;

      _checkForUnauthorizedAttempt(response);
			_checkForConflictErrorCode(statusCode, res);
      _checkForTokenRefresh(response);

      return res;
    });
  }

  Future<dynamic> delete(String url, Map headers) {
    return http
      .delete(url, headers: headers)
      .then((http.Response response){
      final String res = response.body;
      final int statusCode = response.statusCode;

      _checkForUnauthorizedAttempt(response);
			_checkForConflictErrorCode(statusCode, res);
      _checkForTokenRefresh(response);

      return res;
    });
  }
}
