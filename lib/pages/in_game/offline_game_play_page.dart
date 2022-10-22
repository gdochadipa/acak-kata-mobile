import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/helper/style_helper.dart';
import 'package:acakkata/models/coordinate.dart';
import 'package:acakkata/models/history_game_detail_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/relation_word.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/in_game/modal/answer_modal.dart';
import 'package:acakkata/pages/result_game/result_game_page.dart';
import 'package:acakkata/pages/result_game/result_offline_game_page.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/answer_input_buttons.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:acakkata/widgets/component/result_answer_component.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/gameplay/footer_gameplay_page.dart';
import 'package:acakkata/widgets/popover/exit_dialog.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  late final bool? isCustom;
  OfflineGamePlayPage(
      {this.languageModel,
      this.selectedQuestion,
      this.selectedTime,
      this.isHost,
      this.levelWords,
      this.isOnline,
      this.Stage,
      this.levelModel,
      this.isCustom});

  @override
  _OfflineGamePlayPageState createState() => _OfflineGamePlayPageState();
}

class _OfflineGamePlayPageState extends State<OfflineGamePlayPage>
    with SingleTickerProviderStateMixin {
  late final _animationRotateController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1000));
  late Animation animationRotate;
  late LanguageDBProvider? _languageDBProvider;
  TextEditingController answerController = TextEditingController(text: '');
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  String textAnswer = '';
  // List<WordLanguageModel>? dataWordList;
  List<RelationWordModel>? dataRelationWord;
  final bool _isButtonDisabled = false;
  int totalQuestion = 10;
  int currentArrayQuestion = 0;
  int currentQuestion = 1;
  int numberCountDown = 0;
  int countDownAnswer = 15;
  int scoreCount = 0;
  int score = 0;
  bool _isLoading = false;
  final int _start = 5;
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
  List<int>? listQuestionQueue = [];
  List<List<Coordinate>> coordinateList = [];
  int queueNow = 0;
  List<int> scoreTime = [];

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
    _languageDBProvider = langProvider;
    try {
      // if (await langProvider.getWords(
      //     widget.languageModel!.language_code, widget.levelWords)) {
      //   dataWordList =
      //       langProvider.dataWordList!.getRange(0, totalQuestion).toList();
      //   await setUpListQuestionQueue(dataWordList);
      //   // setup antrian pertanyaan, gunanya untuk mekanisme skip pertanyaan
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   // print("in loading");
      // }
      if (_languageDBProvider!.dataHistoryGameDetailList != null) {
        await _languageDBProvider!.resetSingleHistoryGameDetail();
      } else {
        await _languageDBProvider!.setSingleHistoryGameDetail();
      }

      if (await _languageDBProvider!.getRelationalWords(
          languageCode: widget.languageModel!.language_code,
          lengthWord: widget.levelWords,
          languageId: null,
          questionNumber: totalQuestion)) {
        dataRelationWord = _languageDBProvider!.dataRelationWordList!;

        await setUpListQuestionQueue(dataRelationWord);
        setState(() {
          _isLoading = false;
        });
        return true;
      }
    } catch (e) {
      logger.e(e);
      logger.d('gagal load permainan');
    }

    return false;
  }

  /// digunakan untuk mendaftarkan antrian ke variabel state
  setUpListQuestionQueue(List<RelationWordModel>? wordList) async {
    if (wordList!.isNotEmpty) {
      for (var i = 0; i < wordList.length; i++) {
        List<Coordinate> coordinateCache = [];
        for (var character in wordList[i].word!.split('')) {
          Coordinate charCoor = generateCoordinate(coordinateCache);
          coordinateCache.add(charCoor);
        }
        setState(() {
          listQuestionQueue!.add(i);
          coordinateList.add(coordinateCache);
        });
      }
    }
  }

  double randomDouble(double min, double max) {
    return min + (Random().nextDouble() * (max - min));
  }

  Coordinate generateCoordinate(List<Coordinate> coordinateCache) {
    double max = 230;
    double min = 0;
    var coordinate =
        Coordinate(x: randomDouble(min, max), y: randomDouble(min, max));
    if (coordinateCache.isNotEmpty) {
      while (true) {
        var wasCoor = coordinateCache.where((coordi) =>
            coordi.compareIsInsideRange(
                x1: coordinate.x ?? min, y1: coordinate.y ?? min, range: 35.5));

        if (wasCoor.isEmpty) {
          return coordinate;
        } else {
          coordinate =
              Coordinate(x: randomDouble(min, max), y: randomDouble(min, max));
        }
      }
    }

    return coordinate;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      /// bagian ini untuk menghitung mundur sebelum memulai menjawab pertanyaan
      if (startCountDown > 0) {
        setState(() {
          startCountDown--;
          _animationRotateController.forward(from: 0.0);
        });
      }

      /// bagian untuk memulai menjawab soal ketika hitung mundur habis
      else {
        timer.cancel();
        setState(() {
          isCountDown = false;
        });

        /// perhitungan waktu tampilan
        getTimeScore();

        /// merupakan perhitungan waktu utama, waktu ditentukan sesuai level atau custom
        onCoreCountTimeInGame(numberCountDown);
      }
    });
    // getTimeScore();
    // onCoreCountTimeInGame();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timeInRes != null) {
      _timerInGame!.cancel();
    }
    if (_timerScore != null) {
      _timerScore!.cancel();
    }
    if (_timeInRes != null) {
      _timeInRes!.cancel();
    }
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> showResultAnswerModal({bool resultAnswerStatus = false}) async {
    return showModal(
        context: context,
        builder: (BuildContext context) {
          S? language = S.of(context);
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.of(context).pop(true);
          });
          return AnswerModal(
              setLanguage: language, resultAnswerStatus: resultAnswerStatus);
        });
  }

  /// get Time Score digunakan untuk menghitung secara manual untuk durasi utama permainan
  /// sebagai pencetak  angka pada stopwatch
  ///
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

  /// digunakan untuk menentukan apakah question akan lanjut atau tidak
  onSkipQueueQuestion(bool isAnswer) async {
    setState(() {
      ///mengecek apkaah pentanyaan sekarang masuk antrian
      ///jika ia maka proses akan dilanjutkan
      if (listQuestionQueue!.asMap().containsKey(queueNow)) {
        ///jika proses skip adalah ketika menjawab pertanyaan
        ///maka akan menghapus dari proses antrian dan tidak dapat diakses lagi
        if (isAnswer) {
          int removeQueue = queueNow;
          listQuestionQueue!.removeAt(removeQueue);
          if (listQuestionQueue!.length <= queueNow) {
            queueNow--;
          }
        }

        /// jika tidak dalam proses menjawab maka dapat ke soal selanjutnya pada antrian listQuestionQueue
        else {
          if (listQuestionQueue!.asMap().containsKey(queueNow + 1)) {
            queueNow++;
          } else {
            queueNow = 0;
          }
        }
      }

      /// jika tidak maka antrian ke 0 dari listQuestionQueue
      else {
        queueNow = 0;
      }

      /// mengecek apakah urutan antrian sekarang itu masuk ke antrian sekarang
      /// jika masih ada sisa maka proses akan berlanjut ke soal selanjutnya
      /// jika tidak maka permainan selesai
      if (listQuestionQueue!.asMap().containsKey(queueNow)) {
        currentArrayQuestion = listQuestionQueue![queueNow];
      } else {
        logger.d("game is done");
      }
      logger.d(listQuestionQueue);
    });
  }

  /// fungsi untuk proses tambah pertanyaan
  onSkipedAnswer() async {
    setState(() {
      if (_timeInRes != null) {
        _timeInRes!.cancel();
      }

      if (_timerInGame != null) {
        _timerInGame!.cancel();
      }

      if (_timerScore != null) {
        _timerScore!.cancel();
      }
    });

    await onSkipQueueQuestion(false);
    setState(() {
      // currentArrayQuestion++;
      currentQuestion = currentArrayQuestion + 1;
      afterAnswer = false;
      answerCountDown = 0;
      countDownAnswer = numberCountDown;
    });
    setState(() {
      _isLoading = true;
    });
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _isLoading = false;
      });
    });
    onResetAnswerField();
    getTimeScore();
    onCoreCountTimeInGame(numberCountDown);
  }

  /// runTime Result merupakan mekanisme perhitungan timer untuk melihat
  /// hasil jawaban. batas waktu yang ditentukan  adalah 5 detik setelah pertanyaan
  onRunTimeResult(bool endGame, bool isCorrectAnswer) async {
    _timerInGame!.cancel();
    _timerScore!.cancel();
    showResultAnswerModal(resultAnswerStatus: isCorrectAnswer);

    // ketika jawaban salah maka akan simpan jawaban salah
    if (!isCorrectAnswer) {
      await saveHistoryGameplay(
          questionWord: dataRelationWord![currentArrayQuestion].letter,
          answerWord: null,
          statusAnswer: 0,
          remainingTime: 0,
          correctAnswer:
              dataRelationWord![currentArrayQuestion].listWords!.first,
          listWord: dataRelationWord![currentArrayQuestion].listWords!);
    }

    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (endGame) {
        double allScoreTime = scoreTime.fold(
            0, (previousValue, element) => previousValue + element);
        double newScoreTime = 0;
        double newScoreCount = 0;
        if (allScoreTime > 0 && scoreTime.isNotEmpty) {
          newScoreTime =
              (((allScoreTime / scoreTime.length) / (numberCountDown)) * 0.4);
        }
        if (scoreCount > 0) {
          newScoreCount = ((scoreCount / totalQuestion) * 0.6);
        }

        Future.delayed(const Duration(milliseconds: 1000), () async {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     CustomPageRoute(ResultGamePage(widget.languageModel, newScoreTime,
          //         newScoreCount, widget.levelModel, widget.isCustom)),
          //     (route) => false);

          Navigator.pushAndRemoveUntil(
              context,
              CustomPageRoute(ResultOfflineGamePage(
                  languageModel: widget.languageModel,
                  finalTimeRate: newScoreTime,
                  finalScoreRate: newScoreCount,
                  level: widget.levelModel,
                  isCustom: widget.isCustom)),
              (route) => false);
        });
      } else {
        /**
           * setelah perhitungan jika belum diakhir pertanyaan maka akan lanjut
           *  ke pertanyaan selanjutnya
           */
        await onSkipQueueQuestion(true);
        setState(() {
          // currentArrayQuestion++;
          currentQuestion = currentArrayQuestion + 1;
          afterAnswer = false;
        });
      }
      onResetAnswerField();
      getTimeScore();
      onCoreCountTimeInGame(numberCountDown);
    });
  }

  /// merupakan perhitungan waktu utama, waktu ditentukan sesuai level atau custom
  onCoreCountTimeInGame(int countDownNumber) async {
    Duration duration = Duration(seconds: countDownNumber);
    /** 
     * memetakan kata menjadi per huruf, ini digunakan dalam mekanisme pemilihan huruf 
     * setiap huruf yang dipilih tidak akan dipilih
     * 
     * */
    List<String> listSuffQues =
        dataRelationWord![currentArrayQuestion].letter ??
            dataRelationWord![currentArrayQuestion].word!.split('');
    for (var i = 0; i < listSuffQues.length; i++) {
      setState(() {
        isSelected!.addEntries([MapEntry(i, false)]);
      });
    }
    /**
     * end mechanism pemecah kata
     * 
     */

    /**
     * timer satu soal, timer ini akan menjalankan eksekusi ketika durasi telah habis
     */
    _timerInGame = Timer.periodic(duration, (Timer timer) {
      logger.d({
        'currentArrayQuestion': currentArrayQuestion,
        'currentQuestion': currentQuestion,
        'totalQuestion': (totalQuestion - 1),
        'nowQuestion': dataRelationWord![currentArrayQuestion].letter,
        'nowAnswer': dataRelationWord![currentArrayQuestion].word
      });
      /** untuk merestart perhitungan permainan, nilai per 1 detik */
      getTimeScore();

      timer.cancel();
      if (_timerScore != null) {
        _timerScore!.cancel();
      }
      setState(() {
        afterAnswer = true;
        answerCountDown = 5;
        resultAnswerStatus = false;
      });
      /** mengecek apakah pertanyaan sudah memasuki pertanyaan terakhir */
      var endQuestion = false;

      ///currentArrayQuestion == (totalQuestion - 1)
      if (!((listQuestionQueue!.length - 1) > 0)) {
        /** 
         * *masuk ke hasil permainan
         *  *nextQuestion
         *  */
        endQuestion = true;
      } else {
        /** ke soal selanjutnya 
         * 
         * *nextQuestion
        */
        endQuestion = false;
      }
      onRunTimeResult(endQuestion, false);
    });
  }

  /// fungsi untuk mereset jawaban dan juga tombol
  onResetAnswerField() {
    resetAnswer();
    if (textAnswer != '' && textAnswer.isNotEmpty) {
      textAnswer = '';
      answerController.text = textAnswer;
    }
  }

  ///membuat modal keluar permainan
  Future<void> showCancelGame() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => const ExitDialog(
              isOnline: false,
            ));
  }

  WordLanguageModel? checkAnswerInWords(
      String answerFromPlayer, int arrayQuestion) {
    List<WordLanguageModel>? relatedWord = dataRelationWord![arrayQuestion]
        .listWords!
        .where((wordLanguage) =>
            wordLanguage.word!.toLowerCase() == answerFromPlayer.toLowerCase())
        .toList();

    if (relatedWord.isNotEmpty) {
      return relatedWord.first;
    }

    return null;
  }

  Future<void> saveHistoryGameplay(
      {required List<String>? questionWord,
      required String? answerWord,
      required int? statusAnswer,
      required int? remainingTime,
      required WordLanguageModel? correctAnswer,
      required List<WordLanguageModel>? listWord}) async {
    HistoryGameDetailModel? historyGameDetail = HistoryGameDetailModel(
        answerWord: answerWord,
        statusAnswer: statusAnswer,
        listWords: listWord,
        correctAnswerByUser: correctAnswer,
        questionWord: questionWord,
        remainingTime: remainingTime);

    _languageDBProvider!
        .saveSingleHistoryGameDetail(historyGameDetailModel: historyGameDetail);
  }

  /// *fungsi untuk memberikan input jawaban setelah menekan tombol huruf
  /// *fungsi ini akan mengecek jawaban ketika pemain menekan tombol terakhir jawaban
  answerQuestion(String letter, int e, List<String>? suffleQuestion) async {
    /**
         * menginputkan huruf ke kolom jawaban 
         * sekaligus juga menginputkan ke sequenceAnswer (urutan huruf jawaban)
         * ngecek tombol apakah sudah dinputkan sebelumnya [isSelected]
         */
    setState(() {
      textAnswer = textAnswer + letter;
      answerController.text = textAnswer;
      isSelected![e] = true;
      sequenceAnswer!.add(e);
    });
    /**
     * mengecek apakah panjang kata jawaban sesuai dengan panjang kata soal
     */
    if (textAnswer.length == suffleQuestion!.length) {
      /**
           * *membandingkan apakah jawaban sesuai dengan kata tujuan
           * !! perbaikan ngecheck jawaban
           */
      WordLanguageModel? resultCorrect = checkAnswerInWords(
          answerController.text.toLowerCase(), currentArrayQuestion);
      // logger.d(resultCorrect?.toJson());
      if (resultCorrect != null) {
        await saveHistoryGameplay(
            questionWord: dataRelationWord![currentArrayQuestion].letter,
            answerWord: dataRelationWord![currentArrayQuestion].word,
            statusAnswer: 1,
            remainingTime: countDownAnswer,
            correctAnswer: resultCorrect,
            listWord: dataRelationWord![currentArrayQuestion].listWords!);
        setState(() {
          /**
           * mekanisme perhitungan skor
           * ! mekanisme perhitungan berubah
           */
          score = 1;
          scoreTime.add(countDownAnswer);
          scoreCount += 1;

          /**
           * persiapan untuk next soal
           */
          _timerScore!.cancel();
          _timerInGame!.cancel();

          ///currentArrayQuestion == (totalQuestion - 1)
          if (!((listQuestionQueue!.length - 1) > 0)) {
            /**
           * ketika tidak ada soal yang tersisa
           */
            afterAnswer = true;
            answerCountDown = 5;
            countDownAnswer = numberCountDown;
            resultAnswerStatus = true;
            /**
             * *nextQuestion
             */

            onRunTimeResult(true, true);
          } else {
            /**
             ** ketika soal masih tersisa
             */
            afterAnswer = true;
            answerCountDown = 5;
            countDownAnswer = numberCountDown;
            resultAnswerStatus = true;

            /**
             * *nextQuestion
             */
            onRunTimeResult(false, true);
          }
        });

        /**
         * * munculin status jawaban benar
         */
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 700),
          content: Text(
            "${S.of(context).true_string} !",
            textAlign: TextAlign.center,
            style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
          ),
          backgroundColor: successColor,
        ));
        /**
         ** reset jawaban 
         */
        resetAnswer();
        if (textAnswer != '' && textAnswer.isNotEmpty) {
          textAnswer = '';
          answerController.text = textAnswer;
        }
      } else {
        /**
         * * munculin status jawaban salah
         */
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 700),
            backgroundColor: alertColor,
            content: Text(
              "${S.of(context).false_string} !",
              textAlign: TextAlign.center,
              style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
            )));
        resetAnswer();
        if (textAnswer != '' && textAnswer.isNotEmpty) {
          textAnswer = '';
          answerController.text = textAnswer;
        }
      }
    }
  }

  /// reset jawban pada sequence jawaban
  resetAnswer() {
    List<String> listSuffQues =
        dataRelationWord![currentArrayQuestion].letter ??
            dataRelationWord![currentArrayQuestion].word!.split('');
    for (var i = 0; i < listSuffQues.length; i++) {
      setState(() {
        isSelected!.addEntries([MapEntry(i, false)]);
        sequenceAnswer!.clear();
      });
    }
  }

  //shuffle answer
  shuffleAnswer(List<String>? suffleQuestion, int currentArrayQuestion) {
    List<Coordinate> coordinateCache = [];
    for (var character in suffleQuestion!) {
      Coordinate charCoor = generateCoordinate(coordinateCache);
      coordinateCache.add(charCoor);
    }
    setState(() {
      coordinateList[currentArrayQuestion] = coordinateCache;
    });
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);

    /// perhitungan waktu permainan saat menjawab soal
    Widget textTime() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: whiteColor),
              child: Text(
                "$countDownAnswer",
                style: primaryTextStyle.copyWith(
                    fontSize: 24, fontWeight: black, color: primaryColor6),
              ),
            ),
          ],
        ),
      );
    }

    /// form jawaban input huruf
    Widget answerInput() {
      return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xff4B2F97),
                      offset: Offset(0, 4),
                    )
                  ]),
              child: Center(
                  child: TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                controller: answerController,
                style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                decoration: InputDecoration.collapsed(
                    hintText: setLanguage.answer,
                    hintStyle: whiteTextStyle.copyWith(
                        fontSize: 18, fontWeight: bold)),
              )),
            )
          ],
        ),
      );
    }

    ///  implementasi tombol reset jawaban
    Widget btnResetAnswer() {
      return Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: () {
              //reset jawaban ke null
              resetAnswer();
              if (textAnswer != '' && textAnswer.isNotEmpty) {
                textAnswer = '';
                answerController.text = textAnswer;
              }
            },
            widthButton: 100,
            heightButton: 60,
            borderThick: 5,
            color: primaryColor,
            borderColor: primaryColor2,
            shadowColor: primaryColor3,
            child: Center(
              child: Icon(
                CupertinoIcons.refresh_thick,
                semanticLabel: 'Add',
                color: whiteColor,
              ),
            )),
      );
    }

    ///  implementasi tombol suffle huruf
    Widget btnSuffleAnswer(
        List<String>? suffleQuestion, int currentArrayQuestion) {
      return Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: () {
              //reset jawaban ke null
              resetAnswer();
              if (textAnswer != '' && textAnswer.isNotEmpty) {
                textAnswer = '';
                answerController.text = textAnswer;
              }
              shuffleAnswer(suffleQuestion, currentArrayQuestion);
            },
            widthButton: 100,
            heightButton: 60,
            borderThick: 5,
            color: orangeColor,
            borderColor: orangeColor2,
            shadowColor: orangeColor3,
            child: Center(
              child: Icon(
                CupertinoIcons.shuffle_medium,
                semanticLabel: 'Add',
                color: whiteColor,
              ),
            )),
      );
    }

    /// tombol hapus kata pada jawaban
    Widget btnDeleteLetterAnswer() {
      return Container(
        margin: const EdgeInsets.all(5),
        child: ButtonBounce(
            onClick: () {
              //hapus kata per kata
              // print(sequenceAnswer);
              if (textAnswer != '' && textAnswer.isNotEmpty) {
                int lett = sequenceAnswer![textAnswer.length - 1];
                // print(lett);
                textAnswer = textAnswer.substring(0, textAnswer.length - 1);
                answerController.text = textAnswer;
                setState(() {
                  isSelected!.update(lett, (value) => false);
                  sequenceAnswer!.removeLast();
                });
              }
            },
            widthButton: 100,
            heightButton: 60,
            color: redColor,
            borderColor: redColor2,
            shadowColor: redColor3,
            borderThick: 5,
            child: Center(
              child: Icon(
                CupertinoIcons.delete_left,
                semanticLabel: 'Add',
                color: whiteColor,
              ),
            )),
      );
    }

    Widget btnSkipQuestion() {
      return Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: () {
              //hapus kata per kata
              onSkipedAnswer();
            },
            color: greenColor,
            borderColor: greenColor2,
            shadowColor: greenColor3,
            widthButton: 100,
            heightButton: 60,
            borderThick: 5,
            child: Center(
              child: Icon(
                CupertinoIcons.forward_end_alt_fill,
                semanticLabel: 'Add',
                color: whiteColor,
              ),
            )),
      );
    }

    Widget anotherActionAnswer(
        List<String>? suffleQuestion, int currentArrayQuestion) {
      return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Row(
          children: [
            Flexible(child: btnDeleteLetterAnswer()),
            Flexible(child: btnResetAnswer()),
            Flexible(
                child: btnSuffleAnswer(suffleQuestion, currentArrayQuestion)),
            Flexible(child: btnSkipQuestion())
          ],
        ),
      );
    }

    /// list tombol jawaban [list per huruf]
    Widget answerButtons(List<String>? suffleQuestion, String? question,
        List<Coordinate> coordinats) {
      List fixedList = Iterable.generate(suffleQuestion!.length).toList();
      return SizedBox(
        height: 350,
        child: Stack(
          fit: StackFit.loose,
          children: fixedList.map((e) {
            return InputAnswerButton(
                color: StyleHelper.getColorRandom('color', e % 4),
                borderColor: StyleHelper.getColorRandom('borderColor', e % 4),
                shadowColor: StyleHelper.getColorRandom('shadowColor', e % 4),
                letter: suffleQuestion[e],
                coordinate: coordinats[e],
                isBtnSelected: isSelected![e] ?? false,
                onSelectButtonLetter: (String letter, bool isUnSet) {
                  answerQuestion(letter, e, suffleQuestion);
                  // onCheckingAnswer(answer);
                });
          }).toList(),
        ),
      );
    }

    Widget cardBodyUp() {
      return Column(
        children: [
          ElasticIn(
            child: Container(
              margin:
                  EdgeInsets.only(left: defaultMargin, right: defaultMargin),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 16),
              child: Column(
                children: [
                  textTime(),
                  answerInput(),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget cardBodyBottom(
        String? question,
        String? hintQuestion,
        List<String>? suffleQuestion,
        List<Coordinate> coordinats,
        int currentArrayQuestion) {
      return Container(
        margin:
            EdgeInsets.only(top: 10, left: defaultMargin, right: defaultMargin),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
            color: primaryColor3, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            answerButtons(suffleQuestion, question, coordinats),
            anotherActionAnswer(suffleQuestion, currentArrayQuestion)
          ],
        ),
      );
    }

    Widget countStart() {
      return ElasticIn(
        delay: const Duration(milliseconds: 50),
        child: Container(
          margin: const EdgeInsets.only(top: 150),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
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
                      "$startCountDown",
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

    /// *------------------------header soal -----------------------------
    /// header soal
    AppBar header() {
      return AppBar(
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/${widget.languageModel!.language_icon}',
            width: 30,
            height: 30,
          ),
        ),
        title: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.languageModel!.language_name_en}'
                  : '${widget.languageModel!.language_name_id}'),
              style: whiteTextShadowStyle.copyWith(
                  fontWeight: black, fontSize: 24, color: whiteColor),
            ),
          ],
        ),
        actions: [
          afterAnswer
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(8),
                  child: CircleBounceButton(
                    color: whiteColor,
                    borderColor: whiteColor2,
                    shadowColor: whiteColor4,
                    onClick: () {
                      showCancelGame();
                    },
                    paddingHorizontalButton: 1,
                    paddingVerticalButton: 1,
                    heightButton: 45,
                    widthButton: 45,
                    child: Icon(Icons.close, color: whiteColor4, size: 25),
                  )),
        ],
      );
    }

    ///*-------------------------result jawaban-----------------------------------
    ///* akan muncul ketika soal berakhir dan jawaban benar
    Widget resultAnswer(
        bool resultAnswerStatus, int pointGet, String? meaning, String? word) {
      return ResultAnswerComponent(
        answerCountDown: answerCountDown,
        setLanguage: setLanguage,
        meaning: meaning,
        word: word,
        resultAnswerStatus: resultAnswerStatus,
      );
    }

    ///*-------------------------footer-----------------------------------
    ///* tampilan footer
    Widget footer() {
      return FooterGamePlayPage(
        scoreCount: scoreCount,
        stage: "${widget.levelModel!.level_name}",
      );
    }

    Widget mainBody() {
      return Column(
        children: [
          cardBodyUp(),
          ElasticIn(
            child: cardBodyBottom(
                dataRelationWord![currentArrayQuestion].word,
                dataRelationWord![currentArrayQuestion].word,
                dataRelationWord![currentArrayQuestion].letter,
                coordinateList[currentArrayQuestion],
                currentArrayQuestion),
          ),
        ],
      );
    }

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: primaryColor5,
          body: SafeArea(
              child: ListView(
            shrinkWrap: true,
            children: [
              header(),
              isCountDown
                  ? countStart()
                  : (_isLoading ? Container() : mainBody()),
            ],
          )),
        ));
  }
}
