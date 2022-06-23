import 'dart:async';
import 'dart:math';

import 'package:acakkata/callbacks/checking_word_callback.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class InputAnswerButton extends StatefulWidget {
  // const InputAnswerButton({
  //   Key? key,
  // }) : super(key: key);

  final String letter;
  final bool isBtnSelected;
  final CheckingLetterCallback onSelectButtonLetter;
  final Color color;
  final Color borderColor;
  final Color shadowColor;

  // InputAnswerButton(this.letter, this.onSelectButtonLetter);
  InputAnswerButton(
      {Key? key,
      required this.color,
      required this.borderColor,
      required this.shadowColor,
      required this.letter,
      required this.isBtnSelected,
      required this.onSelectButtonLetter})
      : super(key: key);

  @override
  State<InputAnswerButton> createState() => _InputAnswerButtonState();
}

class _InputAnswerButtonState extends State<InputAnswerButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _animationController;
  late Animation _animation;

  double _padding = 6;
  double _reversePadding = 0;
  double _moveTop = 0;

  double random(double min, double max) {
    return min + (Random().nextDouble() * (max - min));
  }

  @override
  void initState() {
    // TODO: implement initState

    Timer.periodic(const Duration(seconds: 2), (timer) {
      _moveTop = random(0, 350);
    });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {});

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
    Timer.periodic(const Duration(seconds: 2), (timer) {
      _moveTop = random(0, 350);
    });
  }

  void runMove() {
    setState(() {
      _moveTop = random(0, 350);
    });
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
    return AnimatedPositioned(
        top: _moveTop,
        right: random(0, 300),
        duration: const Duration(seconds: 2),
        onEnd: () {
          setState(() {
            _moveTop = random(0, 300);
          });
        },
        child: SizedBox(
          height: 75,
          width: 75,
          child: GestureDetector(
            onTap: widget.isBtnSelected == false
                ? () {
                    setState(() {
                      // widget.isBtnSelected = widget.isBtnSelected ? false : true;
                      widget.onSelectButtonLetter(
                          widget.letter, widget.isBtnSelected);
                      setState(() {
                        _moveTop = random(0, 300);
                      });
                      animateColor(widget.isBtnSelected);
                    });
                  }
                : () {},
            onTapDown: (_) => setState(() {
              if (widget.isBtnSelected == false) {
                _padding = 0.0;
                _reversePadding = 6;
              }
            }),
            onTapUp: (_) => setState(() {
              if (widget.isBtnSelected == false) {
                _padding = 6;
                _reversePadding = 0.0;
              }
            }),
            child: AnimatedContainer(
              padding: EdgeInsets.only(bottom: _padding),
              margin: EdgeInsets.only(top: _reversePadding),
              decoration: BoxDecoration(
                  color:
                      widget.isBtnSelected ? whiteColor3 : widget.shadowColor,
                  borderRadius: BorderRadius.circular(15)),
              duration: const Duration(milliseconds: 100),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.isBtnSelected ? whiteColor : widget.color,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        width: 2.5,
                        color: widget.isBtnSelected
                            ? whiteColor2
                            : widget.borderColor)),
                child: Center(
                  child: Text(
                    widget.letter,
                    style: widget.isBtnSelected
                        ? blackTextStyle.copyWith(
                            fontSize: 20, fontWeight: bold)
                        : whiteTextStyle.copyWith(
                            fontSize: 20, fontWeight: bold),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
