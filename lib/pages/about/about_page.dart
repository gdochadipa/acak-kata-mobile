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

    List<String> listAbout = [
      "dictionary.basabali.org",
      "Faisal Amir, Dictionary Box",
      "Muhammad Irfan Luthfi, Kamus-Jawa-Indonesia",
      "Sahri Riza Umami, Kamus Besar Bahasa Indonesia Edisi IV"
    ];

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
            borderRadius: BorderRadius.circular(15), color: primaryColor9),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  setLanguage.about,
                  style:
                      blackTextStyle.copyWith(fontSize: 22, fontWeight: black),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                child: Flexible(
                    child: Text(
                  setLanguage.about_cite,
                  style:
                      blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
                )),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: listAbout.map((e) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '\u2022',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(e,
                                textAlign: TextAlign.left,
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: medium,
                                  color: Colors.black.withOpacity(0.6),
                                  height: 1.55,
                                )),
                          ),
                        ],
                      );
                    }).toList()),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                child: Text(
                  setLanguage.contact_us,
                  style:
                      blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                ),
              )
            ],
          ),
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          backgroundColor: primaryColor5,
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
