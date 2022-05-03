import 'dart:convert';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class WaitingJoinRoomPage extends StatefulWidget {
  late final LanguageModel? languageModel;
  late final bool? isOnline;
  WaitingJoinRoomPage({Key? key, this.languageModel, this.isOnline})
      : super(key: key);

  @override
  State<WaitingJoinRoomPage> createState() => _WaitingJoinRoomPageState();
}

class _WaitingJoinRoomPageState extends State<WaitingJoinRoomPage> {
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
    socketProvider!.socketReceiveFindRoom();
    socketProvider!.socketReceiveStatusPlayer();
    socketProvider!.socketReceiveStatusGame();
    socketProvider!.socketReceiveQuestion();
    // await socketService.fireSocket();
    // await socketService.bindEventSearchRoom();
    // await socketService.bindReceiveStatusPlayer();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    UserModel? user = authProvider!.user;
    RoomMatchModel? roomMatch = roomProvider!.roomMatch!;
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );
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
                      whiteTextStyle.copyWith(fontSize: 14, fontWeight: bold),
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

    Widget body() {
      return SingleChildScrollView(
        child: StreamBuilder(
            stream: socketProvider!.streamDataSocket,
            builder: (context, snapshot) {
              logger.d(snapshot.data);
              String status = "Waiting Host";
              List<WordLanguageModel>? questionList = [];
              if (snapshot.hasData) {
                try {
                  var data = json.decode(snapshot.data.toString());

                  ///! menerima soal dari socket
                  if (data['target'] == 'receive_question') {
                    logger.d(data['question']);
                    // if (!roomProvider!.isGetQuestion) {

                    // }
                    var questions = json.decode(data['question'].toString());
                    for (var itemQuestion in questions) {
                      WordLanguageModel questi =
                          WordLanguageModel.fromJson(itemQuestion);
                      questionList.add(questi);
                    }
                    roomProvider!.setQuestionList(questionList);
                    socketProvider!.socketSendStatusPlayer(
                        channelCode:
                            roomProvider!.roomMatch!.channel_code ?? '',
                        roomMatchDetailModel: roomProvider!
                            .getRoomMatchDetailByUser(
                                userID: user!.id, statusPlayer: 2));
                    // roomProvider!.isGetQuestion = true;
                    status = "Berhasil menerima Pengaturan";
                  }

                  ///! menerima status permainan
                  if (data['target'] == 'update-status-game') {
                    if (int.parse(data['status_game']) == 1) {
                      roomProvider!.updateStatusGame(
                          data['room_id'], int.parse(data['status_game']));
                      logger.d("Game Start ");
                      status = "Permainan Segera Dimulai";
                    }
                  }

                  ///! menerima status pemain lain
                  if (data['target'] == 'update-status-player') {
                    if (int.parse(data['status_player']) == 2) {
                      roomProvider!.updateStatusPlayer(
                          roomDetailId: data['room_detail_id'],
                          status: data['status_player'],
                          isReady: data['is_ready']);
                      logger.d("Menerima status permainan");
                    }
                  }
                } catch (e, t) {
                  logger.e(t);
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

                    ///* setting up match
                    ElasticIn(
                      child: Container(
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
                                "13:15",
                                Image.asset(
                                  'assets/images/white_clock_icon.png',
                                  height: 26,
                                  width: 26,
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElasticIn(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "${status}",
                          style: whiteTextStyle.copyWith(
                              fontWeight: extraBold, fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: ElasticIn(
                          child: Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.topCenter,
                        child: LoadingIndicator(
                            indicatorType: Indicator.lineScalePulseOut,
                            colors: [Colors.white],
                            strokeWidth: 2),
                      )),
                    )
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
                children: [ButtonCancelRoom()],
              )),
        ),
        onWillPop: () async => false);
  }
}
