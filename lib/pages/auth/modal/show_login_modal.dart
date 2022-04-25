import 'dart:async';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';

class ShowLoginModal extends StatefulWidget {
  const ShowLoginModal({Key? key}) : super(key: key);

  @override
  State<ShowLoginModal> createState() => _ShowLoginModalState();
}

class _ShowLoginModalState extends State<ShowLoginModal> {
  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    return Container(
      child: LoginPopUp(
          child: Container(
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Let's get you started",
                style:
                    blackTextStyle.copyWith(fontSize: 15, fontWeight: semiBold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8, right: 8, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: Container(
                    child: ClickyButton(
                        color: whitePurpleColor,
                        shadowColor: whiteAccentPurpleColor,
                        width: 150,
                        height: 60,
                        child: Wrap(
                          children: [
                            Text(
                              'Log In',
                              style: primaryTextStyle.copyWith(
                                  fontSize: 14, fontWeight: bold),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Timer(Duration(milliseconds: 50), () {
                            Navigator.push(
                                context, CustomPageRoute(SignInPage()));
                          });
                        }),
                  )),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: Container(
                    child: ClickyButton(
                        color: purpleColor,
                        shadowColor: purpleAccentColor,
                        width: 150,
                        height: 60,
                        child: Wrap(
                          children: [
                            Text(
                              'Sign Up',
                              style: whiteTextStyle.copyWith(
                                  fontSize: 14, fontWeight: bold),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Timer(Duration(milliseconds: 50), () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CustomPageRoute(SignUpPage()),
                              (route) => false,
                            );
                          });
                        }),
                  ))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class LoginPopUp extends StatelessWidget {
  late Widget child;
  LoginPopUp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _buildHandle(BuildContext context) {
      final theme = Theme.of(context);
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                        color: grayColor2,
                        borderRadius: BorderRadius.all(Radius.circular(2.5))),
                  )),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
        children: [_buildHandle(context), child],
      )),
    );
  }
}
