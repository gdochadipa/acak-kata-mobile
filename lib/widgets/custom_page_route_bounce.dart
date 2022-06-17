import 'package:flutter/material.dart';

class CustomPageRouteBounce extends PageRouteBuilder {
  final Widget widget;
  final Duration duration;
  CustomPageRouteBounce(
      {required this.widget,
      this.duration = const Duration(microseconds: 2000)})
      : super(
            transitionDuration: const Duration(milliseconds: 2000),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                widget,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              var begin = const Offset(0.0, -1.0);
              var end = Offset.zero;
              var curve = Curves.elasticInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            });
}
