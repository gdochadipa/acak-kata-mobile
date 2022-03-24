import 'package:acakkata/callbacks/CheckingWordCallback.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class InputAnswerButton extends StatefulWidget {
  // const InputAnswerButton({
  //   Key? key,
  // }) : super(key: key);

  late String letter;
  late CheckingLetterCallback onSelectButtonLetter;
  InputAnswerButton(this.letter, this.onSelectButtonLetter);

  @override
  State<InputAnswerButton> createState() => _InputAnswerButtonState();
}

class _InputAnswerButtonState extends State<InputAnswerButton>
    with SingleTickerProviderStateMixin {
  bool isBtnSelected = false;
  late double _scale;
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 50),
        lowerBound: 0.0,
        upperBound: 0.1)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant InputAnswerButton oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _animationController.duration = Duration(milliseconds: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Container(
        width: 45,
        height: 45,
        margin: EdgeInsets.all(2),
        child: TextButton(
          onPressed: isBtnSelected == false
              ? () {
                  setState(() {
                    isBtnSelected = isBtnSelected ? false : true;
                    widget.onSelectButtonLetter(widget.letter, isBtnSelected);
                  });
                }
              : () {},
          style: TextButton.styleFrom(
              side: BorderSide(
                  width: 1,
                  color: isBtnSelected ? backgroundColor1 : blackColor),
              backgroundColor:
                  isBtnSelected ? backgroundColor7 : backgroundColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          child: Text(
            "${widget.letter}",
            style: isBtnSelected
                ? whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold)
                : blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
          ),
        ),
      ),
    );
  }
}
