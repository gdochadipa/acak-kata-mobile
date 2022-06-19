import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
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
        leading: Container(
          margin: const EdgeInsets.only(top: 5, left: 5),
          child: ButtonBounce(
            onClick: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
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
                  ? '${widget.languageModel.language_name_en}'
                  : '${widget.languageModel.language_name_id}'),
              style: whiteTextStyle.copyWith(
                  fontWeight: extraBold, fontSize: 24, color: whiteColor),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 5, right: 5),
            child: ButtonBounce(
                paddingHorizontalButton: 8,
                paddingVerticalButton: 8,
                onClick: () {
                  showCustomFormLevelPop();
                },
                child: Image.asset(
                  'assets/images/setting.png',
                  width: 50,
                  height: 50,
                )),
          )
        ],
      );
    }

    Widget body() {
      return Container(
        margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: isLoading
                  ? []
                  : levelList!
                      .map(
                        (e) => AnimationConfiguration.staggeredGrid(
                            position: levelList!.indexOf(e),
                            duration: const Duration(milliseconds: 1000),
                            columnCount: 3,
                            child: SlideAnimation(
                              child: FadeInAnimation(
                                  child: ItemLevelCard(
                                      levelModel: e,
                                      languageModel: widget.languageModel)),
                            )),
                      )
                      .toList(),
            )
          ],
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: primaryColor,
          body: SafeArea(
              child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    image: AssetImage("assets/images/background.png"),
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [header(), body()],
              ),
            ],
          )),
        ),
        onWillPop: () async => false);
  }
}
