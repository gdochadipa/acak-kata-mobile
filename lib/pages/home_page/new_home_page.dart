import 'dart:async';
import 'dart:ui';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/service/coba_echo_socket.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route_bounce.dart';
import 'package:acakkata/widgets/language_card.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  ChangeLanguageProvider? _changeLanguageProvider;
  String? languageChoice = 'en';
  SharedPreferences? prefs;
  bool wasSelectedLanguage = false;

  init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      languageChoice = prefs!.getString("choiceLang");
      if (languageChoice == null) {
      } else {
        wasSelectedLanguage = true;
      }
    });
  }

  void onChangeLanguage(String flag) {
    _changeLanguageProvider!.changeLocale(flag);
    Timer(Duration(milliseconds: 50), () {
      setState(() {
        wasSelectedLanguage = true;
        prefs!.setString("choiceLang", flag);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _changeLanguageProvider =
        Provider.of<ChangeLanguageProvider>(context, listen: false);
    init();
    print(wasSelectedLanguage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    // LanguageProvider? languageProvider = Provider.of<LanguageProvider>(context);
    LanguageDBProvider? languageDBProvider =
        Provider.of<LanguageDBProvider>(context);
    S? setLanguage = S.of(context);

    List<LanguageModel>? listLanguageModel = languageDBProvider.languageList;

    Future<void> showListLanguagePop() async {
      return showModal(
        context: context,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return Container(
            width: MediaQuery.of(context).size.width,
            child: PopoverListView(
                child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${setLanguage.listLanguage}",
                        style: headerText2.copyWith(
                            fontWeight: medium,
                            fontSize: 20,
                            color: blackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          children: listLanguageModel!
                              .map((e) => LanguageCard(e))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          );
        },
      );
    }

    Widget logoHeader() {
      return ElasticIn(
        child: Container(
          child: Image.asset(
            'assets/images/logo_putih.png',
            height: 200,
            width: 170,
          ),
        ),
      );
    }

    Widget btnPlayGame() {
      return BouncingWidget(
        onPressed: () {
          showListLanguagePop();
        },
        child: Container(
          width: 148,
          height: 148,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(43),
          child: Center(
            child: Image.asset('assets/images/icon_play.png'),
          ),
        ),
      );
    }

    Widget btnProfile() {
      return BouncingWidget(
        onPressed: () {},
        child: Container(
          width: 64,
          height: 64,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(16),
          child: Center(
            child: Image.asset('assets/images/icon_profile.png'),
          ),
        ),
      );
    }

    Widget btnSetting() {
      return BouncingWidget(
        onPressed: () {},
        child: Container(
          width: 64,
          height: 64,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(16),
          child: Center(
            child: Image.asset('assets/images/icon_setting.png'),
          ),
        ),
      );
    }

    Widget btnExits() {
      return BouncingWidget(
        onPressed: () {},
        child: Container(
          width: 39,
          height: 39,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(10),
          child: Center(
            child: Image.asset('assets/images/icon_exit.png'),
          ),
        ),
      );
    }

    Widget middleMenu() {
      return ElasticIn(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [btnProfile(), btnPlayGame(), btnSetting()],
          ),
        ),
      );
    }

    Widget choiceLanguageCard(String flag) {
      return BouncingWidget(
        onPressed: () => onChangeLanguage(flag),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: 150,
              margin: EdgeInsets.all(11),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: flag == 'en'
                        ? Image.asset('assets/images/en_flag.png')
                        : Image.asset('assets/images/id_flag.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: flag == 'en'
                        ? Text(
                            "English",
                            textAlign: TextAlign.center,
                            style: whiteTextStyle.copyWith(
                                fontSize: 16, fontWeight: bold),
                          )
                        : Text(" Indonesia",
                            textAlign: TextAlign.center,
                            style: whiteTextStyle.copyWith(
                                fontSize: 16, fontWeight: bold)),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget languageChoice() {
      return ElasticIn(
          child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [choiceLanguageCard("id"), choiceLanguageCard("en")],
        ),
      ));
    }

    Widget body() {
      return Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  logoHeader(),
                  (wasSelectedLanguage ? middleMenu() : languageChoice())
                ],
              ),
            ),
          ));
    }

    return WillPopScope(
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background_512w.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: body(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  alignment: Alignment.topLeft,
                  child: btnExits(),
                )
              ],
            ),
          ),
          backgroundColor: backgroundColor2,
        ),
        onWillPop: () async => false);
  }
}
