import 'dart:async';

import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    getInit();
    super.initState();
    Timer(Duration(seconds: 3), () => Navigator.pushNamed(context, '/home'));
  }

  getInit() async {
    LanguageDBProvider langProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);
    langProvider.init();
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
