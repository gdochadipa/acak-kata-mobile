import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
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

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    // LanguageProvider? languageProvider = Provider.of<LanguageProvider>(context);
    LanguageDBProvider? languageDBProvider =
        Provider.of<LanguageDBProvider>(context);
    List<LanguageModel>? listLanguageModel = languageDBProvider.languageList;

    Future<void> showListLanguagePop() async {
      return showModal(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          return PopoverListView(
              child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Bahasa",
                      style: headerText2.copyWith(
                          fontWeight: medium, fontSize: 20, color: blackColor),
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
          ));
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

    Widget body() {
      return Container(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [logoHeader(), middleMenu()],
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
