import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NetworkHandler {
  // String baseurl =
  //     "http://192.168.0.104:5000"; // instead localhost add your ip address here
  String baseurl =
      "http://288d2434ccc5.ngrok.io"; // add your ngrok forwarding to connect to real device
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future get(String url) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    var response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    url = formater(url);
    log.d(body);
    var response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

  String formater(String url) {
    return baseurl + url;
  }
}
