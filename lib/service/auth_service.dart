import 'dart:convert';

import 'package:acakkata/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/auth';

  Future<UserModel> register(
      {required String name,
      required String email,
      required String password}) async {
    var url = Uri.parse('$baseUrl/signup');
    print(url);
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': name,
      'email': email,
      'password': password,
    });

    var response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel user = UserModel.fromJson(data['data']);
      user.token = 'Bearer ' + data['token'];
      return user;
    } else {
      if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        throw Exception(data['message']);
      } else {
        throw Exception("Gagal Login");
      }
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/signin');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel user = UserModel.fromJson(data['data']);
      user.token = 'Bearer ' + data['token'];
      return user;
    } else {
      if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        throw Exception(data['message']);
      } else {
        throw Exception("Gagal Login");
      }
    }
  }
}
