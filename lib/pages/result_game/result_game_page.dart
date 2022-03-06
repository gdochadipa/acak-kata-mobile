import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/in_game/game_play_page.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class ResultGamePage extends StatefulWidget {
  // const ResultGamePage({Key? key}) : super(key: key);
  late final LanguageModel? languageModel;
  late final int finalScore;

  ResultGamePage(this.languageModel, this.finalScore);
  @override
  _ResultGamePageState createState() => _ResultGamePageState();
}

class _ResultGamePageState extends State<ResultGamePage> {
  @override
  Widget build(BuildContext context) {
    Widget textHeader() {
      return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: backgroundColor4, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Column(
              children: [
                Text(
                  '${widget.languageModel?.language_name}',
                  style: blackTextStyle.copyWith(
                      fontSize: 15, fontWeight: semiBold),
                ),
              ],
            ),
          ));
    }

    Widget BacktoMenu() {
      return Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(top: 15),
        child: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            style: TextButton.styleFrom(
                backgroundColor: alertColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Back to Menu',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            )),
      );
    }

    Widget scoreMatch() {
      return Container(
        margin: EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Skor Permainan",
              style:
                  subtitleTextStyle.copyWith(fontSize: 14, fontWeight: regular),
            ),
            Text(
              "${widget.finalScore}",
              style:
                  blackTextStyle.copyWith(fontSize: 36, fontWeight: semiBold),
            ),
          ],
        ),
      );
    }

    Widget cardBody() {
      return Container(
        margin:
            EdgeInsets.only(top: 70, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor1, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            textHeader(),
            SizedBox(
              height: 30,
            ),
            Image.asset(
              'assets/images/trophy.png',
              width: 140,
              height: 167,
            ),
            scoreMatch(),
            SizedBox(
              height: 30,
            ),
            BacktoMenu()
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: backgroundColor2,
        body: Container(
          child: ListView(
            children: [cardBody()],
          ),
        ));
  }
}
