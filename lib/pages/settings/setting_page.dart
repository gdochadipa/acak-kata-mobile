import 'dart:async';
import 'dart:ui';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences? prefs;
  String? languageChoice = 'en';
  bool wasSelectedLanguage = false;
  Map<int, String> listLanguage = {0: 'id', 1: 'en'};
  GroupButtonController? _groupButtonController;
  ChangeLanguageProvider? _changeLanguageProvider;
  String? languageSelected;

  init() async {
    prefs = await SharedPreferences.getInstance();
    _changeLanguageProvider =
        Provider.of<ChangeLanguageProvider>(context, listen: false);
    setState(() {
      languageChoice = prefs!.getString("choiceLang");
      wasSelectedLanguage = prefs!.getBool("wasSelectedLanguage") ?? false;
    });
    _groupButtonController = GroupButtonController(
      selectedIndex: listLanguage.values.toList().indexOf(languageChoice!),
      onDisablePressed: (i) => print('Button #$i is disabled'),
    );
  }

  void onChangeLanguage(String? flag) {
    if (flag != null) {
      S language = S.of(context);
      // print("set flag ${language.code}");
      setState(() {
        _changeLanguageProvider!.changeLocale(flag);
        wasSelectedLanguage = true;
        prefs!.setString("choiceLang", flag);
        prefs!.setBool("wasSelectedLanguage", true);
      });
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);

    Widget btnExits() {
      return ButtonBounce(
        color: redColor,
        borderColor: redColor2,
        shadowColor: redColor3,
        onClick: () {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        },
        paddingHorizontalButton: 8,
        paddingVerticalButton: 8,
        heightButton: 62.92,
        widthButton: 62.92,
        child: SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: Image.asset('assets/images/logout.png'),
          ),
        ),
      );
    }

    Widget cardBody() {
      return Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                setLanguage.setting,
                style: whiteTextStyle.copyWith(fontSize: 25, fontWeight: bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GroupButton(
              isRadio: true,
              buttons: listLanguage.keys.toList(),
              controller: _groupButtonController,
              onSelected: (item, i, selected) {},
              buttonBuilder: (selected, item, context) {
                var listLang = listLanguage.values.toList();
                return BouncingWidget(
                  onPressed: () {
                    if (!selected) {
                      _groupButtonController!
                          .selectIndex(int.parse(item.toString()));
                      // onChangeLanguage(listLang[int.parse(item.toString())]);
                      setState(() {
                        languageSelected = listLang[int.parse(item.toString())];
                      });
                      // print(
                      //     "on selected = ${selected}  ${listLang[int.parse(item.toString())]} ");
                      return;
                    }
                    // _groupButtonController!
                    //     .unselectIndex(int.parse(item.toString()));
                  },
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        width: 110,
                        margin: const EdgeInsets.all(11),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            border: Border.all(
                                width: 2,
                                color: selected
                                    ? blackColor
                                    : Colors.grey.shade200.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: listLang[int.parse(item.toString())] ==
                                      'en'
                                  ? Image.asset('assets/images/en_flag.png')
                                  : Image.asset('assets/images/id_flag.png'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child:
                                  listLang[int.parse(item.toString())] == 'en'
                                      ? Text(
                                          "English",
                                          textAlign: TextAlign.center,
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: bold,
                                              color: Colors.white),
                                        )
                                      : Text("Indonesia",
                                          textAlign: TextAlign.center,
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: bold,
                                              color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            ButtonBounce(
                color: primaryColor,
                borderColor: primaryColor2,
                shadowColor: primaryColor3,
                widthButton: 180,
                heightButton: 60,
                child: Center(
                  child: Text(
                    setLanguage.save_setting,
                    style:
                        whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                  ),
                ),
                onClick: () {
                  print("selected lang ${languageSelected}");
                  Timer(const Duration(milliseconds: 50), () {
                    onChangeLanguage(languageSelected ?? null);
                  });
                }),
            const SizedBox(
              height: 10,
            ),
            ButtonBounce(
              color: whiteColor,
              borderColor: whiteColor2,
              shadowColor: whiteColor3,
              widthButton: 180,
              heightButton: 60,
              onClick: () {
                Navigator.pushNamed(context, '/about');
              },
              child: Center(
                child: Text(
                  setLanguage.about,
                  style:
                      primaryTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
              ),
            )
          ],
        )),
      );
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
              cardBody(),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                alignment: Alignment.topLeft,
                child: btnExits(),
              ),
            ],
          )),
        ),
        onWillPop: () async => false);
  }
}
