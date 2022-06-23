import 'dart:async';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/offline_game_play_page.dart';
import 'package:acakkata/pages/in_game/prepare_online_game_play.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class ItemLevelCard extends StatefulWidget {
  // const ItemLevelCard({
  //   Key? key,
  // }) : super(key: key);
  late final LevelModel? levelModel;
  late final LanguageModel? languageModel;
  ItemLevelCard({required this.levelModel, required this.languageModel});

  @override
  State<ItemLevelCard> createState() => _ItemLevelCardState();
}

class _ItemLevelCardState extends State<ItemLevelCard> {
  double _padding = 10;
  double _reversePadding = 0;
  double _heightShadow = 10;

  @override
  void initState() {
    // TODO: implement initState
    _padding = _heightShadow;
    _reversePadding = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDetailLevelPop() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            S? setLanguage = S.of(context);
            return Dialog(
              insetAnimationCurve: Curves.easeInOut,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              child: SingleChildScrollView(
                child: PopoverListView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(5),
                              child: Stack(
                                children: [
                                  Align(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.levelModel!.level_name}',
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 21, fontWeight: bold),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/${widget.languageModel!.language_icon}',
                                              width: 30,
                                              height: 30,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              (setLanguage.code == 'en'
                                                  ? '${widget.languageModel!.language_name_en}'
                                                  : '${widget.languageModel!.language_name_id}'),
                                              style: whiteTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: bold),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                  // Align(
                                  //   child: Text(
                                  //     '${widget.levelModel!.current_score}/${widget.levelModel!.target_score}',
                                  //     style: blackTextStyle.copyWith(
                                  //         fontSize: 16, fontWeight: semiBold),
                                  //   ),
                                  //   alignment: Alignment.bottomRight,
                                  // ),
                                ],
                              )),
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                // border: Border.all(color: blackColor),
                                color: backgroundColor8,
                                borderRadius: BorderRadius.circular(5)),
                            child: SizedBox(
                              height: 10,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: LinearProgressIndicator(
                                  value: widget.levelModel!.current_score!
                                          .toDouble() /
                                      widget.levelModel!.target_score!
                                          .toDouble(),
                                  backgroundColor: grayColor4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      primaryColor4),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8, top: 25),
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: primaryColor5,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 20),
                                    margin: const EdgeInsets.only(left: 5),
                                    child: Wrap(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_kata.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: Text(
                                            "${widget.levelModel!.level_words}",
                                            style: whiteTextStyle.copyWith(
                                                fontSize: 21, fontWeight: bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 50,
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 5, right: 5),
                                    child: Center(
                                      child: Text(
                                        setLanguage.letter,
                                        style: blackTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: primaryColor5,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 20),
                                    child: Wrap(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_time.png',
                                          width: 25,
                                          height: 25,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, bottom: 2),
                                          child: Text(
                                            "${widget.levelModel!.level_time}",
                                            style: whiteTextStyle.copyWith(
                                                fontSize: 20, fontWeight: bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 50,
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 0, right: 5),
                                    child: Center(
                                      child: Text(
                                        setLanguage.second_question,
                                        style: blackTextStyle.copyWith(
                                            fontSize: 13, fontWeight: bold),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: primaryColor5,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 20),
                                    child: Wrap(
                                      children: [
                                        Image.asset(
                                          'assets/images/icon_pencil.png',
                                          width: 30,
                                          height: 30,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, bottom: 5),
                                          child: Text(
                                            "${widget.levelModel!.level_question_count}",
                                            style: whiteTextStyle.copyWith(
                                                fontSize: 20, fontWeight: bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 50,
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 5, right: 5),
                                    child: Center(
                                      child: Text(
                                        setLanguage.question,
                                        style: blackTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: ButtonBounce(
                                  color: greenColor,
                                  borderColor: greenColor2,
                                  shadowColor: greenColor3,
                                  heightButton: 60,
                                  widthButton: 150,
                                  child: Center(
                                    child: Wrap(
                                      children: [
                                        Text(
                                          setLanguage.play,
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 16, fontWeight: bold),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          'assets/images/icon_play_white.png',
                                          height: 25,
                                          width: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                  onClick: () {
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      Navigator.push(
                                          context,
                                          CustomPageRoute(OfflineGamePlayPage(
                                            languageModel: widget.languageModel,
                                            selectedQuestion: widget.levelModel!
                                                .level_question_count,
                                            selectedTime:
                                                widget.levelModel!.level_time,
                                            isHost: 0,
                                            levelWords:
                                                widget.levelModel!.level_words,
                                            isOnline: false,
                                            Stage:
                                                widget.levelModel!.level_name,
                                            levelModel: widget.levelModel,
                                            isCustom: false,
                                          )));
                                    });
                                  })),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              child: ButtonBounce(
                                  color: primaryColor,
                                  borderColor: primaryColor2,
                                  shadowColor: primaryColor3,
                                  heightButton: 60,
                                  widthButton: 150,
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          setLanguage.challenge,
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 16, fontWeight: bold),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Image.asset(
                                          'assets/images/icon_group_white.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  onClick: () {
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      Navigator.push(
                                          context,
                                          CustomPageRoute(PrepareOnlineGamePlay(
                                            languageModel: widget.languageModel,
                                            selectedQuestion: widget.levelModel!
                                                .level_question_count,
                                            selectedTime:
                                                widget.levelModel!.level_time,
                                            isHost: 0,
                                            levelWords:
                                                widget.levelModel!.level_words,
                                            isOnline: true,
                                            Stage:
                                                widget.levelModel!.level_name,
                                            levelModel: widget.levelModel,
                                            isCustom: false,
                                          )));
                                    });
                                  }))
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            );
          });
    }

    return Container(
      child: GestureDetector(
          onTap: widget.levelModel!.is_unlock == 1
              ? () {
                  showDetailLevelPop();
                }
              : null,
          onTapDown: (_) => setState(() {
                if (widget.levelModel!.is_unlock == 1) {
                  _padding = 0.0;
                  _reversePadding = _heightShadow;
                }
              }),
          onTapUp: (_) => setState(() {
                if (widget.levelModel!.is_unlock == 1) {
                  _padding = _heightShadow;
                  _reversePadding = 0.0;
                }
              }),
          child: AnimatedContainer(
            padding: EdgeInsets.only(bottom: _padding),
            margin: EdgeInsets.only(top: _reversePadding),
            decoration: BoxDecoration(
                color: whiteColor3, borderRadius: BorderRadius.circular(15)),
            duration: const Duration(milliseconds: 100),
            child: Container(
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 5, color: whiteColor2)),
              child: Column(
                children: [
                  widget.levelModel!.is_unlock == 0
                      ? Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Center(
                            child: Image.asset(
                              'assets/images/icon_lock.png',
                              width: 45,
                              height: 45,
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Center(
                            child: Image.asset(
                              'assets/images/star.png',
                              width: 45,
                              height: 45,
                            ),
                          ),
                        ),
                  Center(
                    child: Text(
                      widget.levelModel!.level_name.toString(),
                      style: blackTextStyle.copyWith(
                          fontSize: 18, fontWeight: extraBold),
                    ),
                  ),
                  if (widget.levelModel!.is_unlock == 1)
                    Container(
                      margin: const EdgeInsets.only(top: 5, right: 8, left: 8),
                      decoration: BoxDecoration(
                          // border: Border.all(color: blackColor),
                          color: backgroundColor8,
                          borderRadius: BorderRadius.circular(5)),
                      child: SizedBox(
                        height: 8,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            value:
                                widget.levelModel!.current_score!.toDouble() /
                                    widget.levelModel!.target_score!.toDouble(),
                            backgroundColor: grayColor4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor4),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )),
    );
  }
}
