import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:flutter/material.dart';

class DictDetailPage extends StatefulWidget {
  final LanguageModel? language;
  final WordLanguageModel? word;
  const DictDetailPage({Key? key, required this.language, required this.word})
      : super(key: key);

  @override
  State<DictDetailPage> createState() => _DictDetailPageState();
}

class _DictDetailPageState extends State<DictDetailPage> {
  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);

    Widget header() {
      return AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 5, left: 5),
          child: ButtonBounce(
            onClick: () {
              Navigator.pop(context, true);
            },
            child: Center(
              child: Icon(
                Icons.arrow_back,
                color: whiteColor,
              ),
            ),
          ),
        ),
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.language!.language_name_en}'
                  : '${widget.language!.language_name_id}'),
              style: whiteTextStyle.copyWith(
                  fontWeight: extraBold, fontSize: 24, color: whiteColor),
            ),
          ],
        ),
        actions: [],
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(top: 80, left: 15, right: 15),
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, top: 5, bottom: 5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 5, color: whiteColor2),
                        boxShadow: [
                          BoxShadow(
                              color: whiteColor3, offset: const Offset(0, 4))
                        ]),
                    child: Center(
                      child: Text(
                        "${widget.word!.word}",
                        style: blackTextStyle.copyWith(
                            fontWeight: black, fontSize: 20),
                      ),
                    ),
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: primaryColor3,
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                "${widget.word!.word_hint}",
                style: whiteTextStyle.copyWith(fontSize: 16),
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: primaryColor5,
          body: ListView(
            children: [header(), body()],
          ),
        ),
        onWillPop: () async => false);
  }
}
