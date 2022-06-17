import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  late BuildContext _context;
  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (ctx) => const FullScreenLoader());
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  void hide() {
    Navigator.of(_context).pop();
  }

  LoadingOverlay._create(this._context);
  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child: Center(
          child: CircularProgressIndicator(color: whiteColor),
        ));
  }
}
