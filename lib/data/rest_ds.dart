import 'dart:async';
import 'dart:convert';

import 'package:warehouse_mobile/model/product.dart';
import 'package:warehouse_mobile/model/user.dart';
import 'package:warehouse_mobile/utils/network_util.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  static const API_BASE = '/api/v1';
  static const APP_PORT = '2137';
  static const API_ENDPOINT = 'http://192.168.0.171';
  static const BASE_URL = API_ENDPOINT + ":" + APP_PORT + API_BASE;
  static const LOGIN_URL = BASE_URL + "/login";
  static const GOOGLE_LOGIN_URL = BASE_URL + "/auth/google";
  static const PRODUCT_URL = BASE_URL + "/product";


  Future<User> login(String email, String password) {
    print('RestDatasource | login | perfoming api call...');

    Map<String, String> body = {'email': email, 'password': password};

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
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
    }).catchError((error) {
			//some error popup
			print('Login error: ' + error.toString());
		});
  }

  Future<User> googleLogin(String accessToken, String idToken) {
    print('RestDatasource | googleLogin | perfoming api call...');

    Map<String, String> body = {'accessToken': accessToken, 'idToken': idToken};

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    return _netUtil
      .post(GOOGLE_LOGIN_URL, body: json.encode(body), headers: headers)
      .then((dynamic res) {
       var resMap = json.decode(res);

       print(resMap);

			 try {
				 return new User.fromJson(resMap);
			 } catch (e) {
				 throw Exception('Malformed response body');
			 }
    }).catchError((error) {
    	//some error popup
			print('Google login error: ' + error.toString());
		});
  }

  Future<List<Product>> getProducts() async {
    String token =
        await SharedPreferencesUtil.getToken();

    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
      'authorization': token
    };

    return _netUtil.get(PRODUCT_URL, headers).then((dynamic res) {
      Iterable resCollection = json.decode(res);
      return resCollection.map((obj) => Product.fromJson(obj)).toList();
    }).catchError((error) {
			//some error popup
			print('Get products error: ' + error.toString());
		});
  }
}
