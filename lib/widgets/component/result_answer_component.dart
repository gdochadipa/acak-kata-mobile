import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ResultAnswerComponent extends StatelessWidget {
  const ResultAnswerComponent(
      {Key? key,
      required this.answerCountDown,
      required this.setLanguage,
      required this.resultAnswerStatus,
      required this.word,
      required this.meaning})
      : super(key: key);

  final int answerCountDown;
  final S? setLanguage;
  final bool resultAnswerStatus;
  final String? word;
  final String? meaning;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          ElasticIn(
            delay: const Duration(milliseconds: 50),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: whiteColor),
                    child: Text(
                      "$answerCountDown",
                      style: primaryTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: black,
                          color: primaryColor6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElasticIn(
            delay: const Duration(milliseconds: 50),
            child: Container(
              margin: const EdgeInsets.only(bottom: 32, left: 15, right: 15),
              child: Center(
                child: resultAnswerStatus
                    ? Image.asset(
                        'assets/images/great_job.png',
                        width: 175,
                        height: 175,
                      )
                    : Image.asset(
                        'assets/images/question.png',
                        width: 175,
                        height: 175,
                      ),
              ),
            ),
          ),
          ElasticIn(
              duration: const Duration(milliseconds: 50),
              child: Container(
                  margin: const EdgeInsets.only(
                      left: 15, right: 15, top: 5, bottom: 5),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: resultAnswerStatus ? greenColor : redColor,
                          border: Border.all(
                              color:
                                  resultAnswerStatus ? greenColor2 : redColor2,
                              width: 4),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: resultAnswerStatus
                                    ? greenColor3
                                    : redColor3,
                                offset: const Offset(0, 4))
                          ]),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        child: Text(
                          resultAnswerStatus
                              ? setLanguage!.true_string
                              : setLanguage!.false_string,
                          style: whiteTextStyle.copyWith(
                              fontSize: 20, fontWeight: bold),
                        ),
                      ),
                    ),
                  ))),
          ElasticIn(
            delay: const Duration(milliseconds: 50),
            child: Container(
              margin:
                  const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      " $word",
                      style: whiteTextStyle.copyWith(
                          fontSize: 26, fontWeight: bold),
                    ),
                  ),
                  AutoSizeText(
                    "$meaning",
                    textAlign: TextAlign.center,
                    style: whiteTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                    minFontSize: 14,
                    maxFontSize: 20,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
