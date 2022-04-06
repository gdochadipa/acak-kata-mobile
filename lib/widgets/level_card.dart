import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/offline_game_play_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';

class ItemLevelCard extends StatelessWidget {
  // const ItemLevelCard({
  //   Key? key,
  // }) : super(key: key);
  late final LevelModel? levelModel;
  late final LanguageModel? languageModel;
  ItemLevelCard({required this.levelModel, required this.languageModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(OfflineGamePlayPage(
              languageModel: languageModel,
              selectedQuestion: levelModel!.level_question_count,
              selectedTime: levelModel!.level_time,
              isHost: 0,
              levelWords: levelModel!.level_words,
              isOnline: false,
            )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(top: 13, bottom: 13, left: 10, right: 10),
        decoration: BoxDecoration(
            // border: Border.all(color: blackColor),
            boxShadow: [
              BoxShadow(
                  color: backgroundColorAccent8,
                  spreadRadius: 1,
                  blurRadius: 0,
                  blurStyle: BlurStyle.solid,
                  offset: Offset(-4, 4))
            ], color: backgroundColor8, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Align(
                      child: Text(
                        '${levelModel!.level_name}',
                        style: whiteTextStyle.copyWith(
                            fontSize: 21, fontWeight: bold),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Align(
                      child: Text(
                        '120/240 XP',
                        style: whiteTextStyle.copyWith(
                            fontSize: 16, fontWeight: medium),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.all(5),
              child: LinearProgressIndicator(
                value: 3 / 4,
                backgroundColor: backgroundColor1,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            )
            // Text(
            //   'Soal()  Huruf(${levelModel!.level_words})  Waktu(${levelModel!.level_time})',
            //   style: thirdTextStyle.copyWith(
            //       fontSize: 14, color: grayColor3, fontWeight: light),
            // ),
          ],
        ),
      ),
    );
  }
}
