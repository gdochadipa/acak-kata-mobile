import 'dart:developer';

import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/service/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserModel user = await AuthService()
          .register(name: name, email: email, password: password);
      _user = user;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('login', true);
      pref.setString('id', '${user.id}');
      pref.setString('name', user.name ?? '');
      pref.setString('email', '${user.email}');
      pref.setString('username', '${user.username}');
      pref.setString('userCode', '${user.userCode}');
      pref.setString('token', '${user.token}');

      return true;
    } catch (e) {
      throw Exception(e);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      UserModel user =
          await AuthService().login(email: email, password: password);
      _user = user;
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('login', true);
      pref.setString('id', '${user.id}');
      pref.setString('name', user.name ?? '');
      pref.setString('email', '${user.email}');
      pref.setString('username', '${user.username}');
      pref.setString('userCode', '${user.userCode}');
      pref.setString('token', '${user.token}');
      return true;
    } catch (e) {
      // print(e);
      throw Exception(e);
      return false;
    }
  }
}
