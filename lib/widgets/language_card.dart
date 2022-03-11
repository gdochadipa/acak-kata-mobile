import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/in_game/game_play_page.dart';
import 'package:acakkata/pages/in_game/prepare_game_page.dart';
import 'package:acakkata/pages/result_game/result_game_page.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

import 'custom_page_route.dart';

class LanguageCard extends StatelessWidget {
  // const LanguageCard({Key? key}) : super(key: key);
  late final LanguageModel language;
  LanguageCard(this.language);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, CustomPageRoute(PrepareGamePage(language)));
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
                child: Image.network(
                  language.language_icon ?? '',
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
                    '${language.language_name}',
                    style:
                        headerText3.copyWith(fontSize: 16, fontWeight: regular),
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
