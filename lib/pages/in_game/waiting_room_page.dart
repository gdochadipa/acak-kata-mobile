import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/pages/in_game/room_match_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/**
 * yang kurang 
 * 1. logo waiting 
 * 2. desain
 * 3. kalo bisa tambahin animation
 */
class WaitingRoomPage extends StatefulWidget {
  // const WaitingRoomPage({Key? key}) : super(key: key);
  late final RoomProvider _roomProvider;
  late final LanguageModel language;
  WaitingRoomPage(this.language);
  @override
  State<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {
  SocketService socketService = SocketService();

  @override
  void initState() {
    // TODO: implement initState
    RoomProvider roomProvider =
        Provider.of<RoomProvider>(context, listen: false);
    widget._roomProvider = roomProvider;
    connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disconnectSocket();
    super.dispose();
  }

  connectSocket() async {
    await socketService.fireSocket();
    socketService.emitJoinRoom('${widget._roomProvider.roomMatch!.room_code}');
    await socketService.bindEventSearchRoom();
    await socketService.onTest();
  }

  // joinRoom() {
  //   socketService.emitJoinRoom('${widget._roomProvider.roomMatch!.room_code}');
  // }

  disconnectSocket() async {
    await socketService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel? user = authProvider.user;
    String? LoadingisReady = "WAITING ANOTHER PLAYER...";
    RoomMatchModel? _roomMatch = widget._roomProvider.roomMatch;

    Widget playerProfile() {
      return Container(
        margin:
            EdgeInsets.only(top: 70, left: defaultMargin, right: defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/photo_profile.png',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              '${user!.name}',
              style: whiteTextStyle.copyWith(fontSize: 18, fontWeight: medium),
            ),
            Text(
              '#${user.userCode}',
              style: thirdTextStyle.copyWith(fontSize: 14, fontWeight: regular),
            )
          ],
        ),
      );
    }

    Widget RoomText() {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            '#${_roomMatch!.room_code}',
            style:
                secondaryTextStyle.copyWith(fontSize: 12, fontWeight: semiBold),
          ),
        ),
      );
    }

    Widget CenterImage() {
      return Container(
          margin: EdgeInsets.only(top: 10),
          child: Center(
            child: Container(
              width: 130,
              height: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/icon_game.jpg'))),
            ),
          ));
    }

    Widget CancelFindMatch() {
      return Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
            onPressed: () {
              // Navigator.pop(context);
              // joinRoom();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RoomMatchPage(widget.language)));
            },
            style: TextButton.styleFrom(
                backgroundColor: alertColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Cancel',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            )),
      );
    }

    Widget LoadingText(String loadingText) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Center(
          child: Text(
            '${loadingText}',
            style:
                primaryTextStyle.copyWith(fontSize: 14, fontWeight: semiBold),
          ),
        ),
      );
    }

    Widget cardBody(String loadingText) {
      return Container(
        margin:
            EdgeInsets.only(top: 50, left: defaultMargin, right: defaultMargin),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor1, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Column(
            children: [
              CenterImage(),
              LoadingText(loadingText),
              RoomText(),
              CancelFindMatch()
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor2,
      body: StreamBuilder(
        stream: socketService.eventStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            try {
              var data = json.decode(snapshot.data.toString());
              RoomMatchDetailModel matchDetail =
                  RoomMatchDetailModel.fromJson(data['room_detail']);
              widget._roomProvider
                  .updateRoomDetail(roomMatchDetailModel: matchDetail);
              socketService.disconnect();
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RoomMatchPage(widget.language)));
              });
            } catch (e) {
              print(e);
            }
            LoadingisReady = "New player join room";

            return Container(
              child: ListView(
                children: [
                  HeaderBar(
                      widget.language,
                      backgroundColor2,
                      whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
                      whiteColor),
                  cardBody(LoadingisReady!)
                ],
              ),
            );
          } else {
            return Container(
              child: ListView(
                children: [
                  HeaderBar(
                      widget.language,
                      backgroundColor2,
                      whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
                      whiteColor),
                  cardBody(LoadingisReady!)
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
