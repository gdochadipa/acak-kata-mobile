import 'dart:io';

import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/service/auth_service.dart';
import 'package:acakkata/setting/persistence/setting_persistence.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  ValueNotifier<String> baseUrl = ValueNotifier("");

  final SettingsPersistence _persistence;

  AuthProvider({required SettingsPersistence persistence})
      : _persistence = persistence;

  Future<void> loadStateFromPersistence() async {
    _persistence.getServerUrl().then((value) => baseUrl.value = value);
  }

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserModel user = await AuthService(serverUrl: baseUrl.value)
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
      UserModel user = await AuthService(serverUrl: baseUrl.value)
          .login(email: email, password: password);
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

  Future<bool> logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('login', false);
      return true;
    } catch (e) {
      // print(e);
      throw Exception(e);
    }
  }

  Future<bool> updateProfile(
      {required String? email,
      required String? username,
      required String? name}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      String? id = pref.getString('id');
      UserModel user = await AuthService(serverUrl: baseUrl.value).editProfile(
          id: id!,
          email: email!,
          username: username!,
          name: name!,
          token: token!);
      _user = user;
      pref.setString('name', '${user.name}');
      pref.setString('email', '${user.email}');
      pref.setString('username', '${user.username}');
      return true;
    } catch (e) {
      // print(e);
      throw Exception(e);
    }
  }

  Future<bool> hasNetwork() async {
    // try {
    //   final result = await InternetAddress.lookup("www.google.com");
    //   return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    // } catch (e) {
    //   return false;
    // }
    return true;
  }
}
