import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  List<int>? listQuestionQueue = [];
  int totalQuestion = 10;
  int currentArrayQuestion = 0;
  int queueNow = 0;
  List<WordLanguageModel>? dataWordList;
  LanguageDBProvider? _languageProvider;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _languageProvider = Provider.of<LanguageDBProvider>(context, listen: false);
    _languageProvider!.setRuleGame(15, 5);

    getInit();
  }

  Future<bool> getInit() async {
    try {
      if (await _languageProvider!.getWords("indonesia", 3)) {
        dataWordList = _languageProvider!.dataWordList!
            .getRange(0, totalQuestion)
            .toList();
        await setUpListQuestionQueue(dataWordList);
        // setup antrian pertanyaan, gunanya untuk mekanisme skip pertanyaan

        print("in loading");
      }
      return true;
    } catch (e) {
      logger.e(e);
      logger.d('gagal load permainan');
    }

    return false;
  }

  setUpListQuestionQueue(List<WordLanguageModel>? wordList) async {
    if (wordList!.length > 0) {
      for (var i = 0; i < wordList.length; i++) {
        setState(() {
          listQuestionQueue!.add(i);
        });
      }
    }
  }

  void onSkipQueueQuestion(bool isAnswer) {
    setState(() {
      if (listQuestionQueue!.asMap().containsKey(queueNow)) {
        if (isAnswer) {
          int removeQueue = queueNow;
          listQuestionQueue!.removeAt(removeQueue);
          if (listQuestionQueue!.length <= queueNow) {
            queueNow--;
          }
        } else {
          if (listQuestionQueue!.asMap().containsKey(queueNow + 1)) {
            queueNow++;
          } else {
            queueNow = 0;
          }
        }
      } else {
        queueNow = 0;
      }

      if (listQuestionQueue!.asMap().containsKey(queueNow)) {
        currentArrayQuestion = listQuestionQueue![queueNow];
      } else {
        logger.d("game is done");
      }

      logger.d(listQuestionQueue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.all(50),
            alignment: Alignment.center,
            child: Center(
              child: Column(
                children: [
                  Text('${currentArrayQuestion}'),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          onSkipQueueQuestion(false);
                        },
                        child: Text("Next Answer"),
                      ),
                      MaterialButton(
                        onPressed: () {
                          onSkipQueueQuestion(true);
                        },
                        child: Text("Answer Button "),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
