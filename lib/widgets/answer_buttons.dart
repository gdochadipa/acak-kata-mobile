import 'package:acakkata/callbacks/CheckingWordCallback.dart';
import 'package:acakkata/widgets/answer_input_buttons.dart';
import 'package:flutter/material.dart';

class AnswerButtons extends StatelessWidget {
  late List<String> suffle_question;
  late CheckingWordCallback onCheckingAnswer;
  AnswerButtons(this.suffle_question, this.onCheckingAnswer);
  // const AnswerButtons({Key? key}) : super(key: key);
  String answer = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 5, right: 5),
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
          alignment: WrapAlignment.center,
          // children: suffle_question
          //     .map((e) => InputAnswerButton(e, (String letter, bool isUnSet) {
          //           answer = answer + letter;
          //           onCheckingAnswer(answer);
          //         }))
          //     .toList(),
        ),
      ),
    );
  }
}
