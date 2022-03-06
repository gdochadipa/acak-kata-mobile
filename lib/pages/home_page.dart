import 'dart:developer';

import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/language_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  late final LanguageDBProvider _langProvider;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<LanguageModel>? listLanguageModel = [
    LanguageModel(
        id: '1',
        language_code: "english",
        language_icon: "en_lang.png",
        language_name: "Bahasa Inggris",
        language_collection: "Bahasa Inggris"),
    LanguageModel(
        id: '2',
        language_code: "indonesia",
        language_icon: "id_lang.png",
        language_name: "Bahasa Indonesia",
        language_collection: "Bahasa Indonesia"),
    LanguageModel(
        id: '3',
        language_code: "bali",
        language_icon: "bali_lang.png",
        language_name: "Bahasa Bali",
        language_collection: "Bahasa Bali"),
    LanguageModel(
        id: '4',
        language_code: "java",
        language_icon: "java_lang.png",
        language_name: "Bahasa Jawa",
        language_collection: "Bahasa Jawa"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    getInit();
    super.initState();
  }

  getInit() async {
    LanguageDBProvider langProvider =
        Provider.of<LanguageDBProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    widget._langProvider = langProvider;
    if (await langProvider.getWords("english")) {
      setState(() {
        isLoading = false;
      });
    } else {
      log("gagal get db words");
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<EnglishLanguageModel>? englishWords = langProvider.englishWordList;

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30, left: 15, right: 15),
        padding: EdgeInsets.only(left: 15, right: 8, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: backgroundColor6, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/bali_lang.png',
                      width: 25,
                      height: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Achievement',
                        style: headerText3.copyWith(
                            fontSize: 16, fontWeight: medium),
                      ),
                      Text(
                        'Base Bali',
                        style: thirdTextStyle.copyWith(
                            fontSize: 11,
                            fontWeight: medium,
                            color: grayColor3),
                      ),
                      Text(
                        '3 out 4 games',
                        style: thirdTextStyle.copyWith(
                            fontSize: 12, fontWeight: light),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: LinearProgressIndicator(
                  value: 3 / 4,
                  backgroundColor: backgroundColor5,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget cardBody() {
      if (!isLoading) {
        return Container(
          margin: EdgeInsets.only(top: 20, left: 15, right: 15),
          padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "List Bahasa",
                style: headerText2.copyWith(fontWeight: regular, fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  children:
                      listLanguageModel!.map((e) => LanguageCard(e)).toList(),
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(
              top: 50, left: defaultMargin, right: defaultMargin),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: backgroundColor3, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [CircularProgressIndicator(), Text("Loading")],
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Container(
        child: ListView(
          children: [header(), cardBody()],
        ),
      ),
    );
  }
}
