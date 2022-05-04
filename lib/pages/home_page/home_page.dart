import 'dart:async';

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
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    // LanguageProvider? languageProvider = Provider.of<LanguageProvider>(context);
    LanguageDBProvider? languageDBProvider =
        Provider.of<LanguageDBProvider>(context);
    List<LanguageModel>? listLanguageModel = languageDBProvider.languageList;

    Widget logoHeader() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: Image.asset(
            'assets/images/logo_biru.png',
            height: 100,
            width: 80,
          ),
        ),
      );
    }

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30, left: 15, right: 15),
        padding: EdgeInsets.only(left: 15, right: 8, top: 15, bottom: 5),
        decoration: BoxDecoration(
            color: backgroundColor1,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: blackColor, width: 1)),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Center(
                child: Text(
                  "Bermain dengan teman ?",
                  style:
                      blackTextStyle.copyWith(fontWeight: medium, fontSize: 16),
                ),
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: ClickyButton(
                        color: backgroundColor1,
                        shadowColor: backgroundColor2,
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        width: 120,
                        height: 60,
                        child: Text(
                          'LOG IN',
                          style: primaryTextStyle.copyWith(
                              fontSize: 16, fontWeight: bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CustomPageRouteBounce(
                                  widget: SignInPage(),
                                  duration: const Duration(milliseconds: 200)));
                        }),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: ClickyButton(
                        color: backgroundColor2,
                        shadowColor: backgroundColorAccent2,
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        width: 120,
                        height: 60,
                        child: Text(
                          'SIGN UP',
                          style: whiteTextStyle.copyWith(
                              fontSize: 16, fontWeight: bold),
                        ),
                        onPressed: () {
                          Timer(Duration(milliseconds: 500), () {
                            // Navigator.pushNamed(context, '/home');
                            Navigator.push(
                                context,
                                CustomPageRouteBounce(
                                    widget: SignUpPage(),
                                    duration:
                                        const Duration(milliseconds: 1000)));
                          });
                        }),
                  ),
                )
              ],
            )
          ],
        )),
      );
    }

    Widget cardBody() {
      if (!isLoading) {
        return Container(
          margin: EdgeInsets.only(top: 20, left: 15, right: 15),
          padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's Play !",
                style: headerText2.copyWith(fontWeight: medium, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  children:
                      listLanguageModel!.map((e) => LanguageCard(e)).toList(),
                ),
              )
            ],
          ),
        );
      }
    }

    Widget body() {
      return Container(
        child: ListView(
          children: [
            // header(),
            cardBody()
          ],
        ),
      );
    }

    Widget headerWidget() {
      return Container(
          child: Center(
        child: Text(
          "List Bahasa",
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: thirdColor),
        ),
      ));
    }

    return Container(
      child: ListView(
        children: [
          AnimationConfiguration.staggeredList(
            duration: Duration(milliseconds: 1000),
            position: 0,
            child: SlideAnimation(
              child: FadeInAnimation(child: logoHeader()),
              horizontalOffset: 50.0,
            ),
          ),
          AnimationConfiguration.staggeredList(
            duration: Duration(milliseconds: 1000),
            position: 1,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: header(),
              ),
              horizontalOffset: 50.0,
            ),
          ),
          AnimationConfiguration.staggeredList(
            duration: Duration(milliseconds: 1000),
            position: 2,
            child: SlideAnimation(
              child: FadeInAnimation(child: cardBody()),
              horizontalOffset: 50.0,
            ),
          ),
        ],
      ),
    );

    // return DraggableHome(
    //     title: Text("List Bahasa"),
    //     headerWidget: headerWidget(),
    //     fullyStretchable: true,
    //     body: [body()]);
  }
}
