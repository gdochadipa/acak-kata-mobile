import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/in_game/old/game_play_page.dart';
import 'package:acakkata/pages/in_game/old/prepare_game_page.dart';
import 'package:acakkata/pages/level/level_list_page.dart';
import 'package:acakkata/pages/result_game/result_game_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route_bounce.dart';
import 'package:acakkata/widgets/popover.dart';
import 'package:acakkata/widgets/widget_popover/list_item_pop_over.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'custom_page_route.dart';

class LanguageCard extends StatefulWidget {
  // const LanguageCard({Key? key}) : super(key: key);
  late final LanguageModel language;
  LanguageCard(this.language);

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);

    return GestureDetector(
        onTap: () {
          // Navigator.push(context, CustomPageRoute(PrepareGamePage(language)));
          // handlePopUpPress();
          // Navigator.push(
          //     context,
          //     CustomPageRoute(LevelListPage(
          //       languageModel: language,
          //     )));

          Navigator.pushAndRemoveUntil(
              context,
              CustomPageRoute(
                LevelListPage(
                  isOnline: false,
                  languageModel: widget.language,
                ),
              ),
              (route) => false);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.only(top: 13, bottom: 13, left: 10),
          decoration: BoxDecoration(
              color: backgroundColor8,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: backgroundColorAccent8,
                    spreadRadius: 1,
                    blurRadius: 0,
                    blurStyle: BlurStyle.solid,
                    offset: Offset(-4, 4))
              ]),
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
                  'assets/images/${widget.language.language_icon}',
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
                  FittedBox(
                    fit: BoxFit.contain,
                    child: AutoSizeText(
                      (setLanguage.code == 'en'
                          ? '${widget.language.language_name_en}'
                          : '${widget.language.language_name_id}'),
                      style: whiteTextStyle.copyWith(fontWeight: bold),
                      presetFontSizes: [18, 16],
                      maxLines: 2,
                    ),
                  ),

                  // Text(
                  //   '${language.language_collection}',
                  //   style: thirdTextStyle.copyWith(
                  //       fontSize: 12, color: grayColor3, fontWeight: light),
                  // ),
                  // Container(
                  //   height: 17.7,
                  //   margin: EdgeInsets.only(top: 5),
                  //   width: 49,
                  //   decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         colors: [firstLinierColor, thirdLinierColor],
                  //         begin: Alignment.bottomLeft,
                  //         end: Alignment.bottomRight,
                  //         stops: [0.0, 1.0],
                  //       ),
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: Row(
                  //     children: [
                  //       Image.asset(
                  //         'assets/images/arrow.png',
                  //         width: 15,
                  //         height: 15,
                  //       ),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       Text(
                  //         'Play',
                  //         style: thirdTextStyle.copyWith(
                  //             fontSize: 9,
                  //             color: whiteColor,
                  //             fontWeight: light),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ));
  }
}
