import 'dart:async';
import 'dart:ui';

import 'package:acakkata/controller/setting_controller.dart';
import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/server_url.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/popover/change_server_dialog.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
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
  List<ServerUrl> list = [
    ServerUrl(
        id: 1,
        mainServer: 1,
        nameServer: 'Server Utama',
        statusServer: 1,
        urlApiPort: '3000',
        urlApiServer: 'http://139.59.117.124:3000'),
    ServerUrl(
        id: 2,
        mainServer: 0,
        nameServer: 'Server Kedua',
        statusServer: 1,
        urlApiPort: '3000',
        urlApiServer: 'http://acakkata.notif.web.id')
  ];

  int? dropdownValue, oldDropdownValue;

  init() async {
    prefs = await SharedPreferences.getInstance();
    _changeLanguageProvider =
        Provider.of<ChangeLanguageProvider>(context, listen: false);
    setState(() {
      languageChoice = prefs!.getString("choiceLang");
      wasSelectedLanguage = prefs!.getBool("wasSelectedLanguage") ?? false;
      dropdownValue = list.first.id;
    });
    _groupButtonController = GroupButtonController(
      selectedIndex: listLanguage.values.toList().indexOf(languageChoice!),
      onDisablePressed: (i) => print('Button #$i is disabled'),
    );
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
    final setting = context.watch<SettingsController>();

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

    Future<void> showChangeServer() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) => ChangeMessageDialog(
                message:
                    "Apakah anda yakin mengganti server ? Ini akan mengakibatkan anda memuat ulang aplikasi",
                onClickSuccess: () async {
                  String? url = list
                      .firstWhere((element) => element.id == dropdownValue)
                      .urlApiServer;
                  setting.saveServerPersistence(
                      url ?? "http://139.59.117.124:3000");
                  Restart.restartApp();
                },
                onClickCancel: () {
                  print("cancel change server");
                },
              ));
    }

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
                      setting.toggleLanguageChoice(languageSelected ?? 'id');
                      _changeLanguageProvider!
                          .changeLocale(languageSelected ?? 'id');
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
                        width: 120,
                        margin: const EdgeInsets.all(11),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: selected
                                ? primaryColor8
                                : Colors.grey.shade200.withOpacity(0.5),
                            border: Border.all(
                                width: 2,
                                color: selected
                                    ? primaryColor7
                                    : Colors.grey.shade200.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(15)),
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
                                              fontSize: 14,
                                              fontWeight: bold,
                                              color: Colors.white),
                                        )
                                      : Text("Indonesia",
                                          textAlign: TextAlign.center,
                                          style: whiteTextStyle.copyWith(
                                              fontSize: 14,
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
            const SizedBox(
              height: 50,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: setting.musicOn,
                builder: (context, musicOn, child) => _SettingLine(
                      setLanguage.music,
                      Icon(musicOn ? Icons.music_note : Icons.music_off,
                          color: whiteColor),
                      onSelected: () => setting.toggleMusicOn(),
                    )),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder<bool>(
                valueListenable: setting.soundsOn,
                builder: (context, soundsOn, child) => _SettingLine(
                      "SFX",
                      Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off,
                          color: whiteColor),
                      onSelected: () => setting.toggleSoundsOn(),
                    )),
            const SizedBox(
              height: 20,
            ),
            DropdownButton(
                hint: const Text("Choose Server"),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
                value: dropdownValue,
                items: list
                    .map((item) => DropdownMenuItem(
                          child: Text(item.nameServer ?? '',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16.0)),
                          value: item.id,
                        ))
                    .toList(),
                onChanged: (int? value) {
                  setState(() {
                    oldDropdownValue = dropdownValue;
                    dropdownValue =
                        list.firstWhere((element) => element.id == value).id!;
                  });
                  showChangeServer();
                }),
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
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: Text(
                  setLanguage.setting,
                  style:
                      whiteTextStyle.copyWith(fontSize: 25, fontWeight: bold),
                ),
              ),
              Center(
                child: cardBody(),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 10),
                alignment: Alignment.topLeft,
                child: btnExits(),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, top: 10),
                alignment: Alignment.bottomCenter,
                child: ButtonBounce(
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
                      style: primaryTextStyle.copyWith(
                          fontSize: 16, fontWeight: bold),
                    ),
                  ),
                ),
              )
            ],
          )),
          backgroundColor: backgroundColor2,
        ),
        onWillPop: () async => false);
  }
}

class _SettingLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingLine(this.title, this.icon, {this.onSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: primaryColor8, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: InkResponse(
          highlightShape: BoxShape.rectangle,
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: whiteTextStyle.copyWith(fontSize: 21),
                ),
                const Spacer(),
                icon,
              ],
            ),
          )),
    );
  }
}
