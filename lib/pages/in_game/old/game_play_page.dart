import 'dart:async';
import 'dart:developer';

import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/result_game/result_game_page.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class GamePlayPage extends StatefulWidget {
  // const GamePlayPage({Key? key}) : super(key: key);
  late final RoomProvider _roomProvider;
  late final LanguageModel? languageModel;
  late final int? selectedQuestion;
  late final int? selectedTime;
  late final int? isHost;
  late final LevelModel? levelModel;
  GamePlayPage(this.languageModel, this.selectedQuestion, this.selectedTime,
      this.isHost, this.levelModel);

  @override
  _GamePlayPageState createState() => _GamePlayPageState();
}

class _GamePlayPageState extends State<GamePlayPage> {
  TextEditingController answerController = TextEditingController(text: '');
  late RoomProvider roomProvider =
      Provider.of<RoomProvider>(context, listen: false);
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  List<WordLanguageModel>? dataWordList;
  bool _isButtonDisabled = false;
  int totalQuestion = 10;
  int currentArrayQuestion = 0;
  int currentQuestion = 1;
  int numberCountDown = 0;
  int countDownAnswer = 15;
  int scoreCount = 0;
  int score = 0;
  bool _isLoading = false;
  int _start = 5;
  Timer? _timerScore;
  Timer? _timerInGame;

  Future<bool> getInit() async {
    // LanguageDBProvider langProvider =
    // Provider.of<LanguageDBProvider>(context, listen: false);
    String language = widget.languageModel?.language_code ?? "indonesia";

    setState(() {
      _isLoading = true;
      numberCountDown = roomProvider.numberCountDown;
      countDownAnswer = numberCountDown;
      totalQuestion = roomProvider.totalQuestion;
    });
    widget._roomProvider = roomProvider;
    try {
      if (await roomProvider.getPackageQuestion(
          widget.languageModel?.id, roomProvider.roomMatch!.room_code)) {
        dataWordList = roomProvider.listQuestion;
        setState(() {
          _isLoading = false;
        });
      }
      return true;
    } catch (e) {
      logger.e(e);
      logger.d('gagal load permainan');
    }

    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (getInit() == true) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => showDialog(
              context: context,
              builder: (BuildContext context) {
                Timer _timer;
                _timer = Timer(Duration(seconds: 5), () {
                  Navigator.of(context).pop();
                });

                const duration = Duration(seconds: 1);
                Timer.periodic(duration, (Timer timer) {
                  if (_start == 0) {
                    timer.cancel();
                    setState(() {
                      _start = 5;
                    });
                  } else {
                    setState(() {
                      _start--;
                    });
                  }
                });
                return Container(
                  width:
                      MediaQuery.of(context).size.width - (2 * defaultMargin),
                  child: AlertDialog(
                    backgroundColor: backgroundColor3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Ready ?',
                            style: secondaryTextStyle.copyWith(
                                fontSize: 36, fontWeight: medium),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).then((value) {
            getTimeScore();
            timeInGame();
          }));
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  getTimeScore() {
    const duration = Duration(seconds: 1);
    _timerScore = Timer.periodic(duration, (Timer timer) {
      if (countDownAnswer == 0) {
        timer.cancel();
        setStateIfMounted(() {
          countDownAnswer = numberCountDown;
        });
      } else {
        setStateIfMounted(() {
          countDownAnswer--;
        });
      }
    });
  }

  timeInGame() async {
    Duration duration = Duration(seconds: numberCountDown);
    List<WordLanguageModel>? listQuestion = dataWordList;
    _timerInGame = Timer.periodic(duration, (Timer timer) {
      logger.d({
        'currentArrayQuestion': currentArrayQuestion,
        'currentQuestion': currentQuestion,
        'totalQuestion': (totalQuestion - 1),
        'nowQuestion': dataWordList![currentArrayQuestion].word_suffle,
        'nowAnswer': dataWordList![currentArrayQuestion].word
      });
      getTimeScore();
      if (currentArrayQuestion == (totalQuestion - 1)) {
        timer.cancel();
        Navigator.push(
            context,
            CustomPageRoute(ResultGamePage(
                widget.languageModel, 0, 0, widget.levelModel, true)));
      } else {
        setState(() {
          currentArrayQuestion++;
          currentQuestion++;
        });
      }
    });
  }

  Future<void> showTimesUpDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width - (2 * defaultMargin),
              child: AlertDialog(
                backgroundColor: backgroundColor3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "${_start}",
                        style: primaryTextStyle.copyWith(
                            fontSize: 18, fontWeight: semiBold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        width: 154,
                        height: 44,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Lihat Hasil',
                            style: primaryTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: medium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget textHint(String? word_hint) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Petunjuk',
            style:
                subtitleTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          Text(
            '${word_hint}',
            style: subtitleTextStyle.copyWith(fontSize: 20, fontWeight: medium),
          )
        ],
      ),
    );
  }

  answerQuestion() {
    setState(() {
      log('answerQuestion: ${answerController.text == dataWordList![currentArrayQuestion].word!.toLowerCase()}');
      if (answerController.text ==
          dataWordList![currentArrayQuestion].word!.toLowerCase()) {
        var score = countDownAnswer * 10;
        scoreCount += score;

        _timerScore!.cancel();
        _timerInGame!.cancel();
        if (currentArrayQuestion == (totalQuestion - 1)) {
          Navigator.push(
              context,
              CustomPageRoute(ResultGamePage(
                  widget.languageModel, 0, 0, widget.levelModel, true)));
        } else {
          currentArrayQuestion++;
          currentQuestion++;

          countDownAnswer = numberCountDown;
          getTimeScore();
          timeInGame();
        }

        logger.v({"score": score});
        SnackBar(
          backgroundColor: secondaryColor,
          content: Text(
            "Jawaban anda benar ! poin anda : ${score}",
            textAlign: TextAlign.center,
          ),
        );
      } else {
        SnackBar(
          backgroundColor: alertColor,
          content: Text(
            "Jawaban anda belum tepat !",
            textAlign: TextAlign.center,
          ),
        );
      }
      answerController.clear();
    });
  }

  String createStringHint(String? word_hint) {
    String stringHint = '';
    for (int i = 0; i < word_hint!.length; i++) {
      if (i % 2 == 0) {
        stringHint += word_hint.characters.elementAt(i);
      } else {
        if (word_hint.characters.elementAt(i) == '-') {
          stringHint += '_';
        }
      }
    }
    return word_hint;
  }

  @override
  Widget build(BuildContext context) {
    Widget textHeader() {
      return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: backgroundColor4, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Column(
              children: [
                Text(
                  '${widget.languageModel!.language_name}',
                  style: blackTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
                Text(
                  '#${currentQuestion}/${totalQuestion}',
                  style: subtitleTextStyle.copyWith(
                      fontSize: 13, fontWeight: regular),
                ),
                SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  value: currentQuestion / totalQuestion,
                  backgroundColor: backgroundColor5,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ],
            ),
          ));
    }

    Widget TextTime(int? time) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/icon_time.jpg',
                  ),
                ),
              ),
            ),
            Text(
              "${countDownAnswer}",
              style:
                  thirdTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
            )
          ],
        ),
      );
    }

    Widget answerInput() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: grayColor2, borderRadius: BorderRadius.circular(12)),
              child: Center(
                  child: TextFormField(
                enabled: !_isButtonDisabled,
                controller: answerController,
                style: blackTextStyle,
                decoration: InputDecoration.collapsed(
                    hintText: 'Answer', hintStyle: subtitleTextStyle),
              )),
            )
          ],
        ),
      );
    }

    Widget alphabetQuestion(String alphabet) {
      return Container(
        margin: EdgeInsets.all(2),
        child: Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [firstLinierColor, secondLinierColor],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(3)),
          child: Center(
            child: Text(
              "${alphabet}",
              style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold),
            ),
          ),
        ),
      );
    }

    Widget rowAlphabet(List<String> strings) {
      return Container(
        margin: EdgeInsets.only(top: 20, left: 5, right: 5),
        child: Wrap(
          children: strings.map((e) => alphabetQuestion(e)).toList(),
        ),
      );
    }

    Widget btnAnswer() {
      return Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(top: 15),
        child: TextButton(
          onPressed: _isButtonDisabled
              ? null
              : () {
                  answerQuestion();
                },
          style: TextButton.styleFrom(
              backgroundColor:
                  _isButtonDisabled ? secondaryDisabled : secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(
            'Answer',
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
          ),
        ),
      );
    }

    Widget cardBodyUp(String? question, String? hint_question,
        List<String>? suffle_question) {
      return Container(
        margin:
            EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.only(top: 10, left: 15, right: 16, bottom: 16),
        decoration: BoxDecoration(
            color: backgroundColor1, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            textHeader(),
            TextTime(10),
            SizedBox(height: 20),
            rowAlphabet(suffle_question!),
            textHint(createStringHint(hint_question)),
            SizedBox(height: 20),
          ],
        ),
      );
    }

    Widget cardBodyDown() {
      return Container(
        margin:
            EdgeInsets.only(top: 30, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor1, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            children: [
              answerInput(),
              btnAnswer(),
            ],
          ),
        ),
      );
    }

    List<String>? str = ["T", "U", "W"];
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: backgroundColor2,
          body: Container(
            child: _isLoading
                ? null
                : ListView(
                    children: [
                      cardBodyUp(
                          "Tunggu Count Down",
                          dataWordList![currentArrayQuestion].word,
                          dataWordList![currentArrayQuestion].word_suffle),
                      cardBodyDown()
                    ],
                  ),
          ),
        ));
  }
}