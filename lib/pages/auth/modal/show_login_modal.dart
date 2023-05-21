import 'dart:async';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/pages/auth/signin_page.dart';
import 'package:acakkata/pages/auth/signup_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
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
    return LoginPopUp(
        child: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Let's get you started",
              style: whiteTextStyle.copyWith(fontSize: 15, fontWeight: bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: ButtonBounce(
                        color: whiteColor,
                        borderColor: whiteColor2,
                        shadowColor: whiteColor3,
                        paddingHorizontalButton: 1,
                        paddingVerticalButton: 1,
                        heightButton: 50,
                        widthButton: 150,
                        borderRadius: 10,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Log In',
                                style: blackTextStyle.copyWith(
                                    fontSize: 16, fontWeight: bold),
                              ),
                            )
                          ],
                        ),
                        onClick: () {
                          Timer(const Duration(milliseconds: 50), () {
                            Navigator.push(
                                context, CustomPageRoute(SignInPage()));
                          });
                        })),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                    child: ButtonBounce(
                        color: primaryColor,
                        borderColor: primaryColor2,
                        shadowColor: primaryColor3,
                        paddingHorizontalButton: 1,
                        paddingVerticalButton: 1,
                        heightButton: 50,
                        widthButton: 150,
                        borderRadius: 10,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Sign Up',
                                style: whiteTextStyle.copyWith(
                                    fontSize: 16, fontWeight: bold),
                              ),
                            ),
                          ],
                        ),
                        onClick: () {
                          Timer(const Duration(milliseconds: 50), () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CustomPageRoute(SignUpPage()),
                              (route) => false,
                            );
                          });
                        }))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class LoginPopUp extends StatelessWidget {
  late Widget child;
  LoginPopUp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(width: 5, color: primaryColor2)),
              child: child,
            ),
            Container(
                alignment: Alignment.topRight,
                child: CircleBounceButton(
                  color: redColor,
                  borderColor: redColor2,
                  shadowColor: redColor3,
                  onClick: () {
                    Navigator.pop(context);
                  },
                  paddingHorizontalButton: 1,
                  paddingVerticalButton: 1,
                  heightButton: 45,
                  widthButton: 45,
                  child: Icon(Icons.close, color: whiteColor, size: 25),
                )),
          ],
        ),
      ),
    );
  }
}
