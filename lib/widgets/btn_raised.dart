import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
/**
 * 
 * Rencananya buat btn raised pake container sama gesture detector
 * gestur detector 
 * 
 */

class BtnRaised extends StatefulWidget {
  final VoidCallback onClick;

  const BtnRaised({Key? key, required this.onClick}) : super(key: key);

  @override
  State<BtnRaised> createState() => _BtnRaisedState();
}

class _BtnRaisedState extends State<BtnRaised>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    sizeAnimation =
        Tween<double>(begin: 100.0, end: 105).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor2,
          boxShadow: [
            BoxShadow(
                color: shadowBackgroundColor2,
                spreadRadius: 0,
                blurRadius: 0,
                offset: Offset(0, 4),
                blurStyle: BlurStyle.solid)
          ]),
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget.onClick();
          },
          child: Text(
            'Create Account',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "Netflix",
              fontWeight: FontWeight.w600,
              fontSize: 18,
              letterSpacing: 0.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
