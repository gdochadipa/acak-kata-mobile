import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/pages/dictionary/dict_detail_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DictItem extends StatefulWidget {
  final WordLanguageModel? wordLanguageModel;
  final LanguageModel? languageModel;

  const DictItem(
      {Key? key, required this.wordLanguageModel, required this.languageModel})
      : super(key: key);

  @override
  State<DictItem> createState() => _DictItemState();
}

class _DictItemState extends State<DictItem> {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CustomPageRoute(
              DictDetailPage(
                language: widget.languageModel,
                word: widget.wordLanguageModel,
              ),
            ));
      },
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
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
            color: whiteColor3, borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 5, color: whiteColor2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.wordLanguageModel!.word}",
                textAlign: TextAlign.left,
                style: blackTextStyle.copyWith(fontSize: 19, fontWeight: black),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${widget.wordLanguageModel!.word_hint}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    blackTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
