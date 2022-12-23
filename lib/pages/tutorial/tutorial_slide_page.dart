import 'dart:collection';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/pages/tutorial/tutorial.dart';
import 'package:acakkata/pages/tutorial/tutorial_item.dart';
import 'package:acakkata/theme.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TutorialSlidePage extends StatefulWidget {
  final int typeGuide;
  const TutorialSlidePage({Key? key, required this.typeGuide})
      : super(key: key);

  @override
  State<TutorialSlidePage> createState() => _TutorialSlidePageState();
}

class _TutorialSlidePageState extends State<TutorialSlidePage> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    //beginGame diambil dari file tutorial
    var tutorialGame = beginGame;

    switch (widget.typeGuide) {
      case 0:
        tutorialGame = beginGame;
        break;
      case 1:
        tutorialGame = howToPlay;
        break;

      case 2:
        tutorialGame = multiplayer;
        break;

      default:
        tutorialGame = beginGame;
        break;
    }

    return WillPopScope(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                child: CarouselSlider(
                  items: tutorialGame
                      .map((e) => TutorialItem(
                          imageUrl: e.imageUrl,
                          title: (setLanguage.code == 'en')
                              ? e.titleEN
                              : e.titleID,
                          subtitle: (setLanguage.code == 'en')
                              ? e.subTitleEN
                              : e.subTitleID))
                      .toList(),
                  options: CarouselOptions(
                    height: double.infinity,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    initialPage: currentIndex,
                    onPageChanged: (index, _) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  carouselController: carouselController,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        carouselController
                            .animateToPage(tutorialGame.length - 1);
                      },
                      child: Text(
                        'SKIP',
                        style: blackTextStyle.copyWith(
                            fontSize: 18, fontWeight: black),
                      ),
                    ),
                    Row(
                        children: tutorialGame.map((e) {
                      int i = tutorialGame.toList().indexOf(e);
                      return DotBlack(
                        currentIndex: currentIndex,
                        myIndex: i,
                      );
                    }).toList()),
                    TextButton(
                      onPressed: () {
                        if (currentIndex == tutorialGame.length - 1) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        } else {
                          carouselController.nextPage();
                        }
                      },
                      child: Text(
                        'NEXT',
                        style: blackTextStyle.copyWith(
                            fontSize: 18, fontWeight: black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onWillPop: () async => false);
  }
}

class DotBlack extends StatelessWidget {
  const DotBlack({Key? key, required this.currentIndex, required this.myIndex})
      : super(key: key);

  final int currentIndex;
  final int myIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentIndex == myIndex ? kBlackColor : kLineDarkColor,
      ),
    );
  }
}
