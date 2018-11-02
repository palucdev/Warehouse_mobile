import 'dart:async';
import 'dart:convert';

import 'package:warehouse_mobile/model/user.dart';
import 'package:warehouse_mobile/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  static final API_BASE = '/api/v1';
  static final APP_PORT = '2137';
  static final API_ENDPOINT = '<YOUR BACKEND ADDRESS>';
  static final BASE_URL = API_ENDPOINT + ":" + APP_PORT + API_BASE;
  static final LOGIN_URL = BASE_URL + "/login";
  static final _API_KEY = null;

  Future<User> login(String email, String password) {
    print('RestDatasource | login | perfoming api call...');

    Map<String, String> body = {
      'email': email,
      'password': password
    };

    Map<String, String> headers = {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    };

    return _netUtil.post(LOGIN_URL, body: json.encode(body), headers: headers)
      .then((dynamic res) {
        var resMap = json.decode(res);

        try {
          return new User.fromJson(resMap);
        } catch(e) {
          throw Exception('Malformed response body');
        }
    });
  }
}
