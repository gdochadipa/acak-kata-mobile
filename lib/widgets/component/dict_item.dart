import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DictItem extends StatefulWidget {
  final WordLanguageModel? wordLanguageModel;

  const DictItem({Key? key, required this.wordLanguageModel}) : super(key: key);

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
      onTap: () {},
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
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 5, color: whiteColor2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${widget.wordLanguageModel!.word}",
                textAlign: TextAlign.left,
                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: black),
              ),
              const SizedBox(
                height: 10,
              ),
              AutoSizeText(
                "${widget.wordLanguageModel!.word_hint}",
                maxLines: 3,
                style:
                    blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
