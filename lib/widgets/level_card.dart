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
                levelWords: levelModel!.level_words)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(top: 13, bottom: 13, left: 10),
        decoration: BoxDecoration(
            color: backgroundColor6, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
              height: 61,
              width: 63.44,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                'assets/images/${languageModel!.language_icon}',
                width: 36,
                height: 18,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${levelModel!.level_name}',
                  style:
                      headerText3.copyWith(fontSize: 18, fontWeight: regular),
                ),
                Text(
                  'Soal(${levelModel!.level_question_count})  Huruf(${levelModel!.level_words})  Waktu(${levelModel!.level_time})',
                  style: thirdTextStyle.copyWith(
                      fontSize: 14, color: grayColor3, fontWeight: light),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
