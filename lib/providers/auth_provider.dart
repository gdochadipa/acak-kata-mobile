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
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
