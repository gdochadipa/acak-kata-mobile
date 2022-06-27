import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:flutter/material.dart';

class AbountPage extends StatefulWidget {
  const AbountPage({Key? key}) : super(key: key);

  @override
  State<AbountPage> createState() => _AbountPageState();
}

class _AbountPageState extends State<AbountPage> {
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: primaryColor5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  setLanguage.about,
                  style:
                      whiteTextStyle.copyWith(fontSize: 22, fontWeight: black),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "Text",
                  style:
                      whiteTextStyle.copyWith(fontSize: 22, fontWeight: black),
                ),
              )
            ],
          ),
        ),
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
              Align(
                alignment: Alignment.center,
                child: cardBody(),
              ),
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
