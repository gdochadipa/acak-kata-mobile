import 'dart:async';
import 'dart:ui';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/pages/auth/modal/show_login_modal.dart';
import 'package:acakkata/pages/auth/modal/show_profile_modal.dart';
import 'package:acakkata/pages/dictionary/dict_search_page.dart';
import 'package:acakkata/pages/in_game/modal/join_room_modal.dart';
import 'package:acakkata/pages/level/level_list_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/language_card.dart';
import 'package:acakkata/widgets/popover/language_app_modal.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool login = false;
  bool isNetwork = false;

  init() async {
    prefs = await SharedPreferences.getInstance();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    isNetwork = await _authProvider!.hasNetwork();
    setState(() {
      languageChoice = prefs!.getString("choiceLang");
      wasSelectedLanguage = prefs!.getBool("wasSelectedLanguage") ?? false;
      login = prefs!.getBool('login') ?? false;
    });
  }

  void onChangeLanguage(String flag) {
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _changeLanguageProvider!.changeLocale(flag);
        wasSelectedLanguage = true;
        prefs!.setString("choiceLang", flag);
        prefs!.setBool("wasSelectedLanguage", true);
      });
    });
  }

  void onCheckConnection() async {
    setState(() async {
      isNetwork = await _authProvider!.hasNetwork();
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
          builder: (BuildContext context) => SizedBox(
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
                        S.of(context).exit_game_menu,
                        style: headerText2.copyWith(
                          fontSize: 18,
                          fontWeight: semiBold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15, right: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(2),
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
                                  S.of(context).exit_game_yes,
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: medium,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                child: Container(
                              margin: const EdgeInsets.all(5),
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
                                  S.of(context).exit_game_no,
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
      return showModal(
          context: context,
          builder: (BuildContext context) {
            final theme = Theme.of(context);
            return const Dialog(
              insetAnimationCurve: Curves.easeInOut,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(),
              child: ShowLoginModal(),
            );
          });
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
          context: context,
          builder: (BuildContext context) => const JoinRoomModal());
    }

    showListLanguagePop(int typeAccess) async {
      return showModal(
        context: context,
        builder: (BuildContext context) {
          final theme = Theme.of(context);
          return Dialog(
            backgroundColor: Colors.transparent,
            insetAnimationCurve: Curves.easeInOut,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: PopoverListView(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        setLanguage.listLanguage,
                        style: whiteTextStyle.copyWith(
                            fontWeight: bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Column(
                          children: listLanguageModel!
                              .map((e) => LanguageCard(
                                    language: e,
                                    onClick: () {
                                      if (typeAccess == 1) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CustomPageRoute(
                                              LevelListPage(
                                                isOnline: false,
                                                languageModel: e,
                                              ),
                                            ),
                                            (route) => false);
                                      } else if (typeAccess == 2) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            CustomPageRoute(
                                              DictSearchPage(
                                                languageModel: e,
                                              ),
                                            ),
                                            (route) => false);
                                      }
                                    },
                                  ))
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
          );
        },
      );
    }

    showLanguageAppSetting() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            return const LanguageAppSettingModal();
          });
    }

    Widget logoHeader() {
      return ElasticIn(
        child: Container(
          child: Image.asset(
            'assets/images/logo_baru_no.png',
            height: 396.58,
            width: 231.46,
          ),
        ),
      );
    }

    Widget btnPlayGame() {
      return CircleBounceButton(
        color: whiteColor,
        borderColor: whiteColor2,
        shadowColor: whiteColor3,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        onClick: () {
          //satu untuk le leveleListPage
          showListLanguagePop(1);
        },
        paddingHorizontalButton: 10,
        paddingVerticalButton: 10,
        heightButton: 180,
        widthButton: 180,
        child: Container(
          width: 110,
          height: 110,
          child: Center(
            child: Image.asset('assets/images/arrow_shadow_black.png'),
          ),
        ),
      );
    }

    Widget btnProfile() {
      return CircleBounceButton(
        color: blueColor,
        borderColor: blueColor2,
        shadowColor: blueColor3,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        onClick: () {
          if (!(login)) {
            showAuthModal();
          } else {
            showProfileModal();
          }
        },
        paddingHorizontalButton: 10,
        paddingVerticalButton: 10,
        heightButton: 75,
        widthButton: 75,
        child: SizedBox(
          width: 55,
          height: 55,
          child: Center(
            child: Image.asset('assets/images/profil.png'),
          ),
        ),
      );
    }

    Widget btnSearch() {
      return CircleBounceButton(
        color: blueColor,
        borderColor: blueColor2,
        shadowColor: blueColor3,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        onClick: () {
          showListLanguagePop(2);
        },
        paddingHorizontalButton: 10,
        paddingVerticalButton: 10,
        heightButton: 75,
        widthButton: 75,
        child: SizedBox(
          width: 55,
          height: 55,
          child: Center(
            child: Image.asset('assets/images/icon_search.png'),
          ),
        ),
      );
    }

    Widget btnFindRoom() {
      return CircleBounceButton(
        color: greenColor,
        borderColor: greenColor2,
        shadowColor: greenColor3,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        onClick: () async {
          onCheckConnection();
          if (isNetwork) {
            if (!login) {
              showAuthModal();
            } else {
              showJoinRoomModal();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                "Connection Failed",
                textAlign: TextAlign.center,
              ),
              backgroundColor: alertColor,
            ));
          }
        },
        paddingHorizontalButton: 10,
        paddingVerticalButton: 10,
        heightButton: 75,
        widthButton: 75,
        child: Container(
          width: 55,
          height: 55,
          child: Center(
            child: Image.asset('assets/images/game.png'),
          ),
        ),
      );
    }

    Widget btnExits() {
      return ButtonBounce(
        color: redColor,
        borderColor: redColor2,
        shadowColor: redColor3,
        onClick: () {
          showCancelGame();
        },
        paddingHorizontalButton: 8,
        paddingVerticalButton: 8,
        heightButton: 62.92,
        widthButton: 62.92,
        child: Container(
          width: 50,
          height: 50,
          child: Center(
            child: Image.asset('assets/images/logout.png'),
          ),
        ),
      );
    }

    Widget btnSetting() {
      return ButtonBounce(
        onClick: () {
          showLanguageAppSetting();
        },
        paddingHorizontalButton: 8,
        paddingVerticalButton: 8,
        heightButton: 62.92,
        widthButton: 62.92,
        child: Container(
          width: 50,
          height: 50,
          child: Center(
            child: Image.asset('assets/images/setting.png'),
          ),
        ),
      );
    }

    Widget btnProfileBox() {
      return ButtonBounce(
        color: blueColor,
        borderColor: blueColor2,
        shadowColor: blueColor3,
        onClick: () async {
          onCheckConnection();
          if (isNetwork) {
            if (!login) {
              showAuthModal();
            } else {
              showProfileModal();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                "Connection Failed",
                textAlign: TextAlign.center,
              ),
              backgroundColor: alertColor,
            ));
          }
        },
        paddingHorizontalButton: 8,
        paddingVerticalButton: 8,
        heightButton: 62.92,
        widthButton: 62.92,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: Image.asset('assets/images/profil.png'),
          ),
        ),
      );
    }

    Widget middleMenu() {
      return ElasticIn(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [btnSearch(), btnPlayGame(), btnFindRoom()],
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
              margin: const EdgeInsets.all(11),
              padding: const EdgeInsets.all(15),
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
                  const SizedBox(
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
          margin: const EdgeInsets.only(
              left: 20.0, right: 20.0, bottom: 10.0, top: 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                logoHeader(),
                (wasSelectedLanguage ? middleMenu() : languageChoice())
              ],
            ),
          ));
    }

    return WillPopScope(
        child: Scaffold(
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
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: body(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  alignment: Alignment.topLeft,
                  child: btnExits(),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      btnSetting(),
                      const SizedBox(
                        height: 5,
                        width: 5,
                      ),
                      btnProfileBox()
                    ],
                  ),
                )
              ],
            ),
          ),
          backgroundColor: backgroundColor2,
        ),
        onWillPop: () async => false);
  }
}
