import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class GameModePage extends StatefulWidget {
  const GameModePage({Key? key}) : super(key: key);

  @override
  State<GameModePage> createState() => _GameModePageState();
}

class _GameModePageState extends State<GameModePage> {
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

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
