import 'dart:async';
import 'dart:math';

import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/game_play_page.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ResultGamePage extends StatefulWidget {
  // const ResultGamePage({Key? key}) : super(key: key);
  late final LanguageModel? languageModel;
  late final int finalScore;
  late final LevelModel? level;

  ResultGamePage(this.languageModel, this.finalScore, this.level);
  @override
  _ResultGamePageState createState() => _ResultGamePageState();
}

class _ResultGamePageState extends State<ResultGamePage> {
  late ConfettiController _confettiController;
  late LanguageDBProvider? _languageDBProvider;
  bool isLoading = false;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  updateLevel() async {
    isLoading = true;
    _languageDBProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);
    try {
      if (widget.finalScore > widget.level!.current_score!.toDouble()) {
        if (await _languageDBProvider!
            .setUpdateLevelProgress(widget.finalScore, widget.level!.id)) {
          if (await _languageDBProvider!.updateNextLevel(widget.level)) {
            logger.d("berhasil update, coba cek di db");
          } else {
            logger.d(" berhasil update xp level, cek db ");
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateLevel();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    Timer(Duration(milliseconds: 800), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget textHeader() {
      return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Column(
              children: [
                Text(
                  '${widget.languageModel?.language_name}',
                  textAlign: TextAlign.center,
                  style:
                      whiteTextStyle.copyWith(fontSize: 32, fontWeight: bold),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  '${widget.level?.level_name}',
                  style:
                      whiteTextStyle.copyWith(fontSize: 23, fontWeight: bold),
                ),
              ],
            ),
          ));
    }

    Widget BacktoMenu() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ClickyButton(
            onPressed: isLoading
                ? () {}
                : () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
            color: alertColor,
            shadowColor: alertAccentColor,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Text(
              'KEMBALI KE MENU',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
            )),
      );
    }

    Widget scoreMatch() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor9,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            "+ ${widget.finalScore}",
            style: whiteTextStyle.copyWith(fontSize: 32, fontWeight: bold),
          ),
        ),
      );
    }

    Path drawStar(Size size) {
      double degToRad(double deg) => deg * (pi / 180.0);

      const numberOfPoints = 5;
      final halfWidth = size.width / 2;
      final externalRadius = halfWidth;
      final internalRadius = halfWidth / 2.5;
      final degreesPerStep = degToRad(360 / numberOfPoints);
      final halfDegreesPerStep = degreesPerStep / 2;
      final path = Path();
      final fullAngle = degToRad(360);
      path.moveTo(size.width, halfWidth);

      for (double step = 0; step < fullAngle; step += degreesPerStep) {
        path.lineTo(halfWidth + externalRadius * cos(step),
            halfWidth + externalRadius * sin(step));
        path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
            halfWidth + internalRadius * sin(step + halfDegreesPerStep));
      }
      path.close();
      return path;
    }

    Widget cardBody() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 80, left: 10, right: 10),
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            textHeader(),
            SizedBox(
              height: 8,
            ),
            Image.asset(
              'assets/images/trophy_2.png',
              width: 162.76,
              height: 162.76,
            ),
            scoreMatch(),
            SizedBox(
              height: 30,
            ),
            BacktoMenu()
          ],
        ),
      );
    }

    Widget confettiStar() {
      return ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality
            .explosive, // don't specify a direction, blast randomly
        shouldLoop: true, // start again as soon as the animation is finished
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ], // manually specify the colors to be used
        createParticlePath: drawStar, // define a custom shape/path.
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor2,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background_512w.png"),
                    fit: BoxFit.cover)),
          ),
          Container(
            child: Align(
              alignment: Alignment.center,
              child: cardBody(),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: confettiStar(),
          ),
        ],
      ),
    );
  }
}
