import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class FooterGamePlayPage extends StatelessWidget {
  const FooterGamePlayPage(
      {Key? key, required this.scoreCount, required this.stage})
      : super(key: key);

  final int scoreCount;
  final String stage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: backgroundColor1),
      child: Center(
        child: Row(
          children: [
            Flexible(
                child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(2),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: blackColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "$scoreCount",
                    style:
                        whiteTextStyle.copyWith(fontSize: 20, fontWeight: bold),
                  )),
            )),
            const SizedBox(
              width: 20,
            ),
            Flexible(
                child: Container(
              margin: const EdgeInsets.all(5),
              alignment: Alignment.centerRight,
              child: Text(
                stage,
                style: blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
