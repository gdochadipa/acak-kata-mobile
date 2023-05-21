import 'package:acakkata/models/history_game_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:acakkata/widgets/collapse/custome_expansion_tile.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class HistoryAnswerListModal extends StatefulWidget {
  const HistoryAnswerListModal({Key? key}) : super(key: key);

  @override
  State<HistoryAnswerListModal> createState() => _HistoryAnswerListModalState();
}

class _HistoryAnswerListModalState extends State<HistoryAnswerListModal> {
  RoomProvider? roomProvider;
  RoomMatchModel? roomMatch;
  List<HistoryGameDetailModel>? _historyGameDetailModel;

  @override
  void initState() {
    // TODO: implement initState
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
    if (roomProvider!.dataHistoryGameDetailList != null) {
      _historyGameDetailModel = roomProvider!.dataHistoryGameDetailList;
    } else {
      _historyGameDetailModel = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget childrenAnswer(
        {required bool answer,
        required String? answerWord,
        required String? meaning,
        required List<String>? relatedWord}) {
      return CustomExpansionTile(
        leading: answer
            ? Image.asset(
                'assets/images/success.png',
                height: 30,
                width: 30,
              )
            : Image.asset(
                'assets/images/fail.png',
                height: 30,
                width: 30,
              ),
        title: Text(
          answerWord.toString().toUpperCase(),
          style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: bold),
        ),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  meaning.toString(),
                  style:
                      blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: relatedWord!
                      .map((e) => Chip(
                            label: Text(
                              "$e",
                              style: whiteTextStyle.copyWith(fontSize: 15),
                            ),
                            backgroundColor: successColor,
                          ))
                      .toList(),
                )
              ],
            ),
          )
        ],
      );
    }

    return Dialog(
        insetAnimationCurve: Curves.easeInOut,
        insetPadding: const EdgeInsets.all(1),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
              color: primaryColor5,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              border: Border.all(width: 6, color: primaryColor2)),
          child: ListView(
            children: [
              Stack(
                children: [
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
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "Hasil Jawaban",
                  style:
                      blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: _historyGameDetailModel!
                    .map((e) => childrenAnswer(
                        answer: (e.statusAnswer == 1 ? true : false),
                        answerWord: e.correctAnswerByUser?.word,
                        meaning: e.correctAnswerByUser?.word_hint,
                        relatedWord: e.listWords!
                            .map((word) => word.word ?? '')
                            .toList()))
                    .toList(),
              ),
            ],
          ),
        ));
  }
}
