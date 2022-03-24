import 'package:acakkata/callbacks/CheckingWordCallback.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class InputAnswerButton extends StatelessWidget {
  // const InputAnswerButton({
  //   Key? key,
  // }) : super(key: key);

  late String letter;
  late bool isBtnSelected;
  late CheckingLetterCallback onSelectButtonLetter;
  InputAnswerButton(this.letter, this.onSelectButtonLetter);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.all(2),
        child: OutlinedButton(
          onPressed: () {
            onSelectButtonLetter(letter);
          },
          style: OutlinedButton.styleFrom(
              side: BorderSide(
                  width: 1,
                  color: isBtnSelected ? backgroundColor1 : blackColor),
              backgroundColor:
                  isBtnSelected ? backgroundColor4 : backgroundColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          child: Text(
            "${letter}",
            style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold),
          ),
        ),
      ),
    );
  }
}
