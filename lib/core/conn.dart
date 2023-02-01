import 'dart:convert';

import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:test2/core/static.dart';

import 'dataModel.dart';

final List successCode = [200, 201, 204, 205];

class ConnServ {
  var _client = http.Client();
  ConnServ();

  httpErrors(res) {
    int code = res.statusCode;
    print(' ttt httpErrors >>>>> $code');
  }

  // get(String url, Function callback) async {
  dynamic get({String url = '', Function? callback, int index = -1}) async {
    dev.log('>>> $url', name: 'HTTP GET. req');
    Uri uri = Uri.parse(url);
    var res = await _client.get(uri);
    int code = res.statusCode;

    if (!successCode.contains(code)) {
      httpErrors(res);
      return null;
    }
    String data = res.body;
    var jsonData = jsonDecode(data);
    // var getData = jsonData[0]['title'];
    // dev.log('>>> $index,  $code, $getData', name: 'HTTP GET. res');
    if (callback != null) callback(data);
    // return data;
    return jsonData;
  }

  //post
  post({String? pramas, String url = '', Function? callback}) async {
    dev.log('>>> $url', name: 'HTTP POST. req');

    try {
      Uri uri = Uri.parse(url);
      var headers = {
        'content-type': 'application/json',
        'Authorization': Member.token,
      };
      var res = await _client.post(
        uri,
        headers: headers,
        body: pramas,
      );
      int code = res.statusCode;
      dev.log('>>>  $code, ', name: 'HTTP POST. res');
      if (!successCode.contains(code)) {
        httpErrors(res);
        return null;
      }
      String data = res.body;
      var jsonData = jsonDecode(data);
      if (callback != null) callback();
      return jsonData;
    } catch (err) {
      // log('Add error, ', error: err);
      dev.log('>>> ', error: err, name: 'HTTP POST. errs');
      throw Exception(err);
    }
  }
}
