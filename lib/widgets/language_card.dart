import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/level/level_list_page.dart';
import 'package:acakkata/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'custom_page_route.dart';

class LanguageCard extends StatefulWidget {
  // const LanguageCard({Key? key}) : super(key: key);
  final LanguageModel language;
  final VoidCallback onClick;
  LanguageCard({required this.language, required this.onClick});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
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
    S? setLanguage = S.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
          onTap: widget.onClick,
          onTapDown: (_) => setState(() {
                _padding = 0.0;
                _reversePadding = _heightShadow;
              }),
          onTapUp: (_) => setState(() {
                _padding = _heightShadow;
                _reversePadding = 0.0;
              }),
          child: AnimatedContainer(
            padding: EdgeInsets.only(bottom: _padding),
            margin: EdgeInsets.only(top: _reversePadding),
            decoration: BoxDecoration(
                color: primaryColor3, borderRadius: BorderRadius.circular(15)),
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.only(top: 13, bottom: 13, left: 10),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 5, color: primaryColor2)),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/${widget.language.language_icon}',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 10,
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
                          style: whiteTextStyle.copyWith(
                              fontWeight: bold, fontSize: 16),
                          presetFontSizes: const [18, 16],
                          maxLines: 2,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
