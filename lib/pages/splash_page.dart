import 'dart:async';

import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  // const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    getInit();
    super.initState();
    // Timer(Duration(seconds: 3), () => Navigator.pushNamed(context, '/home'));
  }

  getInit() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool login = prefs.getBool('login') ?? false;
    bool isInGame = prefs.getBool('is_in_game') ?? false;

    if (login) {
      UserModel _user = UserModel(
          id: prefs.getString('id'),
          name: prefs.getString('name'),
          email: prefs.getString('email'),
          username: prefs.getString('username'),
          userCode: prefs.getString('userCode'),
          token: prefs.getString('token'));
      authProvider.user = _user;
      await languageProvider.getLanguages();
      Navigator.pushNamed(context, '/home');
    } else {
      await languageProvider.getLanguages();
      Navigator.pushNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Center(
        child: Container(
          width: 130,
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/icon_game.jpg'))),
        ),
      ),
    );
  }
}
