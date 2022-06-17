import 'dart:async';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/theme.dart';
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
    Timer(const Duration(milliseconds: 500), () {
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
    ChangeLanguageProvider changeLanguageProvider =
        Provider.of<ChangeLanguageProvider>(context, listen: false);
    LanguageDBProvider langProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);

    String? localLang = prefs.getString("choiceLang") ?? 'id';
    setState(() {
      changeLanguageProvider.changeLocale(localLang);
    });

    bool login = prefs.getBool('login') ?? false;
    bool isInGame = prefs.getBool('is_in_game') ?? false;

    try {
      await langProvider.init();
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
      await langProvider.getRangeText();
      Timer(const Duration(milliseconds: 1500), () {
        Navigator.pushNamed(context, '/home');
        // Navigator.push(context, CustomPageRoute(ExamplePage()));
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
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  repeat: ImageRepeat.repeat)),
        ),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticInOut,
            width: _width,
            height: _height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo_baru_no.png'))),
          ),
        )
      ]),
    );
  }
}
