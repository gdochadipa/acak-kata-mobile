import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:math';

import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/result_game/result_game_page.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/answer_input_buttons.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/gameplay/footer_gameplay_page.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class OfflineGamePlayPage extends StatefulWidget {
  // const GamePlayPage({Key? key}) : super(key: key);
  late final LanguageDBProvider _langProvider;
  late final LanguageModel? languageModel;
  late final int? selectedQuestion;
  late final int? selectedTime;
  late final int? levelWords;
  late final int? isHost;
  late final bool? isOnline;
  late final String? Stage;
  late final LevelModel? levelModel;
  OfflineGamePlayPage(
      {this.languageModel,
      this.selectedQuestion,
      this.selectedTime,
      this.isHost,
      this.levelWords,
      this.isOnline,
      this.Stage,
      this.levelModel});

  @override
  _OfflineGamePlayPageState createState() => _OfflineGamePlayPageState();
}

class _OfflineGamePlayPageState extends State<OfflineGamePlayPage>
    with SingleTickerProviderStateMixin {
  late final _animationRotateController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  late Animation animationRotate;
  TextEditingController answerController = TextEditingController(text: '');
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  String textAnswer = '';
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
  int startCountDown = 3;
  int answerCountDown = 5;
  Timer? _timerScore;
  Timer? _timerInGame;
  Timer? _timeInRes;
  Map<int, bool>? isSelected = {};
  List<int>? sequenceAnswer = [];
  double _widthRotate = 80;
  double _heightRotate = 60;
  bool isCountDown = true;
  bool afterAnswer = false;
  bool resultAnswerStatus = false;

  Future<bool> getInit() async {
    LanguageDBProvider langProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);
    langProvider.setRuleGame(widget.selectedTime, widget.selectedQuestion);
    // langProvider.init();
    String language = widget.languageModel?.language_code ?? "indonesia";

    setState(() {
      _isLoading = true;
      numberCountDown = langProvider.numberCountDown;
      countDownAnswer = numberCountDown;
      totalQuestion = langProvider.totalQuestion;
    });

    widget._langProvider = langProvider;
    try {
      if (await langProvider.getWords(
          widget.languageModel!.language_code, widget.levelWords)) {
        dataWordList =
            langProvider.dataWordList!.getRange(0, totalQuestion).toList();
        setState(() {
          _isLoading = false;
        });
        print("in loading");
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
    _widthRotate = 180;
    _heightRotate = 180;
    animationRotate = Tween(begin: 0.0, end: 0.25).animate(CurvedAnimation(
        parent: _animationRotateController, curve: Curves.elasticOut));

    getInit();
    Timer _timer;

    // const duration = Duration(seconds: 1);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (startCountDown > 0) {
        setState(() {
          startCountDown--;
          _animationRotateController.forward(from: 0.0);
        });
      } else {
        timer.cancel();
        setState(() {
          isCountDown = false;
        });
        getTimeScore();
        timeInGame(numberCountDown);
      }
    });
    // getTimeScore();
    // timeInGame();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerInGame!.cancel();
    _timerScore!.cancel();
    if (_timeInRes != null) {
      _timeInRes!.cancel();
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

  runTimeResult(bool endGame) {
    _timeInRes = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (answerCountDown > 0) {
        setState(() {
          answerCountDown--;
        });
      } else {
        timer.cancel();
        _timerInGame!.cancel();
        _timerScore!.cancel();
        if (endGame) {
          Navigator.push(
              context,
              CustomPageRoute(ResultGamePage(
                  widget.languageModel, scoreCount, widget.levelModel)));
        } else {
          setState(() {
            currentArrayQuestion++;
            currentQuestion++;
            afterAnswer = false;
          });
        }
        resetAnswerField();
        getTimeScore();
        timeInGame(numberCountDown);
      }
    });
  }

  timeInGame(int countDownNumber) async {
    Duration duration = Duration(seconds: countDownNumber);
    List<String> listSuffQues =
        dataWordList![currentArrayQuestion].word!.split('');
    for (var i = 0; i < listSuffQues.length; i++) {
      setState(() {
        isSelected!.addEntries([MapEntry(i, false)]);
      });
    }
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
        _timerScore!.cancel();
        setState(() {
          afterAnswer = true;
          answerCountDown = 5;
          resultAnswerStatus = false;
        });
        runTimeResult(true);
        // Navigator.push(
        //     context,
        //     CustomPageRoute(ResultGamePage(
        //         widget.languageModel, scoreCount, widget.levelModel)));
      } else {
        timer.cancel();
        _timerScore!.cancel();
        setState(() {
          afterAnswer = true;
          answerCountDown = 5;
          resultAnswerStatus = false;
        });
        runTimeResult(false);
      }
    });
  }

  resetAnswerField() {
    resetAnswer();
    if (textAnswer != '' && textAnswer.length > 0) {
      textAnswer = '';
      answerController.text = textAnswer;
    }
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

  Future<void> showCancelGame() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width - (2 * defaultMargin),
              child: AlertDialog(
                backgroundColor: backgroundColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                content: SingleChildScrollView(
                    child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: primaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Ingin keluar permainan ?',
                      style: headerText2.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, right: 5),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(2),
                            height: 44,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (route) => false);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Ya, ingin keluar',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: Container(
                            margin: EdgeInsets.all(5),
                            height: 44,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                    width: 1, color: backgroundColor2),
                                backgroundColor: backgroundColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Tidak, ingin lanjut',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    )
                  ],
                )),
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

  answerQuestion(
      String letter, int e, List<String>? suffle_question, String? question) {
    setState(() {
      textAnswer = textAnswer + letter;
      answerController.text = textAnswer;
      isSelected![e] = true;
      sequenceAnswer!.add(e);
    });
    if (textAnswer.length == suffle_question!.length) {
      logger.d(
          "${answerController.text.toUpperCase()} == ${question!.toUpperCase()} => ${answerController.text.toUpperCase() == question.toUpperCase()}");
      if (answerController.text.toUpperCase() == question.toUpperCase()) {
        setState(() {
          score = countDownAnswer * 10;
          scoreCount += score;

          _timerScore!.cancel();
          _timerInGame!.cancel();

          if (currentArrayQuestion == (totalQuestion - 1)) {
            setState(() {
              afterAnswer = true;
              answerCountDown = 5;
              countDownAnswer = numberCountDown;
              resultAnswerStatus = true;
            });
            runTimeResult(true);
          } else {
            // currentArrayQuestion++;
            // currentQuestion++;

            // countDownAnswer = numberCountDown;
            // getTimeScore();
            // timeInGame(numberCountDown);
            setState(() {
              afterAnswer = true;
              answerCountDown = 5;
              countDownAnswer = numberCountDown;
              resultAnswerStatus = true;
            });
            runTimeResult(false);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 700),
          content: Text(
            "Benar !",
            textAlign: TextAlign.center,
            style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
          ),
          backgroundColor: successColor,
        ));

        resetAnswer();
        if (textAnswer != '' && textAnswer.length > 0) {
          textAnswer = '';
          answerController.text = textAnswer;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(milliseconds: 700),
            backgroundColor: alertColor,
            content: Text(
              "Salah !",
              textAlign: TextAlign.center,
              style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
            )));
        resetAnswer();
        if (textAnswer != '' && textAnswer.length > 0) {
          textAnswer = '';
          answerController.text = textAnswer;
        }
      }
    }
  }

  resetAnswer() {
    List<String> listSuffQues =
        dataWordList![currentArrayQuestion].word!.split('');
    for (var i = 0; i < listSuffQues.length; i++) {
      setState(() {
        isSelected!.addEntries([MapEntry(i, false)]);
        sequenceAnswer!.clear();
      });
    }
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

    Widget TextTime() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              margin: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: backgroundColorAccent2),
              child: Text(
                "${countDownAnswer}",
                style: whiteTextStyle.copyWith(fontSize: 24, fontWeight: bold),
              ),
            ),
          ],
        ),
      );
    }

    Widget answerInput() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: backgroundColor9,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                controller: answerController,
                style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                decoration: InputDecoration.collapsed(
                    hintText: 'Jawaban',
                    hintStyle: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: medium,
                        color: backgroundColor7)),
              )),
            )
          ],
        ),
      );
    }

    Widget btnResetAnswer() {
      return Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.all(5),
        child: TextButton(
          onPressed: () {
            //reset jawaban ke null
            resetAnswer();
            if (textAnswer != '' && textAnswer.length > 0) {
              textAnswer = '';
              answerController.text = textAnswer;
            }
          },
          style: TextButton.styleFrom(
              side: BorderSide(width: 1, color: blackColor),
              backgroundColor: backgroundColor1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Wrap(
            children: [
              Icon(
                CupertinoIcons.refresh_thick,
                semanticLabel: 'Add',
                color: blackColor,
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                'Reset Answer',
                style: blackTextStyle.copyWith(fontSize: 13, fontWeight: bold),
              )
            ],
          ),
        ),
      );
    }

    Widget btnDeleteLetterAnswer() {
      return Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.all(5),
        child: TextButton(
          onPressed: () {
            //hapus kata per kata
            print(sequenceAnswer);
            if (textAnswer != '' && textAnswer.length > 0) {
              int lett = sequenceAnswer![textAnswer.length - 1];
              print(lett);
              textAnswer = textAnswer.substring(0, textAnswer.length - 1);
              answerController.text = textAnswer;
              setState(() {
                isSelected!.update(lett, (value) => false);
                sequenceAnswer!.removeLast();
              });
            }
          },
          style: TextButton.styleFrom(
              side: BorderSide(width: 1, color: blackColor),
              backgroundColor: backgroundColor1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Wrap(
            children: [
              Icon(
                CupertinoIcons.delete_left,
                semanticLabel: 'Add',
                color: blackColor,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Delete',
                style: blackTextStyle.copyWith(fontSize: 14, fontWeight: bold),
              ),
            ],
          ),
        ),
      );
    }

    Widget btnExit() {
      return Container(
        margin: EdgeInsets.only(
          top: 15,
        ),
        child: Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          child: ClickyButton(
            onPressed: () {
              //hapus kata per kata
              Timer(Duration(milliseconds: 500), () {
                showCancelGame();
              });
            },
            color: alertColor,
            shadowColor: alertAccentColor,
            width: 200,
            height: 60,
            child: Wrap(
              children: [
                Icon(
                  CupertinoIcons.square_arrow_left,
                  semanticLabel: 'Add',
                  color: whiteColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Keluar',
                  style:
                      whiteTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget anotherActionAnswer() {
      return Container(
        margin: EdgeInsets.only(top: 15),
        child: Row(
          children: [
            Flexible(child: btnResetAnswer()),
            Flexible(child: btnDeleteLetterAnswer())
          ],
        ),
      );
    }

    Widget AnswerButtons(List<String>? suffle_question, String? question) {
      List fixedList = Iterable.generate(suffle_question!.length).toList();
      return Container(
        margin: EdgeInsets.only(top: 20, left: 5, right: 5),
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: fixedList
                  .map((e) => InputAnswerButton(
                      letter: suffle_question[e],
                      isBtnSelected: isSelected![e] ?? false,
                      onSelectButtonLetter: (String letter, bool isUnSet) {
                        answerQuestion(letter, e, suffle_question, question);
                        // onCheckingAnswer(answer);
                      }))
                  .toList(),
            ),
            SizedBox(
              height: 10,
            ),
            anotherActionAnswer(),
            btnExit()
          ],
        ),
      );
    }

    Widget cardBodyUp() {
      return Column(
        children: [
          Container(
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: countDownAnswer / numberCountDown,
                backgroundColor: backgroundColor1,
                valueColor: AlwaysStoppedAnimation<Color>(alertColor),
              ),
            ),
          ),
          ElasticIn(
            child: Container(
              margin:
                  EdgeInsets.only(left: defaultMargin, right: defaultMargin),
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextTime(),
                  SizedBox(height: 20),
                  answerInput(),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget cardBodyBottom(String? question, String? hint_question,
        List<String>? suffle_question) {
      return Container(
        margin:
            EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.only(top: 10, left: 15, right: 16, bottom: 16),
        decoration: BoxDecoration(
            color: backgroundColor1, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            // textHeader(),
            AnswerButtons(suffle_question, question)
          ],
        ),
      );
    }

    Widget countStart() {
      return ElasticIn(
        delay: Duration(milliseconds: 50),
        child: Container(
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.elasticInOut,
              width: _widthRotate,
              height: _heightRotate,
              child: Center(
                  child: Stack(
                children: [
                  AnimatedBuilder(
                      animation: animationRotate,
                      child: Container(
                          width: 180, height: 180, color: backgroundColor9),
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: animationRotate.value * pi,
                          child: child,
                        );
                      }),
                  Center(
                    child: Text(
                      "${startCountDown}",
                      style: whiteTextStyle.copyWith(
                          fontSize: 55, fontWeight: bold),
                    ),
                  )
                ],
                alignment: Alignment.center,
              )),
            ),
          ),
        ),
      );
    }

    AppBar header() {
      return AppBar(
        leading: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 5),
          child: Text(
            "${currentQuestion} of ${totalQuestion}",
            style: blackTextStyle.copyWith(fontWeight: bold, fontSize: 14),
          ),
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              "${widget.languageModel!.language_name}",
              style: headerText2.copyWith(
                  fontWeight: extraBold, fontSize: 20, color: primaryTextColor),
            ),
            Text(
              widget.isOnline == true ? 'Multiplayer' : 'Single Player',
              style:
                  primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
        actions: [],
      );
    }

    Widget resultAnswer(
        bool resultAnswerStatus, int pointGet, String? meaning, String? word) {
      return Container(
        child: Center(
          child: ListView(
            children: [
              Container(
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: answerCountDown / 5,
                    backgroundColor: backgroundColor1,
                    valueColor: AlwaysStoppedAnimation<Color>(alertColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElasticIn(
                delay: Duration(milliseconds: 50),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: backgroundColorAccent2),
                        child: Text(
                          "${answerCountDown}",
                          style: whiteTextStyle.copyWith(
                              fontSize: 24, fontWeight: bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElasticIn(
                delay: Duration(milliseconds: 50),
                child: Container(
                    margin: EdgeInsets.only(bottom: 30, left: 15, right: 15),
                    child: Center(
                      child: Text(
                        resultAnswerStatus ? "Benar" : "Salah",
                        style: whiteTextStyle.copyWith(
                            fontSize: 32, fontWeight: bold),
                      ),
                    )),
              ),
              ElasticIn(
                delay: Duration(milliseconds: 50),
                child: Container(
                  margin: EdgeInsets.only(bottom: 32, left: 15, right: 15),
                  child: Center(
                    child: resultAnswerStatus
                        ? Image.asset(
                            'assets/images/success_icon.png',
                            width: 74.92,
                            height: 74.92,
                          )
                        : Image.asset(
                            'assets/images/fail_icon.png',
                            width: 74.92,
                            height: 74.92,
                          ),
                  ),
                ),
              ),
              ElasticIn(
                delay: Duration(milliseconds: 50),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColor9,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "+ ${pointGet}",
                      style: whiteTextStyle.copyWith(
                          fontSize: 32, fontWeight: bold),
                    ),
                  ),
                ),
              ),
              ElasticIn(
                delay: Duration(milliseconds: 50),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: backgroundColor1,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            " ${word}",
                            style: blackTextStyle.copyWith(
                                fontSize: 23, fontWeight: bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${meaning}",
                            textAlign: TextAlign.center,
                            style: blackTextStyle.copyWith(
                                fontSize: 18, fontWeight: semiBold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget footer() {
      return FooterGamePlayPage(
        scoreCount: scoreCount,
        stage: "${widget.levelModel!.level_name}",
      );
    }

    Widget mainBody() {
      return Container(
        child: _isLoading
            ? null
            : ListView(
                children: [
                  cardBodyUp(),
                  ElasticIn(
                    child: cardBodyBottom(
                        dataWordList![currentArrayQuestion].word,
                        dataWordList![currentArrayQuestion].word,
                        dataWordList![currentArrayQuestion].word_suffle),
                  ),
                ],
              ),
      );
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: header(),
          bottomNavigationBar: Container(
              constraints: BoxConstraints(maxHeight: 84), child: footer()),
          backgroundColor: backgroundColor2,
          body: isCountDown
              ? countStart()
              : (afterAnswer
                  ? resultAnswer(
                      resultAnswerStatus,
                      score,
                      dataWordList![currentArrayQuestion].word_hint,
                      dataWordList![currentArrayQuestion].word)
                  : mainBody()),
        ));
  }
}
