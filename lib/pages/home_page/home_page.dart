import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/providers/language_provider.dart';
import 'package:acakkata/service/coba_echo_socket.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/language_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  // const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    LanguageProvider? languageProvider = Provider.of<LanguageProvider>(context);
    List<LanguageModel>? listLanguageModel = languageProvider.languages;

    Widget header() {
      return Container(
        margin: EdgeInsets.only(top: 30, left: 15, right: 15),
        padding: EdgeInsets.only(left: 15, right: 8, top: 15, bottom: 15),
        decoration: BoxDecoration(
            color: backgroundColor6,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: backgroundColor5.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.asset(
                      'assets/images/bali_lang.png',
                      width: 25,
                      height: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Achievement',
                        style: headerText3.copyWith(
                            fontSize: 16, fontWeight: medium),
                      ),
                      Text(
                        'Base Bali',
                        style: thirdTextStyle.copyWith(
                            fontSize: 11,
                            fontWeight: medium,
                            color: grayColor3),
                      ),
                      Text(
                        '3 out 4 games',
                        style: thirdTextStyle.copyWith(
                            fontSize: 12, fontWeight: light),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: LinearProgressIndicator(
                  value: 3 / 4,
                  backgroundColor: backgroundColor5,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
            ],
          ),
        ),
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
                "List Bahasa",
                style: headerText2.copyWith(fontWeight: regular, fontSize: 28),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  children:
                      listLanguageModel.map((e) => LanguageCard(e)).toList(),
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: EdgeInsets.only(
              top: 50, left: defaultMargin, right: defaultMargin),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: backgroundColor3, borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [CircularProgressIndicator(), Text("Loading")],
            ),
          ),
        );
      }
    }

    return Container(
      child: ListView(
        children: [header(), cardBody()],
      ),
    );
  }
}
