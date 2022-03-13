import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/pages/in_game/game_play_page.dart';
import 'package:acakkata/pages/in_game/waiting_room_page.dart';
import 'package:acakkata/providers/language_db_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrepareGamePage extends StatefulWidget {
  // const PrepareGamePage({Key? key}) : super(key: key);
  late final LanguageModel language;
  PrepareGamePage(this.language);

  @override
  _PrepareGamePageState createState() => _PrepareGamePageState();
}

class _PrepareGamePageState extends State<PrepareGamePage> {
  TextEditingController room_code = TextEditingController(text: '');

  late FocusNode roomCode = FocusNode();
  late RoomProvider roomProvider =
      Provider.of<RoomProvider>(context, listen: false);

  bool isLoading = false;
  List<bool> isSelectedQuestion = [true, false, false];
  List<bool> isSelectedTime = [true, false, false];
  List<int> timeList = [15, 18, 20];
  List<int> questionList = [10, 15, 20];
  int selectedQuestion = 10;
  int selectedTime = 15;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedQuestion = questionList[0];
      selectedTime = timeList[0];
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    roomCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LanguageDBProvider provider = Provider.of<LanguageDBProvider>(context);

    Widget header() {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '${widget.language.language_name}',
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
        actions: [],
      );
    }

    handleCreateRoom() async {
      setState(() {
        isLoading = true;
      });
      // provider.setRuleGame(selectedTime, selectedQuestion);
      try {
        if (await roomProvider.createRoom(
            widget.language.id, 2, selectedTime, selectedTime)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Berhasil membuat Room",
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));
          Navigator.push(
              context, CustomPageRoute(WaitingRoomPage(widget.language)));
        }
      } catch (e, stacktrace) {
        print(e);
        String error = e.toString().replaceAll('Exception:', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }

      setState(() {
        isLoading = false;
      });
    }

    handleSearchRoom() async {
      setState(() {
        isLoading = true;
      });
      // provider.setRuleGame(selectedTime, selectedQuestion);
      try {
        if (await roomProvider.checkingRoomWithCode(
            widget.language.id, room_code.text)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Berhasil menemukan Room",
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));
          // Navigator.push(
          //     context,
          //     CustomPageRoute(
          //         GamePlayPage(widget.language, selectedTime, selectedTime)));
        }
      } catch (e, stacktrace) {
        print(e);
        String error = e.toString().replaceAll('Exception:', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget LanguageText() {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            '${widget.language.language_name}',
            style:
                secondaryTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
        ),
      );
    }

    Widget CustomToggleButtonsQuestion() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Jumlah Soal",
                style:
                    blackTextStyle.copyWith(fontSize: 13, fontWeight: regular)),
            SizedBox(height: 10),
            ToggleButtons(
              isSelected: isSelectedQuestion,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              selectedColor: whiteColor,
              fillColor: primaryBeningColor,
              children: [Text("10"), Text("12"), Text("15")],
              onPressed: (int index) {
                setState(() {
                  selectedQuestion = questionList[index];
                  for (var i = 0; i < isSelectedQuestion.length; i++) {
                    if (i == index) {
                      isSelectedQuestion[i] = true;
                    } else {
                      isSelectedQuestion[i] = false;
                    }
                  }
                });
              },
            )
          ],
        ),
      );
    }

    Widget CustomToggleButtonsTime() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Waktu per soal",
                style:
                    blackTextStyle.copyWith(fontSize: 13, fontWeight: regular)),
            SizedBox(height: 10),
            ToggleButtons(
              isSelected: isSelectedTime,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              selectedColor: whiteColor,
              fillColor: primaryBeningColor,
              children: [Text("15s"), Text("18s"), Text("20s")],
              onPressed: (int index) {
                setState(() {
                  selectedTime = timeList[index];
                  for (var i = 0; i < isSelectedTime.length; i++) {
                    if (i == index) {
                      isSelectedTime[i] = true;
                    } else {
                      isSelectedTime[i] = false;
                    }
                  }
                });
              },
            )
          ],
        ),
      );
    }

    Widget CreateRoomButon() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
            onPressed: () {
              handleCreateRoom();
            },
            style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Start Game',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            )),
      );
    }

    Widget FindRoomForm() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Room',
              style:
                  primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: grayColor2, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: TextFormField(
                      focusNode: roomCode,
                      controller: room_code,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Enter Room Code',
                          hintStyle: subtitleTextStyle),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget FindRoomButon() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        child: TextButton(
            onPressed: () {
              // handleGetRoom();
              handleSearchRoom();
            },
            style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Find Room',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            )),
      );
    }

    Widget cardBodyFindRoom() {
      return Container(
        margin:
            EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor3, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            children: [
              FindRoomForm(),
              FindRoomButon(),
            ],
          ),
        ),
      );
    }

    Widget cardBodyCreateRoom() {
      return Container(
        margin:
            EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor3, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            children: [
              CustomToggleButtonsQuestion(),
              CustomToggleButtonsTime(),
              CreateRoomButon(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Container(
        child: ListView(
          children: [header(), cardBodyCreateRoom(), cardBodyFindRoom()],
        ),
      ),
    );
  }
}
