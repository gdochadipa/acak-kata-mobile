import 'package:flutter/material.dart';

class CircleBounceButton extends StatefulWidget {
  final Widget child;
  final double heightShadow;
  final double borderThick;
  final double heightButton;
  final double widthButton;
  final double paddingVerticalButton;
  final double paddingHorizontalButton;
  final GestureTapCallback onClick;
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final EdgeInsetsGeometry margin;

  const CircleBounceButton(
      {Key? key,
      this.heightShadow = 6.0,
      this.borderThick = 4,
      this.heightButton = 50,
      this.widthButton = 50,
      this.paddingVerticalButton = 5,
      this.paddingHorizontalButton = 5,
      this.margin = const EdgeInsets.all(0),
      required this.onClick,
      required this.child,
      this.color = const Color(0xff8B62FF),
      this.borderColor = const Color(0xff5833BF),
      this.shadowColor = const Color(0xff4F349E)})
      : super(key: key);

  @override
  State<CircleBounceButton> createState() => _CircleBounceButtonState();
}

class _CircleBounceButtonState extends State<CircleBounceButton> {
  double _padding = 6;
  double _reversePadding = 0;

  @override
  void initState() {
    // TODO: implement initState
    _padding = widget.heightShadow;
    _reversePadding = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: SizedBox(
        height: widget.heightButton,
        child: GestureDetector(
          onTap: widget.onClick,
          onTapDown: (_) => setState(() {
            _padding = 0.0;
            _reversePadding = widget.heightShadow;
          }),
          onTapUp: (_) => setState(() {
            _padding = widget.heightShadow;
            _reversePadding = 0.0;
          }),
          child: AnimatedContainer(
            padding: EdgeInsets.only(bottom: _padding),
            margin: EdgeInsets.only(top: _reversePadding),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: widget.shadowColor),
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: widget.paddingVerticalButton,
                  horizontal: widget.paddingHorizontalButton),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  border: Border.all(
                      width: widget.borderThick, color: widget.borderColor)),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
