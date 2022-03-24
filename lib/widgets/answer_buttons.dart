import 'package:acakkata/callbacks/CheckingWordCallback.dart';
import 'package:acakkata/widgets/answer_input_buttons.dart';
import 'package:flutter/material.dart';

class AnswerButtons extends StatelessWidget {
  late List<String> suffle_question;
  late CheckingWordCallback onCheckingAnswer;
  AnswerButtons(this.suffle_question, this.onCheckingAnswer);
  // const AnswerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 5, right: 5),
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
          children: suffle_question
              .map((e) => InputAnswerButton(e, (String letter) {
                    print("select on letter ${e}");
                    onCheckingAnswer("passing data to Page");
                  }))
              .toList(),
        ),
      ),
    );
  }
}
