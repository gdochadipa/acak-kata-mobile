import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/theme.dart';
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
      onTap: () {},
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
                fit: BoxFit.cover,
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
                      headerText3.copyWith(fontSize: 16, fontWeight: regular),
                ),
                Text(
                  '${languageModel!.language_collection}',
                  style: thirdTextStyle.copyWith(
                      fontSize: 12, color: grayColor3, fontWeight: light),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
