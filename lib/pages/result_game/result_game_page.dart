import 'dart:async';
import 'dart:math';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/range_result_txt_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ResultGamePage extends StatefulWidget {
  // const ResultGamePage({Key? key}) : super(key: key);
  late final LanguageModel? languageModel;
  late final double finalTimeRate;
  late final double finalScoreRate;
  late final LevelModel? level;
  late final bool? isCustom;

  ResultGamePage(this.languageModel, this.finalTimeRate, this.finalScoreRate,
      this.level, this.isCustom);
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

    // logger.d(widget.finalScoreRate);
    // logger.d(widget.finalTimeRate);
    int finalScore =
        ((widget.finalScoreRate + widget.finalTimeRate) * 100).round();
    try {
      /// !bug
      if (widget.isCustom == false) {
        if (finalScore > widget.level!.current_score!.toInt()) {
          if (await _languageDBProvider!
              .setUpdateLevelProgress(finalScore, widget.level!.id)) {
            logger.d(" berhasil update xp level, cek db ");
          }
          if (widget.level!.target_score!.toDouble() <= finalScore) {
            if (await _languageDBProvider!.updateNextLevel(widget.level)) {
              logger.d("berhasil update, coba cek di db");
            } else {
              logger.d(" gagal membuka level selanjutnya ");
            }
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
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    Timer(const Duration(milliseconds: 800), () {
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
    S? setLanguage = S.of(context);
    Widget textHeader() {
      return Container(
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Column(
              children: [
                Text(
                  (setLanguage.code == 'en'
                      ? '${widget.languageModel?.language_name_en}'
                      : '${widget.languageModel?.language_name_id}'),
                  textAlign: TextAlign.center,
                  style:
                      whiteTextStyle.copyWith(fontSize: 32, fontWeight: bold),
                ),
                const SizedBox(
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

    Widget backtoMenu() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: isLoading
                ? () {}
                : () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
            color: redColor,
            borderColor: redColor2,
            shadowColor: redColor3,
            widthButton: 245,
            heightButton: 60,
            child: Center(
              child: Text(
                setLanguage.back_to_menu,
                style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: black),
              ),
            )),
      );
    }

    Widget scoreMatch() {
      String? resultText = "";
      int finalScore =
          ((widget.finalScoreRate + widget.finalTimeRate) * 100).round();
      List<RangeResultTxtModel>? rangeRes = _languageDBProvider!.rangeTextList;
      for (var range in rangeRes!) {
        if (range.range_min! <= finalScore && range.range_max! >= finalScore) {
          setState(() {
            resultText = (setLanguage.code == 'en'
                ? range.name_range_en
                : range.name_range_id);
          });
          logger.d("Result ${resultText}");
        }
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: primaryColor3,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            " $resultText",
            style: whiteTextStyle.copyWith(fontSize: 26, fontWeight: bold),
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
        margin: const EdgeInsets.only(top: 80, left: 10, right: 10),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            ElasticIn(child: textHeader()),
            const SizedBox(
              height: 8,
            ),
            ElasticIn(
              child: Image.asset(
                'assets/images/trophy_2.png',
                width: 162.76,
                height: 162.76,
              ),
            ),
            ElasticIn(child: scoreMatch()),
            const SizedBox(
              height: 30,
            ),
            backtoMenu()
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
          Color(0xffFD47F6),
          Color(0xffFF7CFA),
          Color(0xffFF00F5),
          Color(0xffBD00B6),
          Color(0xffF5BCF3),
          Color(0xffFF00F5)
        ], // manually specify the colors to be used
        createParticlePath: drawStar, // define a custom shape/path.
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    image: AssetImage("assets/images/background.png"),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: cardBody(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: confettiStar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
