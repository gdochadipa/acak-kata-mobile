import 'package:acakkata/callbacks/checking_word_callback.dart';
import 'package:acakkata/theme.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
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
      {required this.letter,
      required this.isBtnSelected,
      required this.onSelectButtonLetter});

  @override
  State<InputAnswerButton> createState() => _InputAnswerButtonState();
}

class _InputAnswerButtonState extends State<InputAnswerButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animation = ColorTween(begin: backgroundColor1, end: Colors.black).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
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
    _animationController.duration = const Duration(milliseconds: 50);
  }

  animateColor(bool isSelected) {
    if (isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: widget.isBtnSelected == false
          ? () {
              setState(() {
                // widget.isBtnSelected = widget.isBtnSelected ? false : true;
                widget.onSelectButtonLetter(
                    widget.letter, widget.isBtnSelected);
                animateColor(widget.isBtnSelected);
              });
            }
          : () {},
      child: Container(
        margin: const EdgeInsets.all(2),
        child: Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color: widget.isBtnSelected ? backgroundColor1 : blackColor),
              color: widget.isBtnSelected ? backgroundColor7 : backgroundColor1,
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              widget.letter,
              style: widget.isBtnSelected
                  ? whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold)
                  : blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
            ),
          ),
        ),
      ),
    );
  }
}
