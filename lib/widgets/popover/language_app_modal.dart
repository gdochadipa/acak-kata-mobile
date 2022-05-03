import 'dart:async';
import 'dart:ui';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/providers/change_language_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageAppSettingModal extends StatefulWidget {
  const LanguageAppSettingModal({
    Key? key,
  }) : super(key: key);

  @override
  State<LanguageAppSettingModal> createState() =>
      _LanguageAppSettingModalState();
}

class _LanguageAppSettingModalState extends State<LanguageAppSettingModal> {
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
    print(
        "${listLanguage.values.toList().indexOf(languageChoice!)} ${languageChoice} selected index");
    _groupButtonController = GroupButtonController(
      selectedIndex: listLanguage.values.toList().indexOf(languageChoice!),
      onDisablePressed: (i) => print('Button #$i is disabled'),
    );
  }

  void onChangeLanguage(String flag) {
    S language = S.of(context);
    // print("set flag ${language.code}");
    setState(() {
      _changeLanguageProvider!.changeLocale(flag);
      wasSelectedLanguage = true;
      prefs!.setString("choiceLang", flag);
      prefs!.setBool("wasSelectedLanguage", true);
    });
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
    S? setLang = S.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Dialog(
        insetAnimationCurve: Curves.easeInOut,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: PopoverListView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${setLang.setting}",
                  style:
                      blackTextStyle.copyWith(fontSize: 20, fontWeight: bold),
                ),
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
                          languageSelected =
                              listLang[int.parse(item.toString())];
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
                          margin: EdgeInsets.all(11),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: selected
                                  ? backgroundColor8
                                  : Colors.grey.shade200.withOpacity(0.5),
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
                              SizedBox(
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
                                                color: selected
                                                    ? Colors.white
                                                    : Colors.black),
                                          )
                                        : Text("Indonesia",
                                            textAlign: TextAlign.center,
                                            style: whiteTextStyle.copyWith(
                                                fontSize: 14,
                                                fontWeight: bold,
                                                color: selected
                                                    ? Colors.white
                                                    : Colors.black)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                  child: ClickyButton(
                      color: purpleColor,
                      shadowColor: purpleAccentColor,
                      width: 180,
                      height: 60,
                      child: Text(
                        "${setLang.save_setting}",
                        style: whiteTextStyle.copyWith(
                            fontSize: 14, fontWeight: bold),
                      ),
                      onPressed: () {
                        // print("selected lang ${languageSelected}");
                        Timer(Duration(milliseconds: 50), () {
                          onChangeLanguage(languageSelected!);
                        });
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
