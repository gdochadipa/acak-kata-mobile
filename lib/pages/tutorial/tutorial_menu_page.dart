import 'package:acakkata/pages/tutorial/tutorial_slide_page.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:acakkata/widgets/tutorial_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TutorialMenuPage extends StatefulWidget {
  const TutorialMenuPage({Key? key}) : super(key: key);

  @override
  State<TutorialMenuPage> createState() => _TutorialMenuPageState();
}

class _TutorialMenuPageState extends State<TutorialMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetAnimationCurve: Curves.easeInOut,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: PopoverListView(
            child: Container(
          padding:
              const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tutorial",
                style: whiteTextStyle.copyWith(fontWeight: bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  TutorialCard(
                    onClick: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          CustomPageRoute(TutorialSlidePage(typeGuide: 0)),
                          (route) => false);
                    },
                    titleId: "Memulai Permainan",
                    titleEn: "How to start a game",
                  ),
                  TutorialCard(
                    onClick: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          CustomPageRoute(TutorialSlidePage(typeGuide: 1)),
                          (route) => false);
                    },
                    titleId: "Cara Bermain",
                    titleEn: "How to play",
                  ),
                  TutorialCard(
                    onClick: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          CustomPageRoute(TutorialSlidePage(typeGuide: 2)),
                          (route) => false);
                    },
                    titleId: "Permainan Multiplayer",
                    titleEn: "How to play Multiplayer",
                  )
                ],
              )
            ],
          ),
        )));
  }
}
