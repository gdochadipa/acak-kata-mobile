import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class WaitingOnlineRoomPage extends StatefulWidget {
  late final LanguageModel? languageModel;
  late final bool? isOnline;
  WaitingOnlineRoomPage({Key? key, this.languageModel, this.isOnline})
      : super(key: key);

  @override
  State<WaitingOnlineRoomPage> createState() => _WaitingOnlineRoomPageState();
}

class _WaitingOnlineRoomPageState extends State<WaitingOnlineRoomPage> {
  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);

    Widget joinPlayerCard(String username_player) {
      return Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
            color: purpleCard, borderRadius: BorderRadius.circular(5)),
        child: Container(
            margin: EdgeInsets.all(5),
            child: Text(
              "${username_player}",
              style:
                  whiteTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
            )),
      );
    }

    Widget settingCard(String information, Image iconInfo) {
      return Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
            color: purpleCard, borderRadius: BorderRadius.circular(5)),
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            children: [
              iconInfo,
              SizedBox(
                width: 7,
              ),
              Text(
                "${information}",
                style:
                    whiteTextStyle.copyWith(fontSize: 22, fontWeight: semiBold),
              )
            ],
          ),
        ),
      );
    }

    Widget ButtonCreateRoom() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ClickyButton(
            color: whitePurpleColor,
            shadowColor: whiteAccentPurpleColor,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Wrap(
              children: [
                Text(
                  'Bermain',
                  style:
                      primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/images/arrow_blue.png',
                  height: 25,
                  width: 25,
                )
              ],
            ),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     CustomPageRoute(WaitingOnlineRoomPage(
              //       languageModel: widget.languageModel,
              //       isOnline: true,
              //     )));
            }),
      );
    }

    AppBar header() {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/home', (route) => false);
          },
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.languageModel!.language_name_en}'
                  : '${widget.languageModel!.language_name_id}'),
              style: headerText2.copyWith(
                  fontWeight: extraBold, fontSize: 20, color: primaryTextColor),
            ),
            Text(
              widget.isOnline == true
                  ? '${setLanguage.multi_player}'
                  : '${setLanguage.single_player}',
              style:
                  primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            )
          ],
        ),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElasticIn(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/logo_putih.png',
                    height: 111.87,
                    width: 84.33,
                  ),
                ),
              ),

              /// * room code  match
              ElasticIn(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 14),
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Game Room",
                                style: blackTextStyle.copyWith(
                                    fontSize: 13, fontWeight: bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "5718 6821",
                                style: blackTextStyle.copyWith(
                                    fontSize: 50, fontWeight: extraBold),
                              ),
                            ],
                          ),
                        ),

                        ///* setting up match
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              settingCard(
                                  "3",
                                  Image.asset(
                                    'assets/images/icon_username.png',
                                    height: 26,
                                    width: 26,
                                  )),
                              settingCard(
                                  "13:15",
                                  Image.asset(
                                    'assets/images/white_clock_icon.png',
                                    height: 26,
                                    width: 26,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )),
              ),

              /// * name player has join
              ElasticIn(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 14),
                  child: Wrap(
                    children: [
                      joinPlayerCard("Giga"),
                      joinPlayerCard("Meta"),
                      joinPlayerCard("Lica")
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              ElasticIn(child: ButtonCreateRoom())
            ],
          ),
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          appBar: header(),
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
                Container(child: body()),
              ],
            ),
          ),
          backgroundColor: backgroundColor2,
        ),
        onWillPop: () async => false);
  }
}
