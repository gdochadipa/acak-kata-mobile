
import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/level_card.dart';
import 'package:acakkata/widgets/popover/custom_match_form.dart';
import 'package:acakkata/widgets/skeleton/level_card_skeleton.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
      if (await languageDBProvider!
          .getLevel(widget.languageModel.language_code)) {
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
    S? setLanguage = S.of(context);

    showCustomFormLevelPop() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            return CustomMatchForm(languageModel: widget.languageModel);
          });
    }

    Widget header() {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.languageModel.language_name_en}'
                  : '${widget.languageModel.language_name_id}'),
              style: headerText2.copyWith(
                  fontWeight: extraBold, fontSize: 20, color: primaryTextColor),
            ),
            Text(
              widget.isOnline == true
                  ? setLanguage.multi_player
                  : setLanguage.single_player,
              style:
                  primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            )
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showCustomFormLevelPop();
            },
            child: Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset('assets/images/icon_setting.png')),
          )
        ],
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "List Level",
            //   style: headerText2.copyWith(fontWeight: regular, fontSize: 28),
            // ),
            const SizedBox(
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
                          (e) => AnimationConfiguration.staggeredList(
                              position: levelList!.indexOf(e),
                              duration: const Duration(milliseconds: 1000),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: ItemLevelCard(
                                        levelModel: e,
                                        languageModel: widget.languageModel)),
                              )),
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
