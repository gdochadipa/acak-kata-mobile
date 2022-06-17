import 'package:flutter/material.dart';

class ButtonBounce extends StatefulWidget {
  final Widget child;
  final double heightShadow;
  final double borderThick;
  final double heightButton;
  final GestureTapCallback onClick;

  const ButtonBounce(
      {Key? key,
      this.heightShadow = 6.0,
      this.borderThick = 2.5,
      this.heightButton = 50,
      required this.onClick,
      required this.child})
      : super(key: key);

  @override
  State<ButtonBounce> createState() => _ButtonBounceState();
}

class _ButtonBounceState extends State<ButtonBounce> {
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
                color: const Color(0xFF4F349E),
                borderRadius: BorderRadius.circular(10)),
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: const Color(0xFF8B62FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: widget.borderThick,
                      color: const Color(0xFF4F349E))),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
