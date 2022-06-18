import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/level/level_list_page.dart';
import 'package:acakkata/theme.dart';
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
                    offset: const Offset(-4, 4))
              ]),
          child: Row(
            children: [
              Container(
                height: 61,
                width: 63.44,
                padding: const EdgeInsets.all(10),
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
                      presetFontSizes: const [18, 16],
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
