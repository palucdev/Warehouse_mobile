import 'dart:async';
import 'dart:convert';

import 'package:warehouse_mobile/model/intent.dart';
import 'package:warehouse_mobile/model/product.dart';
import 'package:warehouse_mobile/model/sync_err_msg.dart';
import 'package:warehouse_mobile/model/user.dart';
import 'package:warehouse_mobile/utils/env_util.dart';
import 'package:warehouse_mobile/utils/network_util.dart';
import 'package:warehouse_mobile/utils/shared_pref_util.dart';

import 'package:device_id/device_id.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();

  // Main app API params
  static String API_BASE, APP_PORT, API_ENDPOINT;

  // API paths urls
  static String BASE_URL, LOGIN_URL, REGISTER_URL,
    GOOGLE_LOGIN_URL, PRODUCTS_URL;

  static const PRODUCTS_TO_UPDATE_KEY = "products_to_update";
  static const PRODUCTS_TO_ADD_KEY = "products_to_add";
  static const PRODUCTS_TO_REMOVE_KEY = "products_to_remove";

  RestDatasource() {
    API_ENDPOINT = 'http://' + EnvironmentUtil.getEnvValueForKey('API_ENDPOINT');
    API_BASE = EnvironmentUtil.getEnvValueForKey('API_BASE');
    APP_PORT = EnvironmentUtil.getEnvValueForKey('APP_PORT');

    BASE_URL = API_ENDPOINT + ":" + APP_PORT + API_BASE;
    LOGIN_URL = BASE_URL + "/login";
    REGISTER_URL = BASE_URL + "/user";
    GOOGLE_LOGIN_URL = BASE_URL + "/auth/google";
    PRODUCTS_URL = BASE_URL + "/products";

    print('Api endpoint: ' + API_ENDPOINT.toString());
  }

  Future<Map<String, String>> _getHeaders(
      {bool auth, bool withDeviceId}) async {
    Map<String, String> headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };

    if (auth) {
      headers['authorization'] = await SharedPreferencesUtil.getToken();
    }

    if (withDeviceId) {
      headers['device_id'] = await DeviceId.getID;
    }

    return headers;
  }

  Future<User> login(String email, String password) async {
    print('RestDatasource | login | perfoming api call...');

    Map<String, String> body = {'email': email, 'password': password};

    var headers = await _getHeaders(auth: false, withDeviceId: false);

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

  Future<User> register(
      String email, String password, String name, num role) async {
    Map<String, String> body = {
      'email': email,
      'password': password,
      'name': name,
      'role': role.toString(),
      'accType': 0.toString()
    };

    var headers = await _getHeaders(auth: false, withDeviceId: false);

    return _netUtil
        .post(REGISTER_URL, body: json.encode(body), headers: headers)
        .then((dynamic res) {
      var resMap = json.decode(res);

      try {
        return new User.fromJson(resMap);
      } catch (e) {
        throw Exception('Malformed response body');
      }
    }).catchError((error) {
      //some error popup
      print('Register error: ' + error.toString());
    });
  }

  Future<User> googleLogin(String accessToken, String idToken) async {
    print('RestDatasource | googleLogin | perfoming api call...');

    Map<String, String> body = {'accessToken': accessToken, 'idToken': idToken};

    var headers = await _getHeaders(auth: false, withDeviceId: false);

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
    var headers = await _getHeaders(auth: true, withDeviceId: true);

    return _netUtil.get(PRODUCTS_URL, headers).then((dynamic res) {
      Iterable resCollection = json.decode(res);
      return resCollection.map((obj) => Product.fromJson(obj)).toList();
    }).catchError((error) {
      //some error popup
      print('Get products error: ' + error.toString());
    });
  }

  Future<List<Product>> updateProducts(List<Product> products) async {
    var headers = await _getHeaders(auth: true, withDeviceId: true);

    List<Map> rawProductsToUpdate = [];
    List<Map> rawProductsToAdd = [];
    List<Map> rawProductsToRemove = [];

    products.forEach((product) {
      print(product.intent.toString());
      switch (product.intent) {
        case Intent.UPDATE:
          rawProductsToUpdate.add(product.toMap());
          break;
        case Intent.INSERT:
          rawProductsToAdd.add(product.toMap());
          break;
        case Intent.REMOVE:
          rawProductsToRemove.add(product.toMap());
          break;
      }
    });

    var body = {
      PRODUCTS_TO_UPDATE_KEY: rawProductsToUpdate,
      PRODUCTS_TO_ADD_KEY: rawProductsToAdd,
      PRODUCTS_TO_REMOVE_KEY: rawProductsToRemove
    };

    return _netUtil
        .patch(PRODUCTS_URL, body: json.encode(body), headers: headers)
        .then((dynamic res) {
      Iterable resCollection = json.decode(res);
      return resCollection.map((obj) => Product.fromJson(obj)).toList();
    }).catchError((dynamic errors) {
      Iterable errCollection = json.decode(errors);
      throw errCollection
          .map((err) => SyncErrorMessage.fromJson(err))
          .toList();
    });
  }

  Future<Product> getProduct(String productID) async {
    var headers = await _getHeaders(auth: true, withDeviceId: true);

    var url = PRODUCTS_URL + '/' + productID;

    return _netUtil.get(url, headers).then((dynamic res) {
      var resObj = json.decode(res);

      return Product.fromJson(resObj);
    });
  }

  Future<void> removeProduct(String productID) async {
    var headers = await _getHeaders(auth: true, withDeviceId: true);

    var url = PRODUCTS_URL + '/' + productID;

    return _netUtil.delete(url, headers);
  }

  Future<int> changeProductItems(Product product) async {
    var headers = await _getHeaders(auth: true, withDeviceId: true);

    var quantity = product.localQuantity;

    var url = PRODUCTS_URL + '/' + product.id;

    var body = {Product.QUANTITY_KEY: quantity.toString()};

    return _netUtil
        .patch(url, body: json.encode(body), headers: headers)
        .then((dynamic res) {
      var resObj = json.decode(res);

      return int.parse(resObj[Product.QUANTITY_KEY].toString());
    }).catchError((dynamic err) {
      Map<dynamic, dynamic> errObj = json.decode(err);
      var syncErrMsg = new SyncErrorMessage.fromJson(errObj);
      throw syncErrMsg;
    });
  }

  Future<Product> addProduct(Product product) async {
    var headers = await _getHeaders(auth: true, withDeviceId: true);

    var body = product.toMap();

    return _netUtil
        .post(PRODUCTS_URL, body: json.encode(body), headers: headers)
        .then((dynamic res) {
      var productObj = json.decode(res);

      return Product.fromJson(productObj);
    }).catchError((dynamic err) {
      return err;
    });
  }
}
