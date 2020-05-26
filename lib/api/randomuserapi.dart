import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomUserAPI {
  final String api = 'https://randomuser.me/api/?results=20';

  Future<List> fetchUsers() async {
    try {
      http.Response response = await http.get(api);

      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      }
      
      debugPrint(json.encode(response.body));
      throw json.encode(response.body);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}