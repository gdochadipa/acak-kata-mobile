import 'dart:async';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/offline_game_play_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';

class CustomMatchForm extends StatefulWidget {
  LanguageModel? languageModel;
  CustomMatchForm({Key? key, this.languageModel}) : super(key: key);

  @override
  State<CustomMatchForm> createState() => _CustomMatchFormState();
}

class _CustomMatchFormState extends State<CustomMatchForm> {
  TextEditingController questionNumber = TextEditingController(text: '');

  TextEditingController lengthWord = TextEditingController(text: '');

  TextEditingController questionTime = TextEditingController(text: '');

  Map<String, bool>? validation = {};

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
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
              languageModel: widget.languageModel,
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

    return Dialog(
      insetAnimationCurve: Curves.easeInOut,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: SingleChildScrollView(
        child: PopoverListView(
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(setLanguage.custom_level,
                          textAlign: TextAlign.left,
                          style: whiteTextStyle.copyWith(
                            fontSize: 24,
                            fontWeight: bold,
                          )),
                      const SizedBox(
                        height: 1.85,
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
                                fontSize: 14, fontWeight: bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setLanguage.question_count,
                        textAlign: TextAlign.left,
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false, signed: false),
                                controller: questionNumber,
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return setLanguage.question_number;
                                  }
                                  if (!(double.parse(text) >= 5)) {
                                    return setLanguage
                                        .question_number_error_min;
                                  }
                                  if (!(double.parse(text) <= 25)) {
                                    return setLanguage
                                        .question_number_error_max;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration.collapsed(
                                    hintText: setLanguage.question_count,
                                    hintStyle: whiteTextStyle),
                              ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setLanguage.word_length,
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                              controller: lengthWord,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return setLanguage.word_length_form;
                                }
                                if (!(double.parse(text) >= 3)) {
                                  return setLanguage.word_length_form_error_min;
                                }
                                if (!(double.parse(text) <= 10)) {
                                  return setLanguage.word_length_form_error_max;
                                }
                                return null;
                              },
                              decoration: InputDecoration.collapsed(
                                  hintText: setLanguage.word_length,
                                  hintStyle: whiteTextStyle),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${setLanguage.time} (${setLanguage.second})',
                        textAlign: TextAlign.left,
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: semiBold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                controller: questionTime,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false, signed: false),
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return setLanguage.question_time;
                                  }
                                  if (!(double.parse(text) >= 7)) {
                                    return setLanguage.question_time_error_min;
                                  }
                                  if (!(double.parse(text) <= 30)) {
                                    return setLanguage.question_time_error_max;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration.collapsed(
                                    hintText:
                                        '${setLanguage.time} (${setLanguage.second})',
                                    hintStyle: whiteTextStyle),
                              ))
                            ],
                          ),
                        ),
                      )
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
                                Timer(const Duration(milliseconds: 500), () {
                                  _saveForm();
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
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Image.asset(
                                      'assets/images/icon_group_white.png',
                                      height: 25,
                                      width: 25,
                                    ),
                                  )
                                ],
                              ),
                              onClick: () {}))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
