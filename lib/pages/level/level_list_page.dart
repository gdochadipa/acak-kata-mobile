import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/level_card.dart';
import 'package:acakkata/widgets/skeleton/level_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class LevelListPage extends StatefulWidget {
  // const LevelListPage({Key? key}) : super(key: key);

  late LanguageModel languageModel;
  late bool isOnline;

  LevelListPage({Key? key, required this.languageModel, required this.isOnline})
      : super(key: key);

  @override
  State<LevelListPage> createState() => _LevelListPageState();
}

class _LevelListPageState extends State<LevelListPage> {
  bool isLoading = false;
  late LanguageDBProvider? languageDBProvider =
      Provider.of<LanguageDBProvider>(context, listen: false);
  late List<LevelModel>? levelList;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  getInit() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (await languageDBProvider!.getLevel()) {
        levelList = languageDBProvider!.levelList;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInit();
  }

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              "${widget.languageModel.language_name}",
              style: headerText2.copyWith(
                  fontWeight: extraBold, fontSize: 20, color: primaryTextColor),
            ),
            Text(
              widget.isOnline == true ? 'Multiplayer' : 'Single Player',
              style:
                  primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            )
          ],
        ),
        actions: [],
      );
    }

    Widget body() {
      return Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "List Level",
            //   style: headerText2.copyWith(fontWeight: regular, fontSize: 28),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: isLoading
                    ? [
                        LevelCardSkeleton(),
                        LevelCardSkeleton(),
                        LevelCardSkeleton(),
                        LevelCardSkeleton()
                      ]
                    : levelList!
                        .map(
                          (e) => ItemLevelCard(
                              levelModel: e,
                              languageModel: widget.languageModel),
                        )
                        .toList(),
              ),
            )
          ],
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: backgroundColor1,
          body: Container(
            child: ListView(
              shrinkWrap: true,
              children: [header(), body()],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}