import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/helper/style_helper.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/pages/in_game/modal/room_exit_modal.dart';
import 'package:acakkata/pages/in_game/online_game_play_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/connectivity_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/service/connectivity_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  ConnectivityProvider? _connectivityProvider;
  SocketProvider? socketProvider;
  AuthProvider? authProvider;
  RoomProvider? roomProvider;
  bool hasStart = false;

  @override
  void initState() {
    // TODO: implement initState
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    _connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    connectSocket();
    super.initState();
  }

  connectSocket() async {
    socketProvider!.restartStream();
    socketProvider!.socketEmitJoinRoom(
        channelCode: '${roomProvider!.roomMatch!.channel_code}',
        matchDetail:
            roomProvider!.getDetailRoomByID(userID: authProvider!.user!.id));
    socketProvider!.socketReceiveFindRoom();
    socketProvider!.socketReceiveStatusPlayer();
    socketProvider!.socketReceiveUserDisconnect();
    socketProvider!.socketReceiveStartingGameBySchedule();
    socketProvider!.bindOnDisconnect();
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
    socketProvider!.pausedStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    UserModel? user = authProvider!.user;
    bool isDisconnected = false;
    bool isShow = false;
    RoomMatchModel? roomMatch = roomProvider!.roomMatch!;
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );

    Future<void> showIsDisconnectModal() async {
      return showModal(
          context: context,
          builder: (BuildContext context) {
            final theme = Theme.of(context);
            return const Dialog(
              insetAnimationCurve: Curves.easeInOut,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(),
              child: RoomExitModal(),
            );
          });
    }

    _connectivityProvider?.streamConnectivity.listen((source) {
      if (source.keys.toList()[0] == ConnectivityResult.none) {
        isDisconnected = true;
        // bakal jalanin ketika host disconnect
        if (isShow == false) {
          isShow = true;
        }
      }

      if (source.keys.toList()[0] != ConnectivityResult.none) {
        isDisconnected = false;
        // bakal jalanin ketika host terhubung dengan server
      }
    });

    actionStartMatch() async {
      print("on action");
      print("action start");
      roomProvider!.updateStatusGame(roomMatch.id, 1);
      socketProvider!.socketSendStatusGame(
          channelCode: roomMatch.channel_code ?? '',
          roomMatch: roomProvider!.roomMatch);
      logger.d("Game Start ");
      Timer(const Duration(milliseconds: 1000), () {
        socketProvider!.pausedStream();
        LevelModel levelModel = LevelModel(
            id: 77,
            level_name: setLanguage.custom_level,
            level_words: roomMatch.length_word,
            level_time: roomMatch.time_match,
            level_lang_code: setLanguage.code,
            level_lang_id: setLanguage.code,
            current_score: 0,
            target_score: 0);
        Navigator.pushAndRemoveUntil(
          context,
          CustomPageRoute(OnlineGamePlayPage(
            languageModel: widget.languageModel,
            selectedQuestion: roomMatch.totalQuestion,
            selectedTime: roomMatch.time_match,
            isHost: 1,
            levelWords: roomMatch.length_word,
            isOnline: true,
            Stage: setLanguage.custom_level,
            levelModel: levelModel,
            isCustom: false,
          )),
          (route) => false,
        );
      });
    }

    ///1. get question berdasarkan setting room match
    ///!3. share soal dan status game lewat socket
    /// !4. tunggu update kalo semua pemain udah dapet soal (receive socket)
    /// 5. ketika semua pemain udah dapet soal,
    /// !baru update status game mulai dan share lewat socket
    handleStartGame() async {
      try {
        if (await roomProvider!.getPackageQuestion(
            roomMatch.language!.language_code, roomMatch.channel_code)) {
          var questions = base64
              .encode(utf8.encode(json.encode(roomProvider!.listQuestion)));
          await socketProvider!.socketSendQuestion(
              channelCode: roomMatch.channel_code!,
              languageCode: roomMatch.language!.language_code!,
              playerId: user!.id!,
              question: questions);
        } else {
          logger.e("gagal");
        }

        // send status
        RoomMatchDetailModel matchDetail = roomProvider!
            .getAndUpdateStatusPlayerByID(userID: user!.id, statusPlayer: 2);

        await socketProvider!.socketSendStatusPlayer(
            channelCode: roomMatch.channel_code!,
            roomMatchDetailModel: matchDetail,
            score: 0);

        Timer(const Duration(milliseconds: 5000), () async {
          if (!hasStart) {
            actionStartMatch();
            setState(() {
              hasStart = true;
            });
          }
        });
      } catch (e, trace) {
        logger.e(e);
        logger.e(trace);
      }
    }

    Widget joinPlayerCard(
        {required String usernamePlayer,
        required color,
        required Color borderColor,
        required Color shadowColor}) {
      return ElasticIn(
        child: Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor, width: 3),
              boxShadow: [BoxShadow(color: shadowColor, offset: Offset(0, 3))]),
          child: Container(
              margin: const EdgeInsets.all(5),
              child: Text(
                usernamePlayer,
                style:
                    whiteTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
              )),
        ),
      );
    }

    Widget settingCard(String information, Image iconInfo) {
      return Container(
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: primaryColor2, width: 4),
            boxShadow: [
              BoxShadow(color: primaryColor3, offset: const Offset(0, 4))
            ]),
        child: Container(
          margin: const EdgeInsets.all(5),
          child: Row(
            children: [
              iconInfo,
              const SizedBox(
                width: 7,
              ),
              Text(
                information,
                style:
                    whiteTextStyle.copyWith(fontSize: 15, fontWeight: semiBold),
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
        child: ButtonBounce(
            color: whiteColor,
            borderColor: whiteColor2,
            shadowColor: whiteColor3,
            widthButton: 245,
            heightButton: 60,
            child: Center(
              child: Wrap(
                children: [
                  Text(
                    'Bermain',
                    style: primaryTextStyle.copyWith(
                        fontSize: 18, fontWeight: bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/images/arrow_blue.png',
                    height: 25,
                    width: 25,
                  )
                ],
              ),
            ),
            onClick: () {
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

    Widget buttonCancelRoom() {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: ClickyButton(
            color: alertColor,
            shadowColor: alertAccentColor,
            margin:
                const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Wrap(
              children: [
                Text(
                  setLanguage.exit,
                  style:
                      primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
                const SizedBox(
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
        leading: Container(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Image.asset(
                'assets/images/${widget.languageModel!.language_icon}',
                width: 30,
                height: 30,
              ),
            )),
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (setLanguage.code == 'en'
                        ? '${widget.languageModel!.language_name_en}'
                        : '${widget.languageModel!.language_name_id}'),
                    style: whiteTextStyle.copyWith(
                      fontWeight: extraBold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.isOnline == true
                        ? setLanguage.multi_player
                        : setLanguage.single_player,
                    style: whiteTextStyle.copyWith(
                        fontSize: 14, fontWeight: medium),
                  ),
                )
              ],
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

                  /**
                   * ketika pemain lain keluar dari permainan
                   */
                  if (data['target'] == 'user-disconnected') {
                    roomProvider!.removePlayerFromRoomMatchDetail(
                        player_id: data['player_id']);
                    print('user-disconnected ${data['player_id']}');
                  }

                  /** ketika pemain baru bergabung */
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
                      if (!hasStart) {
                        actionStartMatch();
                        hasStart = true;
                      }
                    }
                  }

                  if (data['target'] == 'starting-game-by-schedule') {
                    logger.d("starting-game-by-schedule is run");
                    handleStartGame();
                  }
                } catch (e) {
                  logger.e(e);
                }
              }

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElasticIn(
                      child:

                          ///* setting up match
                          Container(
                        margin: const EdgeInsets.only(top: 20),
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
                                DateFormat('dd MMMM yyyy').format(
                                    roomMatch.datetime_match ?? DateTime.now()),
                                Image.asset(
                                  'assets/images/white_clock_icon.png',
                                  height: 26,
                                  width: 26,
                                ))
                          ],
                        ),
                      ),
                    ),

                    /// * room code  match
                    ElasticIn(
                      child: Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(vertical: 14),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Game Room",
                                        style: blackTextStyle.copyWith(
                                            fontSize: 15, fontWeight: black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${roomMatch.room_code}",
                                        style: blackTextStyle.copyWith(
                                            fontSize: 50, fontWeight: black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),

                    /// * name player has join
                    ElasticIn(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 14),
                        child: Wrap(
                          // children: [
                          //   joinPlayerCard("Giga"),
                          //   joinPlayerCard("Meta"),
                          //   joinPlayerCard("Lica")
                          // ],
                          children: roomMatch.room_match_detail!.map((e) {
                            int num = StyleHelper.getRandomNumInt(0, 4);
                            return joinPlayerCard(
                                usernamePlayer: '${e.player!.username}',
                                color: StyleHelper.getColorRandom('color', num),
                                borderColor: StyleHelper.getColorRandom(
                                    'borderColor', num),
                                shadowColor: StyleHelper.getColorRandom(
                                    'shadowColor', num));
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(
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
          backgroundColor: primaryColor5,
          body: SafeArea(
            child: Stack(
              children: [
                Container(child: body()),
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
