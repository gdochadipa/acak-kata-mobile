import 'dart:async';
import 'dart:ui';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/pages/auth/modal/show_login_modal.dart';
import 'package:acakkata/pages/auth/modal/show_profile_modal.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/pages/in_game/modal/join_room_modal.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/service/coba_echo_socket.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/language_card.dart';
import 'package:acakkata/widgets/popover/language_app_modal.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({Key? key}) : super(key: key);

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  ChangeLanguageProvider? _changeLanguageProvider;
  AuthProvider? _authProvider;
  String? languageChoice = 'en';
  SharedPreferences? prefs;
  bool wasSelectedLanguage = false;
  bool? login = false;

  init() async {
    prefs = await SharedPreferences.getInstance();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      languageChoice = prefs!.getString("choiceLang");
      wasSelectedLanguage = prefs!.getBool("wasSelectedLanguage") ?? false;
      login = prefs!.getBool('login');
    });
  }

  void onChangeLanguage(String flag) {
    Timer(Duration(milliseconds: 50), () {
      print("${flag}");
      setState(() {
        _changeLanguageProvider!.changeLocale(flag);
        wasSelectedLanguage = true;
        prefs!.setString("choiceLang", flag);
        prefs!.setBool("wasSelectedLanguage", true);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    _changeLanguageProvider =
        Provider.of<ChangeLanguageProvider>(context, listen: false);
    init();
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

    Future<void> showCancelGame() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) => Container(
                width: MediaQuery.of(context).size.width - (2 * defaultMargin),
                child: AlertDialog(
                  backgroundColor: backgroundColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        '${S.of(context).exit_game_menu}',
                        style: headerText2.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15, right: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(2),
                              height: 44,
                              child: TextButton(
                                onPressed: () {
                                  SystemChannels.platform
                                      .invokeMethod('SystemNavigator.pop');
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  '${S.of(context).exit_game_yes}',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                child: Container(
                              margin: EdgeInsets.all(5),
                              height: 44,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  side: BorderSide(
                                      width: 1, color: backgroundColor2),
                                  backgroundColor: backgroundColor1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  '${S.of(context).exit_game_no}',
                                  style: primaryTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                    ],
                  )),
                ),
              ));
    }

    Future<void> showAuthModal() async {
      return showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => ShowLoginModal());
    }

    Future<void> showProfileModal() async {
      UserModel? userModel = _authProvider!.user;
      return showModal(
          context: context,
          builder: (BuildContext context) => ShowProfileModal(
                userModel: userModel,
              ));
    }

    Future<void> showJoinRoomModal() async {
      return showModal(
          context: context, builder: (BuildContext context) => JoinRoomModal());
    }

    showListLanguagePop() async {
      return showModal(
        context: context,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Dialog(
              insetAnimationCurve: Curves.easeInOut,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
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
                            // children: [
                            //   for (var e in listLanguageModel!) LanguageCard(e)
                            // ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
          );
        },
      );
    }

    showLanguageAppSetting() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            return LanguageAppSettingModal();
          });
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
        onPressed: () {
          if (!login!) {
            showAuthModal();
          } else {
            showProfileModal();
          }
        },
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

    Widget btnFindRoom() {
      return BouncingWidget(
        onPressed: () {
          if (!login!) {
            showAuthModal();
          } else {
            showJoinRoomModal();
          }
        },
        child: Container(
          width: 64,
          height: 64,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(16),
          child: Center(
            child: Image.asset('assets/images/icon_black_game.png'),
          ),
        ),
      );
    }

    Widget btnExits() {
      return BouncingWidget(
        onPressed: () {
          showCancelGame();
        },
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

    Widget btnSetting() {
      return BouncingWidget(
        onPressed: () {
          showLanguageAppSetting();
        },
        child: Container(
          width: 39,
          height: 39,
          margin: EdgeInsets.all(11),
          decoration: BoxDecoration(color: whiteColor, shape: BoxShape.circle),
          padding: EdgeInsets.all(10),
          child: Center(
            child: Image.asset('assets/images/icon_setting.png'),
          ),
        ),
      );
    }

    Widget middleMenu() {
      return ElasticIn(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [btnProfile(), btnPlayGame(), btnFindRoom()],
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
                        : Text("Indonesia",
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
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  alignment: Alignment.topRight,
                  child: btnSetting(),
                )
              ],
            ),
          ),
          backgroundColor: backgroundColor2,
        ),
        onWillPop: () async => false);
  }
}
