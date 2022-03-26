import 'package:acakkata/callbacks/CheckingWordCallback.dart';
import 'package:flutter/material.dart';

class InputTest extends StatefulWidget {
  const InputTest(
      {Key? key,
      required String letter,
      required bool isBtnSelected,
      required CheckingLetterCallback onSelectButtonLetter})
      : super(key: key);

  @override
  State<InputTest> createState() => _InputTestState();
}

class _InputTestState extends State<InputTest> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
