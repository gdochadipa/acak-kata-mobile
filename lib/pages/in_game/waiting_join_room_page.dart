import 'dart:async';
import 'dart:convert';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/relation_word.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/models/word_language_model.dart';
import 'package:acakkata/pages/in_game/modal/room_exit_modal.dart';
import 'package:acakkata/pages/in_game/online_game_play_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/connectivity_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
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
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
  ConnectivityProvider? _connectivityProvider;

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
    socketProvider!.socketReceiveFindRoom();
    socketProvider!.socketReceiveQuestion();
    socketProvider!.socketReceiveStatusPlayer();
    socketProvider!.socketReceiveStatusGame();
    socketProvider!.socketReceiveUserDisconnect();
    socketProvider!.socketReceiveExitRoom();

    // await socketService.fireSocket();
    // await socketService.bindEventSearchRoom();
    // await socketService.bindReceiveStatusPlayer();
  }

  reconnectSocket() async {
    socketProvider!.restartStream();
    await roomProvider!.findRoomMatchID(id: roomProvider!.roomMatch!.id);

    if (await roomProvider!
        .checkingRoomWithCode("1", roomProvider!.roomMatch!.room_code)) {
      RoomMatchDetailModel? roomSend = roomProvider!.listRoommatchDet!
          .where((detail) => detail.player_id! == authProvider!.user!.id)
          .first;
      roomSend.is_ready = 1;
      await socketProvider!.socketSendJoinRoom(
          channelCode: '${roomProvider!.roomMatch!.channel_code}',
          playerCode: '${authProvider!.user!.id}',
          languageCode: '${roomProvider!.roomMatch!.language!.language_code}',
          roomMatchDet: roomSend);
      socketProvider!.socketReceiveFindRoom();
      socketProvider!.socketReceiveQuestion();
      socketProvider!.socketReceiveStatusPlayer();
      socketProvider!.socketReceiveStatusGame();
      socketProvider!.socketReceiveUserDisconnect();
      socketProvider!.socketReceiveExitRoom();
      socketProvider!.socketReceiveChangeHost();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socketProvider!.pausedStream();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    UserModel? user = authProvider!.user;
    bool isShow = false;
    bool isDisconnected = false;
    int reconnectTimes = 0;
    RoomMatchModel? roomMatch = roomProvider!.roomMatch!;
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );
    List<RelationWordModel>? questionList = [];

    _connectivityProvider?.streamConnectivity.listen((source) {
      if (source.keys.toList()[0] == ConnectivityResult.none) {
        isDisconnected = true;
        print('on Disconnect');
        // bakal jalanin ketika host disconnect
        if (isShow == false) {
          isShow = true;
          Timer.periodic(const Duration(milliseconds: 10000), (timer) async {
            print("on reconnecting");
            // await reconnectToServer();
            if (!isDisconnected) {
              await reconnectSocket();
              print('connecting');
              timer.cancel();
              print('back to connecting');
            }
            if (reconnectTimes > 2) {
              timer.cancel();
              logger.d("Stop reconnecting to server");
            }
            reconnectTimes++;
          });
        }
      }

      if (source.keys.toList()[0] != ConnectivityResult.none) {
        isDisconnected = false;
        reconnectTimes = 0;
        // bakal jalanin ketika host terhubung dengan server
      }
    });

    handleExitRoom(
        {required String roomId,
        required String channelCode,
        required String playerId}) async {
      // socketProvider!
      //     .sendExitRoom(channelCode: channelCode, playerId: playerId);

      try {
        if (await roomProvider!.cancelGameFromRoom(roomId)) {
          //send socket to exit
          socketProvider!
              .sendExitRoom(channelCode: channelCode, playerId: playerId);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(milliseconds: 1000),
            content: Text(
              "${S.of(context).exit_room} !",
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 20),
            ),
            backgroundColor: whiteColor,
          ));
          // socketProvider!.disconnectService();

          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        }
      } catch (e) {
        logger.e(e);
      }
    }

    AppBar header() {
      return AppBar(
        leading: Container(),
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              (setLanguage.code == 'en'
                  ? '${widget.languageModel!.language_name_en}'
                  : '${widget.languageModel!.language_name_id}'),
              style: headerText2.copyWith(
                  fontWeight: black, fontSize: 20, color: whiteColor),
            ),
            Text(
              widget.isOnline == true
                  ? setLanguage.multi_player
                  : setLanguage.single_player,
              style:
                  whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            )
          ],
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

    Widget buttonCancelRoom() {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: ButtonBounce(
            color: redColor,
            borderColor: redColor2,
            shadowColor: redColor3,
            widthButton: 245,
            heightButton: 50,
            child: Center(
              child: Wrap(
                children: [
                  Text(
                    setLanguage.exit,
                    style:
                        whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
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
            ),
            onClick: () {
              handleExitRoom(
                  channelCode: roomMatch.channel_code!,
                  playerId: user!.id!,
                  roomId: roomMatch.id!);
            }),
      );
    }

    Widget body() {
      String status = setLanguage.waiting_host;
      socketProvider!.userDisconnectStream.listen((source) {
        print("on userDisconnectStream Receive Data");
        try {
          var data = json.decode(source.toString());
          if (data['target'] == 'user-disconnected') {
            roomProvider!
                .removePlayerFromRoomMatchDetail(player_id: data['player_id']);
            print('user-disconnected ${data['player_id']}');
          }
        } catch (e) {
          logger.e("userDisconnectStream :" + e.toString());
        }
      });

      socketProvider!.setRoomStream.listen((source) {
        print("on setRoomStream Receive Data");
        try {
          var data = json.decode(source.toString());
          if (data['target'] == 'update-player') {
            RoomMatchDetailModel matchDetailModel =
                RoomMatchDetailModel.fromJson(data['room_detail']);
            roomProvider!.updateRoomDetail(matchDetailModel);
          }
        } catch (e) {
          logger.e("setRoomStream" + e.toString());
        }
      });
      socketProvider!.questionStream.listen((source) {
        print("on questionStream Receive Data");
        try {
          var data = json.decode(source.toString());
          if (data['target'] == 'receive_question') {
            // var questions = null;
            // if (data['encyrpt'] == false) {
            //   questions = json.decode(data['question'].toString());
            // } else {

            // }
            var questionUtf = utf8.decode(base64.decode(data['question']));
            var questions = json.decode(questionUtf);

            logger.d("data => ${questions != null}");
            if (questions != null) {
              for (var itemQuestion in questions) {
                logger.d(itemQuestion);
                RelationWordModel questi =
                    RelationWordModel.fromJson(itemQuestion);
                questionList.add(questi);
              }
              roomProvider!.setRelatedQuestionList(questionList);
              socketProvider!.socketSendStatusPlayer(
                  channelCode: roomProvider!.roomMatch!.channel_code ?? '',
                  roomMatchDetailModel: roomProvider!
                      .getAndUpdateStatusPlayerByID(
                          userID: user!.id, statusPlayer: 2),
                  score: 0);
            }
            // roomProvider!.isGetQuestion = true;
            status = setLanguage.receive_setting;
          }
        } catch (e, stacktrace) {
          logger.e("questionStream:" + e.toString());
          print('Stacktrace: ' + stacktrace.toString());
        }
      });

      socketProvider!.statusGameStream.listen((source) {
        print("on statusGameStream Receive Data");
        try {
          var data = json.decode(source.toString());
          if (data['target'] == 'update-status-game') {
            if (data['status_game'] == 1) {
              roomProvider!
                  .updateStatusGame(data['room_id'], data['status_game']);
              logger.d("Game Start ");
              status = setLanguage.start_game;
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
                      isHost: 0,
                      levelWords: roomMatch.length_word,
                      isOnline: true,
                      Stage: setLanguage.custom_level,
                      levelModel: levelModel,
                      isCustom: false,
                    )),
                    (route) => false);
              });
            }
          }
        } catch (e) {
          logger.e("statusGameStream:" + e.toString());
        }
      });

      socketProvider!.statusPlayerStream.listen((source) {
        print("on statusPlayerStream Receive Data");
        try {
          var data = json.decode(source.toString());
          if (data['target'] == 'update-status-player' &&
              data['status_player'] == 2) {
            logger.d("data update-status-player => $data");
            if (data['status_player'] == 2) {
              roomProvider!.updateStatusPlayer(
                  roomDetailId: data['room_detail_id'],
                  status: data['status_player'],
                  isReady: data['is_ready']);
              status = setLanguage.receive_status_player;
              logger.d("Menerima status permainan");
            }
          }
        } catch (e) {
          logger.e("statusPlayerStream:" + e.toString());
        }
      });

      socketProvider!.hostExitRoomStream.listen((source) {
        print("on hostExitRoomStream Receive Data");
        try {
          var data = json.decode(source.toString());
          if (data['target'] == 'host-exit-room') {
            print("host-exit-room is disconnect");
            socketProvider!.disconnectService();
            showModal(
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
        } catch (e) {
          logger.e("hostExitRoomStream:" + e.toString());
        }
      });

      return SingleChildScrollView(
        child: StreamBuilder(
            stream: socketProvider!.streamDataSocket,
            builder: (context, snapshot) {
              // logger.d(snapshot.data);
              if (snapshot.hasData) {
                try {
                  var data = json.decode(snapshot.data.toString());
                } catch (e, t) {
                  logger.e(t);
                }
              }

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ElasticIn(
                    //   child: Container(
                    //     alignment: Alignment.topCenter,
                    //     child: Image.asset(
                    //       'assets/images/logo_putih.png',
                    //       height: 111.87,
                    //       width: 84.33,
                    //     ),
                    //   ),
                    // ),

                    ///* setting up match
                    ElasticIn(
                      child: Container(
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
                    const SizedBox(
                      height: 15,
                    ),
                    ElasticIn(
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                          status,
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
                        child: const LoadingIndicator(
                            indicatorType: Indicator.circleStrokeSpin,
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
                Container(child: body()),
              ],
            ),
          ),
          backgroundColor: primaryColor5,
          bottomNavigationBar: Container(
              height: 90,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [buttonCancelRoom()],
              )),
        ),
        onWillPop: () async => false);
  }
}
