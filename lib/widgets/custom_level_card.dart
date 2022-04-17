import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLevelCard extends StatelessWidget {
  late final LanguageModel? languageModel;

  CustomLevelCard({Key? key, required this.languageModel}) : super(key: key);

  // CustomLevelCard({required this.languageModel});

  @override
  Widget build(BuildContext context) {
    showCustomFormLevelPop() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            TextEditingController questionNumber =
                TextEditingController(text: '');
            TextEditingController lengthWord = TextEditingController(text: '');
            TextEditingController questionTime =
                TextEditingController(text: '');
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Dialog(
                insetAnimationCurve: Curves.easeInOut,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: PopoverListView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Custom Game",
                                textAlign: TextAlign.left,
                                style: blackTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: bold,
                                )),
                            const SizedBox(
                              height: 1.85,
                            ),
                            Text("${languageModel!.language_name_en}",
                                textAlign: TextAlign.left,
                                style: blackTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: medium,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jumlah Soal',
                              textAlign: TextAlign.left,
                              style: blackTextStyle.copyWith(
                                  fontSize: 17, fontWeight: semiBold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(color: blackColor),
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: questionNumber,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Jumlah Soal',
                                          hintStyle: subtitleTextStyle),
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panjang Kata',
                              style: blackTextStyle.copyWith(
                                  fontSize: 17, fontWeight: semiBold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(color: blackColor),
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: questionNumber,
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'Panjang Kata',
                                        hintStyle: subtitleTextStyle),
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Waktu (Detik)',
                              textAlign: TextAlign.left,
                              style: blackTextStyle.copyWith(
                                  fontSize: 17, fontWeight: semiBold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(color: blackColor),
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: questionNumber,
                                      decoration: InputDecoration.collapsed(
                                          hintText: 'Waktu (Detik)',
                                          hintStyle: subtitleTextStyle),
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 8, right: 8, top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Container(
                              child: ClickyButton(
                                  color: greenColor,
                                  shadowColor: greenAccentColor,
                                  width: 120,
                                  height: 60,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'Bermain',
                                        style: whiteTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/icon_play_white.png',
                                        height: 25,
                                        width: 25,
                                      )
                                    ],
                                  ),
                                  onPressed: () {}),
                            )),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                                child: Container(
                              child: ClickyButton(
                                  color: purpleColor,
                                  shadowColor: purpleAccentColor,
                                  width: 120,
                                  height: 60,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        'Tantang \n Teman',
                                        style: whiteTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/images/icon_group_white.png',
                                        height: 25,
                                        width: 25,
                                      )
                                    ],
                                  ),
                                  onPressed: () {}),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return GestureDetector(
      onTap: () {
        showCustomFormLevelPop();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(top: 13, bottom: 13, left: 10, right: 10),
        decoration: BoxDecoration(
            // border: Border.all(color: blackColor),
            boxShadow: [
              BoxShadow(
                  color: backgroundColorAccent8,
                  spreadRadius: 1,
                  blurRadius: 0,
                  blurStyle: BlurStyle.solid,
                  offset: Offset(-4, 4))
            ], color: backgroundColor8, borderRadius: BorderRadius.circular(5)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Align(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Custom Level',
                            style: whiteTextStyle.copyWith(
                                fontSize: 21, fontWeight: bold),
                          )
                        ],
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
