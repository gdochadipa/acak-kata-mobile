import 'package:acakkata/models/coordinate.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class AnswerShowButton extends StatefulWidget {
  final String letter;
  final bool isBtnSelected;
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final double height;
  final double width;
  const AnswerShowButton(
      {Key? key,
      this.height = 40,
      this.width = 40,
      required this.color,
      required this.borderColor,
      required this.shadowColor,
      required this.letter,
      required this.isBtnSelected})
      : super(key: key);

  @override
  State<AnswerShowButton> createState() => _AnswerShowButtonState();
}

class _AnswerShowButtonState extends State<AnswerShowButton> {
  double _padding = 6;
  double _reversePadding = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      height: widget.height,
      width: widget.width,
      child: AnimatedContainer(
        padding: EdgeInsets.only(bottom: _padding),
        margin: EdgeInsets.only(top: _reversePadding),
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
            color: widget.isBtnSelected ? whiteColor3 : widget.shadowColor,
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          decoration: BoxDecoration(
              color: widget.isBtnSelected ? whiteColor : widget.color,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  width: 2.5,
                  color:
                      widget.isBtnSelected ? whiteColor2 : widget.borderColor)),
          child: Center(
            child: Text(
              widget.letter,
              style: widget.isBtnSelected
                  ? blackTextStyle.copyWith(fontSize: 20, fontWeight: bold)
                  : whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold),
            ),
          ),
        ),
      ),
    );
  }
}
