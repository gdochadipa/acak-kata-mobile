import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/header.dart';
import 'package:flutter/material.dart';

class NewPlayerJoinRoomPage extends StatefulWidget {
  // const NewPlayerJoinRoomPage({ Key? key }) : super(key: key);
  late final LanguageModel language;
  NewPlayerJoinRoomPage(this.language);
  @override
  State<NewPlayerJoinRoomPage> createState() => _NewPlayerJoinRoomPageState();
}

class _NewPlayerJoinRoomPageState extends State<NewPlayerJoinRoomPage> {
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
                '#ROOMCODE',
                style:
                    primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Language Text',
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
          onPressed: () {},
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
