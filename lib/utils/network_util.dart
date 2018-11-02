import 'dart:async';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // making NetworkUtil a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  Future<dynamic> get(String url, Map headers) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      return res;
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) {
    print('Performin http post with params:');
    print('url: ' + url);
    print('headers: ' + headers.toString());
    print('body: ' + body.toString());
    print('encoding: ' + encoding.toString());
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      return res;
    });
  }
}
