import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget widget;

  CustomPageRoute(this.widget)
      : super(
            transitionDuration: Duration(milliseconds: 500),
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
              var begin = Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            });
}
