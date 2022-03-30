import 'package:acakkata/callbacks/CheckingWordCallback.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class InputAnswerButton extends StatefulWidget {
  // const InputAnswerButton({
  //   Key? key,
  // }) : super(key: key);

  late String letter;
  late bool isBtnSelected;
  late CheckingLetterCallback onSelectButtonLetter;
  // InputAnswerButton(this.letter, this.onSelectButtonLetter);
  InputAnswerButton(
      {required String this.letter,
      required bool this.isBtnSelected,
      required CheckingLetterCallback this.onSelectButtonLetter});

  @override
  State<InputAnswerButton> createState() => _InputAnswerButtonState();
}

class _InputAnswerButtonState extends State<InputAnswerButton>
    with SingleTickerProviderStateMixin {
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
        width: 50,
        height: 50,
        margin: EdgeInsets.all(8),
        child: TextButton(
          onPressed: widget.isBtnSelected == false
              ? () {
                  setState(() {
                    // widget.isBtnSelected = widget.isBtnSelected ? false : true;
                    widget.onSelectButtonLetter(
                        widget.letter, widget.isBtnSelected);
                  });
                }
              : () {},
          style: TextButton.styleFrom(
              side: BorderSide(
                  width: 1,
                  color: widget.isBtnSelected ? backgroundColor1 : blackColor),
              backgroundColor:
                  widget.isBtnSelected ? backgroundColor7 : backgroundColor1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
          child: Text(
            "${widget.letter}",
            style: widget.isBtnSelected
                ? whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold)
                : blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
          ),
        ),
      ),
    );
  }
}
