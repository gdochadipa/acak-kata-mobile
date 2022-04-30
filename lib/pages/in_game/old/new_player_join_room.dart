import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPlayerJoinRoomPage extends StatefulWidget {
  // const NewPlayerJoinRoomPage({ Key? key }) : super(key: key);
  late final RoomProvider _roomProvider;
  late final LanguageModel language;
  NewPlayerJoinRoomPage(this.language);
  @override
  State<NewPlayerJoinRoomPage> createState() => _NewPlayerJoinRoomPageState();
}

class _NewPlayerJoinRoomPageState extends State<NewPlayerJoinRoomPage> {
  late RoomMatchModel roomMatchModel;
  @override
  void initState() {
    // TODO: implement initState
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);
    widget._roomProvider = roomProvider;
    roomMatchModel = widget._roomProvider.roomMatch!;
    super.initState();
  }

  joinRoom() async {
    try {
      var roomCode = widget._roomProvider.roomMatch!.room_code;
      if (await widget._roomProvider
          .findRoomWithCode(widget.language.id, roomCode)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Berhasil menemukan Room",
            textAlign: TextAlign.center,
          ),
          backgroundColor: successColor,
        ));
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
  }

  @override
  Widget build(BuildContext context) {
    Widget PlayersAvatars() {
      return Container(
        width: 80,
        height: 40,
        color: Colors.white,
        margin:
            EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 18,
                    child: Image.asset('assets/images/bali_lang.png'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 18,
                    child: Image.asset('assets/images/bali_lang.png'),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("+ 2 Pemain"),
              )
            ],
          ),
        ),
      );
    }

    Widget TextRoom() {
      return Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '#${roomMatchModel.channel_code}',
                style:
                    primaryTextStyle.copyWith(fontSize: 20, fontWeight: medium),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                '${widget.language.language_name}',
                style:
                    primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
              ),
            ],
          ));
    }

    Widget JoinRoomButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        child: TextButton(
          child: Text(
            "Bergabung ke Permainan",
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            joinRoom();
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: Container(
        child: ListView(
          children: [
            HeaderBar(
                widget.language,
                backgroundColor1,
                primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
                primaryColor),
            PlayersAvatars(),
            TextRoom(),
            JoinRoomButton()
          ],
        ),
      ),
    );
  }
}
