import 'dart:async';
import 'dart:math';

import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/in_game/game_play_page.dart';
import 'package:acakkata/theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ResultGamePage extends StatefulWidget {
  // const ResultGamePage({Key? key}) : super(key: key);
  late final LanguageModel? languageModel;
  late final int finalScore;

  ResultGamePage(this.languageModel, this.finalScore);
  @override
  _ResultGamePageState createState() => _ResultGamePageState();
}

class _ResultGamePageState extends State<ResultGamePage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
    _confettiController.play();
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
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: backgroundColor4, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Column(
              children: [
                Text(
                  '${widget.languageModel?.language_name}',
                  style: blackTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
              ],
            ),
          ));
    }

    Widget BacktoMenu() {
      return Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(top: 15),
        child: TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            style: TextButton.styleFrom(
                backgroundColor: alertColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Back to Menu',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            )),
      );
    }

    Widget scoreMatch() {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Skor Permainan",
              style:
                  subtitleTextStyle.copyWith(fontSize: 14, fontWeight: regular),
            ),
            Text(
              "${widget.finalScore}",
              style:
                  blackTextStyle.copyWith(fontSize: 36, fontWeight: semiBold),
            ),
          ],
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
        margin:
            EdgeInsets.only(top: 70, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor1, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            textHeader(),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/trophy.png',
              width: 140,
              height: 167,
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
      return Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
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
        ),
      );
    }

    return Scaffold(
        backgroundColor: backgroundColor2,
        body: Container(
          child: SafeArea(
              child: Stack(
            children: [
              ListView(
                children: [
                  cardBody(),
                ],
              ),
              confettiStar(),
            ],
          )),
        ));
  }
}
