import 'dart:async';
import 'dart:math';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/history_game_detail_model.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/range_result_txt_model.dart';
import 'package:acakkata/pages/level/level_list_page.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/collapse/custome_expansion_tile.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ResultOfflineGamePage extends StatefulWidget {
  const ResultOfflineGamePage(
      {Key? key,
      required this.languageModel,
      required this.finalTimeRate,
      required this.finalScoreRate,
      required this.level,
      required this.isCustom})
      : super(key: key);

  final LanguageModel languageModel;
  final double finalTimeRate;
  final double finalScoreRate;
  final LevelModel? level;
  final bool? isCustom;

  @override
  State<ResultOfflineGamePage> createState() => _ResultOfflineGamePageState();
}

class _ResultOfflineGamePageState extends State<ResultOfflineGamePage> {
  late ConfettiController _confettiController;
  late LanguageDBProvider? _languageDBProvider;
  List<HistoryGameDetailModel>? _historyGameDetailModel;
  bool isLoading = false;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  updateLevel() async {
    isLoading = true;
    _languageDBProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);

    logger.d(_languageDBProvider!.dataHistoryGameDetailList!.length);

    if (_languageDBProvider!.dataHistoryGameDetailList != null) {
      _historyGameDetailModel = _languageDBProvider!.dataHistoryGameDetailList;
    } else {
      _historyGameDetailModel = [];
    }

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

    Widget textHeader() {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Center(
          child: Column(
            children: [
              Text(
                (setLanguage.code == 'en'
                    ? '${widget.languageModel.language_name_en}'
                    : '${widget.languageModel.language_name_id}'),
                textAlign: TextAlign.center,
                style: whiteTextStyle.copyWith(fontSize: 28, fontWeight: bold),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                '${widget.level?.level_name}',
                style: whiteTextStyle.copyWith(fontSize: 23, fontWeight: bold),
              ),
            ],
          ),
        ),
      );
    }

    Widget scoreHeader({required int? finalScoreGame}) {
      return Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(color: primaryColor8, shape: BoxShape.circle),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$finalScoreGame",
                  textAlign: TextAlign.center,
                  style:
                      whiteTextStyle.copyWith(fontSize: 48, fontWeight: bold)),
              Text("poin",
                  textAlign: TextAlign.center,
                  style:
                      whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold))
            ],
          ),
        ),
      );
    }

    Widget textResultHeader({required String? resultText}) {
      return Container(
        width: 180,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "$resultText",
            style: primaryTextStyle.copyWith(fontSize: 20, fontWeight: bold),
          ),
        ),
      );
    }

    Widget resultGame() {
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
        }
      }
      return Container(
        decoration: BoxDecoration(color: primaryColor7),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            textHeader(),
            const SizedBox(
              height: 15,
            ),
            scoreHeader(finalScoreGame: finalScore),
            const SizedBox(
              height: 3,
            ),
            textResultHeader(resultText: resultText),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Widget childrenAnswer(
        {required bool answer,
        required String? answerWord,
        required String? meaning,
        required List<String>? relatedWord}) {
      return CustomExpansionTile(
        leading: answer
            ? Image.asset(
                'assets/images/success.png',
                height: 30,
                width: 30,
              )
            : Image.asset(
                'assets/images/fail.png',
                height: 30,
                width: 30,
              ),
        title: Text(
          answerWord.toString().toUpperCase(),
          style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
        ),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  meaning.toString(),
                  style:
                      blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: relatedWord!
                      .map((e) => Chip(
                            label: Text(
                              "$e",
                              style: whiteTextStyle.copyWith(fontSize: 15),
                            ),
                            backgroundColor: successColor,
                          ))
                      .toList(),
                )
              ],
            ),
          )
        ],
      );
    }

    Widget wordHistoryAnswers() {
      return ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: _historyGameDetailModel!
              .map((e) => childrenAnswer(
                  answer: (e.statusAnswer == 1 ? true : false),
                  answerWord: e.correctAnswerByUser?.word,
                  meaning: e.correctAnswerByUser?.word_hint,
                  relatedWord:
                      e.listWords!.map((word) => word.word ?? '').toList()))
              .toList());
    }

    Widget starView(
        {required double left,
        required double top,
        required double rotate,
        required double height,
        required double width}) {
      return Positioned(
          left: left,
          top: top,
          child: Transform.rotate(
            angle: rotate * math.pi / 180,
            child: Image.asset(
              'assets/images/new_star.png',
              height: height,
              width: width,
            ),
          ));
    }

    Widget backtoMenu() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: isLoading
                ? () {}
                : () {
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, '/home', (route) => false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        CustomPageRoute(
                          LevelListPage(
                            isOnline: false,
                            languageModel: widget.languageModel,
                          ),
                        ),
                        (route) => false);
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

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(top: 0),
        child: ListView(
          children: [
            Stack(
              children: [
                resultGame(),
                starView(
                    left: 45, top: 130, rotate: 0, height: 82.6, width: 74.28),
                starView(
                    left: 335, top: 50, rotate: 50, height: 49.1, width: 44),
                starView(
                    left: 335,
                    top: 300,
                    rotate: 15,
                    height: 42.02,
                    width: 37.79),
                starView(
                    left: 40, top: 310, rotate: 50, height: 49.1, width: 44)
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 15),
              child: Text(
                "Hasil Jawaban",
                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
              ),
            ),
            wordHistoryAnswers(),
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
        child: Scaffold(
          backgroundColor: whiteColor,
          body: Stack(
            fit: StackFit.expand,
            children: [
              body(),
              Align(
                alignment: Alignment.topCenter,
                child: confettiStar(),
              ),
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}
