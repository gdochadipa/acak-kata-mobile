import 'dart:async';
import 'dart:io';

import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/pages/example/example.dart';
import 'package:acakkata/pages/home_page/main.dart';
import 'package:acakkata/pages/home_page/new_home_page.dart';
import 'package:acakkata/pages/result_game/result_game_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/custom_page_route_bounce.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  // const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  double _width = 80;
  double _height = 60;

  @override
  void initState() {
    // TODO: implement initState
    getInit();
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _width = 200;
        _height = 170;
      });
    });
    // Timer(Duration(seconds: 3), () => Navigator.pushNamed(context, '/home'));
  }

  getInit() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    LanguageProvider languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    LanguageDBProvider langProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);
    await langProvider.init();

    bool login = prefs.getBool('login') ?? false;
    bool isInGame = prefs.getBool('is_in_game') ?? false;

    try {
      if (login) {
        UserModel _user = UserModel(
            id: prefs.getString('id'),
            name: prefs.getString('name'),
            email: prefs.getString('email'),
            username: prefs.getString('username'),
            userCode: prefs.getString('userCode'),
            token: prefs.getString('token'));
        authProvider.user = _user;
        // await languageProvider.getLanguages();
        // await langProvider.getLanguage();
        // Navigator.pushNamed(context, '/home');
      }
      // else {
      //   // await languageProvider.getLanguages();
      //   await langProvider.getLanguage();
      //   Navigator.pushNamed(context, '/sign-in');
      // }

      await langProvider.getLanguage();
      Timer(Duration(milliseconds: 1500), () {
        // Navigator.pushNamed(context, '/home');
        Navigator.push(context, CustomPageRoute(ExamplePage()));
      });
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background_512w.png"),
                  fit: BoxFit.cover)),
        ),
        Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.elasticInOut,
            width: _width,
            height: _height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo_putih.png'))),
          ),
        )
      ]),
    );
  }
}
