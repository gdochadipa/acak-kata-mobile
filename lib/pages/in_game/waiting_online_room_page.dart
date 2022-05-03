import 'dart:convert';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class WaitingOnlineRoomPage extends StatefulWidget {
  late final LanguageModel? languageModel;
  late final bool? isOnline;
  WaitingOnlineRoomPage({Key? key, this.languageModel, this.isOnline})
      : super(key: key);

  @override
  State<WaitingOnlineRoomPage> createState() => _WaitingOnlineRoomPageState();
}

class _WaitingOnlineRoomPageState extends State<WaitingOnlineRoomPage> {
  // SocketService socketService = SocketService();
  SocketProvider? socketProvider;
  AuthProvider? authProvider;
  RoomProvider? roomProvider;

  @override
  void initState() {
    // TODO: implement initState
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    connectSocket();
    super.initState();
  }

  connectSocket() async {
    socketProvider!.socketJoinRoom(
        channelCode: '${roomProvider!.roomMatch!.channel_code}',
        playerCode: '${authProvider!.user!.userCode}');
    socketProvider!.socketReceiveFindRoom();
    socketProvider!.socketReceiveStatusPlayer();
    // await socketService.fireSocket();
    // socketService.emitJoinRoom(
    //     '${roomProvider!.roomMatch!.channel_code}', 'allhost');
    // await socketService.bindEventSearchRoom();
    // await socketService.bindReceiveStatusPlayer();
  }

  disconnectSocket() async {
    // await socketService.disconnect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    UserModel? user = authProvider!.user;
    RoomMatchModel? roomMatch = roomProvider!.roomMatch!;
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );

    ///1. get question berdasarkan setting room match
    ///!3. share soal dan status game lewat socket
    /// !4. tunggu update kalo semua pemain udah dapet soal (receive socket)
    /// 5. ketika semua pemain udah dapet soal,
    /// !baru update status game mulai dan share lewat socket
    handleStartGame() async {
      try {
        logger.d("Start Game");
        if (await roomProvider!.getPackageQuestion(
            roomMatch.language!.language_code, roomMatch.channel_code)) {
          socketProvider!.socketSendQuestion(
              channelCode: roomMatch.channel_code!,
              languageCode: roomMatch.language!.language_code!,
              playerId: user!.id!,
              question: json.encode(roomProvider!.listQuestion));

          /// send status
          RoomMatchDetailModel matchDetail = roomProvider!
              .getRoomMatchDetailByUser(userID: user.id, statusPlayer: 2);
          socketProvider!.socketSendStatusPlayer(
              channelCode: roomMatch.channel_code!,
              roomMatchDetailModel: matchDetail);
        } else {
          logger.e("gagal");
        }
      } catch (e, trace) {
        logger.e(e);
        logger.e(trace);
      }
    }

    Widget joinPlayerCard(String username_player) {
      return ElasticIn(
        child: Container(
          padding: EdgeInsets.all(7),
          margin: EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
              color: purpleCard, borderRadius: BorderRadius.circular(5)),
          child: Container(
              margin: EdgeInsets.all(5),
              child: Text(
                "${username_player}",
                style:
                    whiteTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
              )),
        ),
      );
    }

    Widget settingCard(String information, Image iconInfo) {
      return Container(
        padding: EdgeInsets.all(7),
        margin: EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
            color: purpleCard, borderRadius: BorderRadius.circular(5)),
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            children: [
              iconInfo,
              SizedBox(
                width: 7,
              ),
              Text(
                "${information}",
                style:
                    whiteTextStyle.copyWith(fontSize: 22, fontWeight: semiBold),
              )
            ],
          ),
        ),
      );
    }

    Widget btnCreateRoom() {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: ClickyButton(
            color: whitePurpleColor,
            shadowColor: whiteAccentPurpleColor,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Wrap(
              children: [
                Text(
                  'Bermain',
                  style:
                      primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/images/arrow_blue.png',
                  height: 25,
                  width: 25,
                )
              ],
            ),
            onPressed: () {
              handleStartGame();
              // Navigator.push(
              //     context,
              //     CustomPageRoute(WaitingOnlineRoomPage(
              //       languageModel: widget.languageModel,
              //       isOnline: true,
              //     )));
            }),
      );
    }

    Widget ButtonCancelRoom() {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: ClickyButton(
            color: alertColor,
            shadowColor: alertAccentColor,
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Wrap(
              children: [
                Text(
                  setLanguage.exit,
                  style:
                      primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  CupertinoIcons.square_arrow_left,
                  semanticLabel: 'Add',
                  color: whiteColor,
                ),
              ],
            ),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     CustomPageRoute(WaitingOnlineRoomPage(
              //       languageModel: widget.languageModel,
              //       isOnline: true,
              //     )));
            }),
      );
    }

    AppBar header() {
      return AppBar(
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: primaryColor,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //     // Navigator.pushNamedAndRemoveUntil(
        //     //     context, '/home', (route) => false);
        //   },
        // ),
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.languageModel!.language_name_en}'
                  : '${widget.languageModel!.language_name_id}'),
              style: headerText2.copyWith(
                  fontWeight: extraBold, fontSize: 20, color: primaryTextColor),
            ),
            Text(
              widget.isOnline == true
                  ? '${setLanguage.multi_player}'
                  : '${setLanguage.single_player}',
              style:
                  primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            )
          ],
        ),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: StreamBuilder(
            stream: socketProvider!.streamDataSocket,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              logger.d("waiting online room ${snapshot.data}");

              if (snapshot.hasData) {
                try {
                  var data = json.decode(snapshot.data.toString());
                  if (data['target'] == 'update-player') {
                    RoomMatchDetailModel matchDetailModel =
                        RoomMatchDetailModel.fromJson(data['room_detail']);
                    roomProvider!.updateRoomDetail(matchDetailModel);
                  }

                  ///! menerima status pemain lain
                  if (data['target'] == 'update-status-player') {
                    roomProvider!.updateStatusPlayer(
                        roomDetailId: data['room_detail_id'],
                        status: data['status_player'],
                        isReady: data['is_ready']);
                    if (roomProvider!.checkAllAreReceiveQuestion()) {
                      roomProvider!.updateStatusGame(roomMatch.id, 1);
                      socketProvider!.socketSendStatusGame(
                          channelCode: roomMatch.channel_code ?? '',
                          roomMatch: roomProvider!.roomMatch);
                      logger.d("Game Start ");
                    }
                  }
                } catch (e) {
                  logger.e(e);
                }
              }

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElasticIn(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/logo_putih.png',
                          height: 111.87,
                          width: 84.33,
                        ),
                      ),
                    ),

                    /// * room code  match
                    ElasticIn(
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 14),
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Game Room",
                                      style: blackTextStyle.copyWith(
                                          fontSize: 13, fontWeight: bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${roomMatch.room_code}",
                                      style: blackTextStyle.copyWith(
                                          fontSize: 50, fontWeight: extraBold),
                                    ),
                                  ],
                                ),
                              ),

                              ///* setting up match
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    settingCard(
                                        "${roomMatch.max_player}",
                                        Image.asset(
                                          'assets/images/icon_username.png',
                                          height: 26,
                                          width: 26,
                                        )),
                                    settingCard(
                                        DateFormat('dd MMMMM yyyy').format(
                                            roomMatch.datetime_match ??
                                                DateTime.now()),
                                        Image.asset(
                                          'assets/images/white_clock_icon.png',
                                          height: 26,
                                          width: 26,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),

                    /// * name player has join
                    ElasticIn(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 14),
                        child: Wrap(
                          // children: [
                          //   joinPlayerCard("Giga"),
                          //   joinPlayerCard("Meta"),
                          //   joinPlayerCard("Lica")
                          // ],
                          children: roomMatch.room_match_detail!
                              .map((e) =>
                                  joinPlayerCard('${e.player!.username}'))
                              .toList(),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    btnCreateRoom()
                  ],
                ),
              );
            }),
      );
    }

    return WillPopScope(
        child: Scaffold(
          appBar: header(),
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background_512w.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(child: body()),
              ],
            ),
          ),
          backgroundColor: backgroundColor2,
          bottomNavigationBar: Container(
              height: 90,
              padding: EdgeInsets.all(5),
              child: Column(
                children: [],
              )),
        ),
        onWillPop: () async => false);
  }
}
