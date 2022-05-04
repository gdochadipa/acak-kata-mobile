import 'dart:async';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/offline_game_play_page.dart';
import 'package:acakkata/pages/in_game/old/prepare_game_page.dart';
import 'package:acakkata/pages/in_game/prepare_online_game_play.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animations/animations.dart';
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
    showDetailLevelPop() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            S? setLanguage = S.of(context);
            return Container(
              child: Dialog(
                insetAnimationCurve: Curves.easeInOut,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: SingleChildScrollView(
                  child: PopoverListView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.all(5),
                                child: Stack(
                                  children: [
                                    Align(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${levelModel!.level_name}',
                                            style: blackTextStyle.copyWith(
                                                fontSize: 21, fontWeight: bold),
                                          ),
                                          Text(
                                            (setLanguage.code == 'en'
                                                ? '${languageModel!.language_name_en}'
                                                : '${languageModel!.language_name_id}'),
                                            style: blackTextStyle.copyWith(
                                                fontSize: 14,
                                                fontWeight: medium),
                                          )
                                        ],
                                      ),
                                      alignment: Alignment.topLeft,
                                    ),
                                    Align(
                                      child: Text(
                                        '${levelModel!.current_score}/${levelModel!.target_score}',
                                        style: blackTextStyle.copyWith(
                                            fontSize: 16, fontWeight: semiBold),
                                      ),
                                      alignment: Alignment.topRight,
                                    ),
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  // border: Border.all(color: blackColor),
                                  color: backgroundColor8,
                                  borderRadius: BorderRadius.circular(5)),
                              child: SizedBox(
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: levelModel!.current_score!.toDouble() /
                                      levelModel!.target_score!.toDouble(),
                                  backgroundColor: grayColor2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(greenColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 25),
                        padding: EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: grayColor2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(7),
                                  margin: EdgeInsets.only(left: 5),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          'assets/images/words_icon.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 5, bottom: 5),
                                        child: Text(
                                          "${levelModel!.level_words}",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 20, fontWeight: bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 5, top: 5, right: 5),
                                        child: Text(
                                          "${setLanguage.letter}",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 12, fontWeight: medium),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 10),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          'assets/images/time_square_icon.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 5, bottom: 2),
                                        child: Text(
                                          "${levelModel!.level_time}",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 20, fontWeight: bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 5, top: 0, right: 5),
                                        child: Text(
                                          "${setLanguage.second_question}",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 10, fontWeight: medium),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.all(7),
                                  child: Wrap(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          'assets/images/edit_icon.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(left: 5, bottom: 5),
                                        child: Text(
                                          "${levelModel!.level_question_count}",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 20, fontWeight: bold),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 5, top: 5, right: 5),
                                        child: Text(
                                          "${setLanguage.question}",
                                          style: blackTextStyle.copyWith(
                                              fontSize: 13, fontWeight: medium),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                              child: ClickyButton(
                                  color: greenColor,
                                  shadowColor: greenAccentColor,
                                  width: 120,
                                  height: 60,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        '${setLanguage.play}',
                                        style: whiteTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/icon_play_white.png',
                                        height: 25,
                                        width: 25,
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    Timer(Duration(milliseconds: 500), () {
                                      Navigator.push(
                                          context,
                                          CustomPageRoute(OfflineGamePlayPage(
                                            languageModel: languageModel,
                                            selectedQuestion: levelModel!
                                                .level_question_count,
                                            selectedTime:
                                                levelModel!.level_time,
                                            isHost: 0,
                                            levelWords: levelModel!.level_words,
                                            isOnline: false,
                                            Stage: levelModel!.level_name,
                                            levelModel: levelModel,
                                            isCustom: false,
                                          )));
                                    });
                                  }),
                            )),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: Container(
                              child: ClickyButton(
                                  color: purpleColor,
                                  shadowColor: purpleAccentColor,
                                  width: 120,
                                  height: 60,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        '${setLanguage.challenge}',
                                        style: whiteTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/icon_group_white.png',
                                        height: 25,
                                        width: 25,
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    Timer(Duration(milliseconds: 500), () {
                                      Navigator.push(
                                          context,
                                          CustomPageRoute(PrepareOnlineGamePlay(
                                            languageModel: languageModel,
                                            selectedQuestion: levelModel!
                                                .level_question_count,
                                            selectedTime:
                                                levelModel!.level_time,
                                            isHost: 0,
                                            levelWords: levelModel!.level_words,
                                            isOnline: true,
                                            Stage: levelModel!.level_name,
                                            levelModel: levelModel,
                                            isCustom: false,
                                          )));
                                    });
                                  }),
                            ))
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            );
          });
    }

    return GestureDetector(
      onTap: levelModel!.is_unlock == 1
          ? () {
              // Navigator.push(
              //     context,
              //     CustomPageRoute(OfflineGamePlayPage(
              //       languageModel: languageModel,
              //       selectedQuestion: levelModel!.level_question_count,
              //       selectedTime: levelModel!.level_time,
              //       isHost: 0,
              //       levelWords: levelModel!.level_words,
              //       isOnline: false,
              //       Stage: levelModel!.level_name,
              //       levelModel: levelModel,
              //     )));

              showDetailLevelPop();
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(top: 13, bottom: 13, left: 10, right: 10),
        decoration: BoxDecoration(
            // border: Border.all(color: blackColor),
            boxShadow: [
              BoxShadow(
                  color: levelModel!.is_unlock == 0
                      ? disablePurpleAccentColor
                      : backgroundColorAccent8,
                  spreadRadius: 1,
                  blurRadius: 0,
                  blurStyle: BlurStyle.solid,
                  offset: Offset(-4, 4))
            ],
            color: levelModel!.is_unlock == 0
                ? disablePurpleColor
                : backgroundColor8,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Align(
                      child: Row(
                        children: [
                          if (levelModel!.is_unlock == 0)
                            Container(
                              child: Image.asset(
                                'assets/images/icon_password.png',
                                width: 36,
                                height: 18,
                              ),
                            ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${levelModel!.level_name}',
                            style: whiteTextStyle.copyWith(
                                fontSize: 21, fontWeight: bold),
                          )
                        ],
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Align(
                      child: Text(
                        '${levelModel!.current_score}/${levelModel!.target_score}',
                        style: whiteTextStyle.copyWith(
                            fontSize: 16, fontWeight: semiBold),
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  // border: Border.all(color: blackColor),
                  color: backgroundColor8,
                  borderRadius: BorderRadius.circular(5)),
              child: SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: levelModel!.current_score!.toDouble() /
                      levelModel!.target_score!.toDouble(),
                  backgroundColor: backgroundColor1,
                  valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
