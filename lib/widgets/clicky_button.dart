import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Issue:
/// width masih mentok di 200, coba di set agar lebih dari 200
class ClickyButton extends StatefulWidget {
  final Duration _duration = const Duration(milliseconds: 70);
  final Widget child;
  final Color color;
  final Color shadowColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final GestureTapCallback onPressed;

  const ClickyButton({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.all(0),
    this.color = Colors.deepPurple,
    this.shadowColor = Colors.deepPurpleAccent,
    this.width = 200.0,
    this.height = 70.0,
    required this.onPressed,
  })  : super(key: key);

  @override
  State<ClickyButton> createState() => _ClickyButtonState();
}

class _ClickyButtonState extends State<ClickyButton> {
  double _faceLeft = 5.0; //perubahan jarak shadow
  double _faceTop = 0.0;
  final double _faceRight = 5.0;
  final double _faceBottom = 0.0;
  double _sideWidth = 5.0; //perubahan jarak shadow
  double _bottomHeight = 5.0; //perubahan jarak shadow
  final Curve _curve = Curves.ease;
  double shadowRangeHeight = 70;

  @override
  Widget build(BuildContext context) {
    shadowRangeHeight = (70 - widget.height!) / 2;
    return Container(
      width: widget.width! + 5,
      height: widget.height,
      margin: widget.margin,
      child: GestureDetector(
        child: Stack(
          children: [
            // on left
            Positioned(
              child: Transform(
                origin: const Offset(5, 0), //perubahan jarak shadow
                transform: Matrix4.skewY(-0.79),
                child: AnimatedContainer(
                  duration: widget._duration,
                  curve: _curve,
                  width: _sideWidth,
                  height: widget.height! - 10,
                  color: widget.shadowColor,
                ),
              ),
              top: 0.2,
            ),
            // on rigth
            Positioned(
              child: Transform(
                transform: Matrix4.skewX(-0.8),
                child: Transform(
                  origin: Offset((widget.width! / 2) - shadowRangeHeight,
                      10 - shadowRangeHeight),
                  transform: Matrix4.rotationZ(math.pi),
                  child: AnimatedContainer(
                    duration: widget._duration,
                    curve: _curve,
                    width: widget.width,
                    height: _bottomHeight,
                    color: widget.shadowColor,
                  ),
                ),
              ),
              top: 45.0, //perubahan jarak shadow
              left: 20.1,
            ),
            AnimatedPositioned(
              child: Container(
                alignment: Alignment.center,
                width: widget.width,
                height: widget.height! - 10,
                decoration: BoxDecoration(
                    color: widget.color,
                    border: Border.all(color: widget.shadowColor, width: 1)),
                child: widget.child,
              ),
              duration: widget._duration,
              curve: _curve,
              left: _faceLeft,
              top: _faceTop,
            )
          ],
        ),
        onTapDown: _pressed,
        onTapUp: _unPressedOnTapUp,
        onTapCancel: _unPressed,
      ),
    );
  }

  void _pressed(_) {
    setState(() {
      _faceLeft = 0.0;
      _faceTop = 5.0; //perubahan jarak shadow
      _sideWidth = 0.0;
      _bottomHeight = 0.0;
    });
    Timer timer = Timer(const Duration(milliseconds: 90), () {
      widget.onPressed();
    });
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() {
      _faceLeft = 5.0; //perubahan jarak shadow
      _faceTop = 0.0;
      _sideWidth = 5.0; //perubahan jarak shadow
      _bottomHeight = 5.0; //perubahan jarak shadow
    });
  }
}
