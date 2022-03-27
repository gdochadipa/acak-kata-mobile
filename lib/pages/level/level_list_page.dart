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

  LevelListPage({required this.languageModel});

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
      isLoading = true;
      if (await languageDBProvider!.getLevel()) {
        levelList = languageDBProvider!.levelList;
        isLoading = false;
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget itemLevels(LevelModel? levelModel, LanguageModel? language) {
      return ItemLevelCard(
        levelModel: levelModel,
        languageModel: language,
      );
    }

    Widget body() {
      return Container(
        margin: EdgeInsets.only(top: 20, left: 15, right: 15),
        padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "List Level",
              style: headerText2.copyWith(fontWeight: regular, fontSize: 28),
            ),
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
                        .map((e) => ItemLevelCard(
                            levelModel: e, languageModel: widget.languageModel))
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
              children: [body()],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
