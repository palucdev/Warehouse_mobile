import 'dart:async';
import 'dart:convert';

import 'package:warehouse_mobile/model/product.dart';
import 'package:warehouse_mobile/model/user.dart';
import 'package:warehouse_mobile/utils/network_util.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  static final API_BASE = '/api/v1';
  static final APP_PORT = '2137';
  static final API_ENDPOINT = 'http://192.168.0.102';
  static final BASE_URL = API_ENDPOINT + ":" + APP_PORT + API_BASE;
  static final LOGIN_URL = BASE_URL + "/login";
  static final GOOGLE_LOGIN_URL = BASE_URL + "/auth/google";
  static final PRODUCT_URL = BASE_URL + "/product";
  static final TOKEN_KEY = 'TOKEN';

  Future<User> login(String email, String password) {
    print('RestDatasource | login | perfoming api call...');

    Map<String, String> body = {'email': email, 'password': password};

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return _netUtil
        .post(LOGIN_URL, body: json.encode(body), headers: headers)
        .then((dynamic res) {
      var resMap = json.decode(res);

      try {
        return new User.fromJson(resMap);
      } catch (e) {
        throw Exception('Malformed response body');
      }
    });
  }

  Future<User> googleLogin(String accessToken, String idToken) {
    print('RestDatasource | googleLogin | perfoming api call...');

    Map<String, String> body = {'accessToken': accessToken, 'idToken': idToken};

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    return _netUtil
      .post(GOOGLE_LOGIN_URL, body: json.encode(body), headers: headers)
      .then((dynamic res) {
       var resMap = json.decode(res);

			 try {
				 return new User.fromJson(resMap);
			 } catch (e) {
				 throw Exception('Malformed response body');
			 }
    });
  }

  Future<List<Product>> getProducts() async {
    String token =
        await SharedPreferencesUtil.getStringValue(RestDatasource.TOKEN_KEY);

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token
    };

    return _netUtil.get(PRODUCT_URL, headers).then((dynamic res) {
      Iterable resCollection = json.decode(res);
      return resCollection.map((obj) => Product.fromJson(obj)).toList();
    });
  }
}
