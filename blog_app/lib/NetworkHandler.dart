import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl =
      "http://192.168.0.104:5000"; // instead localhost add your ip address here
  var log = Logger();

  Future get(String url) async {
    url = formater(url);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formater(url);
    var response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response);
      return response;
    }
    log.d(response.body);
    log.d(response.statusCode);
  }

  String formater(String url) {
    return baseurl + url;
  }
}
