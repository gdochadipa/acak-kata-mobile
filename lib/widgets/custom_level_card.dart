import 'dart:async';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/offline_game_play_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class CustomLevelCard extends StatelessWidget {
  late final LanguageModel? languageModel;
  final bool isLogin;
  CustomLevelCard(
      {Key? key, required this.languageModel, required this.isLogin})
      : super(key: key);

  // CustomLevelCard({required this.languageModel});

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    showCustomFormLevelPop() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            TextEditingController questionNumber =
                TextEditingController(text: '');
            TextEditingController lengthWord = TextEditingController(text: '');
            TextEditingController questionTime =
                TextEditingController(text: '');
            final _form = GlobalKey<FormState>();

            void _saveForm() {
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              } else {
                LevelModel levelModel = LevelModel(
                    id: 77,
                    level_name: setLanguage.custom_level,
                    level_words: int.parse(lengthWord.text),
                    level_time: int.parse(questionTime.text),
                    level_lang_code: setLanguage.code,
                    level_lang_id: setLanguage.code,
                    current_score: 0,
                    target_score: 0);
                Navigator.push(
                    context,
                    CustomPageRoute(OfflineGamePlayPage(
                      languageModel: languageModel,
                      selectedQuestion: int.parse(questionNumber.text),
                      selectedTime: int.parse(questionTime.text),
                      isHost: 0,
                      levelWords: int.parse(lengthWord.text),
                      isOnline: false,
                      Stage: setLanguage.custom_level,
                      levelModel: levelModel,
                      isCustom: true,
                    )));
              }
            }

            void _saveFormOnlineMode() {
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              } else {
                if (!isLogin) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      setLanguage.login_first,
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: alertColor,
                  ));
                } else {
                  LevelModel levelModel = LevelModel(
                      id: 77,
                      level_name: setLanguage.custom_level,
                      level_words: int.parse(lengthWord.text),
                      level_time: int.parse(questionTime.text),
                      level_lang_code: setLanguage.code,
                      level_lang_id: setLanguage.code,
                      current_score: 0,
                      target_score: 0);
                  Navigator.push(
                      context,
                      CustomPageRoute(OfflineGamePlayPage(
                        languageModel: languageModel,
                        selectedQuestion: int.parse(questionNumber.text),
                        selectedTime: int.parse(questionTime.text),
                        isHost: 0,
                        levelWords: int.parse(lengthWord.text),
                        isOnline: true,
                        Stage: setLanguage.custom_level,
                        levelModel: levelModel,
                        isCustom: true,
                      )));
                }
              }
            }

            return Container(
              child: Dialog(
                insetAnimationCurve: Curves.easeInOut,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: SingleChildScrollView(
                  child: PopoverListView(
                    child: Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(setLanguage.custom_level,
                                    textAlign: TextAlign.left,
                                    style: blackTextStyle.copyWith(
                                      fontSize: 24,
                                      fontWeight: bold,
                                    )),
                                const SizedBox(
                                  height: 1.85,
                                ),
                                Text("${languageModel!.language_name_en}",
                                    textAlign: TextAlign.left,
                                    style: blackTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: medium,
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  setLanguage.question_count,
                                  textAlign: TextAlign.left,
                                  style: blackTextStyle.copyWith(
                                      fontSize: 17, fontWeight: semiBold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: blackColor),
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextFormField(
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              decimal: false, signed: false),
                                          controller: questionNumber,
                                          validator: (text) {
                                            if (text!.isEmpty) {
                                              return setLanguage
                                                  .question_number;
                                            }
                                            if (!(double.parse(text) >= 5)) {
                                              return setLanguage
                                                  .question_number_error_min;
                                            }
                                            if (!(double.parse(text) <= 15)) {
                                              return setLanguage
                                                  .question_number_error_max;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration.collapsed(
                                              hintText:
                                                  setLanguage.question_count,
                                              hintStyle: subtitleTextStyle),
                                        ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  setLanguage.word_length,
                                  style: blackTextStyle.copyWith(
                                      fontSize: 17, fontWeight: semiBold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: blackColor),
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        controller: lengthWord,
                                        keyboardType: const TextInputType
                                                .numberWithOptions(
                                            decimal: false, signed: false),
                                        validator: (text) {
                                          if (text!.isEmpty) {
                                            return setLanguage.word_length_form;
                                          }
                                          if (!(double.parse(text) >= 3)) {
                                            return setLanguage
                                                .word_length_form_error_min;
                                          }
                                          if (!(double.parse(text) <= 10)) {
                                            return setLanguage
                                                .word_length_form_error_max;
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration.collapsed(
                                            hintText: setLanguage.word_length,
                                            hintStyle: subtitleTextStyle),
                                      ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${setLanguage.time} (${setLanguage.second})',
                                  textAlign: TextAlign.left,
                                  style: blackTextStyle.copyWith(
                                      fontSize: 17, fontWeight: semiBold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: blackColor),
                                      color: whiteColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: TextFormField(
                                          controller: questionTime,
                                          keyboardType: const TextInputType
                                                  .numberWithOptions(
                                              decimal: false, signed: false),
                                          validator: (text) {
                                            if (text!.isEmpty) {
                                              return setLanguage.question_time;
                                            }
                                            if (!(double.parse(text) >= 7)) {
                                              return setLanguage
                                                  .question_time_error_min;
                                            }
                                            if (!(double.parse(text) <= 30)) {
                                              return setLanguage
                                                  .question_time_error_max;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration.collapsed(
                                              hintText:
                                                  '${setLanguage.time} (${setLanguage.second})',
                                              hintStyle: subtitleTextStyle),
                                        ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 30),
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
                                            setLanguage.play,
                                            style: whiteTextStyle.copyWith(
                                                fontSize: 14, fontWeight: bold),
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
                                      onPressed: () {
                                        Timer(const Duration(milliseconds: 500),
                                            () {
                                          _saveForm();
                                        });
                                      }),
                                )),
                                const SizedBox(
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
                                            setLanguage.challenge,
                                            style: whiteTextStyle.copyWith(
                                                fontSize: 14, fontWeight: bold),
                                          ),
                                          const SizedBox(
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
                                        Timer(const Duration(milliseconds: 500),
                                            () {
                                          _saveFormOnlineMode();
                                        });
                                      }),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    }

    return GestureDetector(
      onTap: () {
        showCustomFormLevelPop();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding:
            const EdgeInsets.only(top: 13, bottom: 13, left: 10, right: 10),
        decoration: BoxDecoration(
            // border: Border.all(color: blackColor),
            boxShadow: [
              BoxShadow(
                  color: backgroundColorAccent8,
                  spreadRadius: 1,
                  blurRadius: 0,
                  blurStyle: BlurStyle.solid,
                  offset: const Offset(-4, 4))
            ], color: backgroundColor8, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Align(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            setLanguage.custom_level,
                            style: whiteTextStyle.copyWith(
                                fontSize: 21, fontWeight: bold),
                          )
                        ],
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
