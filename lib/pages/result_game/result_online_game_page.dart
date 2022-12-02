import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/helper/style_helper.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/connectivity_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ResultOnlineGamePage extends StatefulWidget {
  final LanguageModel? languageModel;
  final double finalTimeRate;
  final double finalScoreRate;
  final LevelModel? level;
  final bool? isCustom;
  const ResultOnlineGamePage(
      {Key? key,
      this.languageModel,
      required this.finalTimeRate,
      required this.finalScoreRate,
      this.level,
      this.isCustom})
      : super(key: key);

  @override
  State<ResultOnlineGamePage> createState() => _ResultOnlineGamePageState();
}

class _ResultOnlineGamePageState extends State<ResultOnlineGamePage> {
  late ConfettiController _confettiController;

  double heightRanks = 0;
  bool _isInitialValue = true;
  SocketProvider? socketProvider;
  AuthProvider? authProvider;
  RoomProvider? roomProvider;
  bool isLoading = true;
  bool onLoading = true;
  RoomMatchModel? roomMatch;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );
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
    handleFinishGame();
    handleRefreshRoom();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );
    Timer(const Duration(milliseconds: 800), () {
      setState(() {
        heightRanks = 300;
        _isInitialValue = false;
      });
      // _confettiController.play();
    });
    super.initState();
  }

  connectSocket() async {
    await socketProvider!.fireStream();
    await socketProvider!.socketEmitJoinRoom(
        channelCode: roomProvider!.roomMatch!.channel_code!,
        matchDetail:
            roomProvider!.getDetailRoomByID(userID: authProvider!.user!.id!));
  }

  getDataSocket() async {
    await socketProvider!.socketReceiveStatusPlayer();
    await socketProvider!.socketReceiveStatusGame();
    await socketProvider!.socketReceiveEndingGameBySchedule();
  }

  handleFinishGame() async {
    try {
      int finalScore =
          ((widget.finalScoreRate + widget.finalTimeRate) * 100).round();

      await roomProvider!.findRoomMatchID(id: roomProvider!.roomMatch!.id);
      setState(() {
        roomMatch = roomProvider!.roomMatch;
      });
      await getDataSocket();
      await socketProvider!.socketSendStatusPlayer(
          channelCode: roomProvider!.roomMatch!.channel_code!,
          roomMatchDetailModel: roomProvider!.getAndUpdateStatusPlayerByID(
              userID: authProvider!.user!.id,
              statusPlayer: 3,
              score: finalScore),
          score: finalScore);
    } catch (e, t) {
      logger.e(e);
      logger.e(t);
    }
  }

  handleNonHostRoom({required int seconds}) async {
    var requestTime = 0;
    Timer.periodic(Duration(seconds: seconds), (timer) async {
      print("run non host");

      if (roomProvider!.roomMatch!.status_game != 2 &&
          roomProvider!.roomMatch!.status_game != 3) {
        await roomProvider!.findRoomMatchID(id: roomProvider!.roomMatch!.id);
        if (roomProvider!.roomMatch!.status_game == 1) {
          roomProvider!.updateStatusGame(roomProvider!.roomMatch!.id, 2);
          socketProvider!.socketSendStatusGame(
              channelCode: roomProvider!.roomMatch!.channel_code!,
              roomMatch: roomProvider!.roomMatch);
        }

        if (roomProvider!.roomMatch!.status_game == 2) {
          roomProvider!.roomMatch!.room_match_detail!
              .sort((now, next) => now.score!.compareTo(next.score ?? 0));

          setState(() {
            roomMatch = roomProvider!.roomMatch;
            onLoading = false;
          });

          _confettiController.play();
          timer.cancel();
        }

        if (requestTime > 2) {
          timer.cancel();
        }
        requestTime++;
      }
    });
  }

  handleRefreshRoom() async {
    if (roomProvider!.checkIsHost(userID: authProvider!.user!.id) == 1) {
      logger.d("Time is running");
      print("run non host");
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        try {
          logger.d("Refresh room update");
          /**
           *  ngecek apakah setelah kedua permainan berakhir, 
           *  namun masih belum menerima status permainan dari permainan lain
           * jadi harus request update dari server
           */

          if (!roomProvider!.checkAllAreGameDone() &&
              roomProvider!.roomMatch!.status_game == 1) {
            await roomProvider!
                .findRoomMatchID(id: roomProvider!.roomMatch!.id);
            /**
             * jika semua permainan selesai maka status game diubah dan disebar
             */
            if (roomProvider!.checkAllAreGameDone() &&
                roomProvider!.roomMatch!.status_game == 1) {
              roomProvider!.updateStatusGame(roomProvider!.roomMatch!.id, 2);

              socketProvider!.socketSendStatusGame(
                  channelCode: roomProvider!.roomMatch!.channel_code!,
                  roomMatch: roomProvider!.roomMatch);
              roomProvider!.roomMatch!.room_match_detail!
                  .sort((now, next) => now.score!.compareTo(next.score ?? 0));

              setState(() {
                roomMatch = roomProvider!.roomMatch;
                onLoading = false;
              });
              _confettiController.play();
              timer.cancel();
            } else if (roomProvider!.roomMatch!.status_game == 2) {
              socketProvider!.socketSendStatusGame(
                  channelCode: roomProvider!.roomMatch!.channel_code!,
                  roomMatch: roomProvider!.roomMatch);
              roomProvider!.roomMatch!.room_match_detail!
                  .sort((now, next) => now.score!.compareTo(next.score ?? 0));

              setState(() {
                roomMatch = roomProvider!.roomMatch;
                onLoading = false;
              });
              _confettiController.play();
              timer.cancel();
            }
          } else {
            /**
             * jika semua permainan selesai maka status game diubah dan disebar
             */
            if (roomProvider!.checkAllAreGameDone() &&
                roomProvider!.roomMatch!.status_game == 1) {
              roomProvider!.updateStatusGame(roomProvider!.roomMatch!.id, 2);
              socketProvider!.socketSendStatusGame(
                  channelCode: roomProvider!.roomMatch!.channel_code!,
                  roomMatch: roomProvider!.roomMatch);
            }

            if (roomProvider!.checkAllAreGameDone() &&
                roomProvider!.roomMatch!.status_game == 2) {
              roomProvider!.roomMatch!.room_match_detail!
                  .sort((now, next) => now.score!.compareTo(next.score ?? 0));

              setState(() {
                roomMatch = roomProvider!.roomMatch;
                onLoading = false;
              });

              _confettiController.play();
              timer.cancel();
            }
          }

          if (roomProvider!.roomMatch!.status_game == 2) {
            print("run is host, when status");
            socketProvider!.socketSendStatusGame(
                channelCode: roomProvider!.roomMatch!.channel_code!,
                roomMatch: roomProvider!.roomMatch);
            roomProvider!.roomMatch!.room_match_detail!
                .sort((now, next) => now.score!.compareTo(next.score ?? 0));

            setState(() {
              roomMatch = roomProvider!.roomMatch;
              onLoading = false;
            });

            _confettiController.play();
            timer.cancel();
          }
        } catch (e) {
          logger.e(e);
          timer.cancel();
        }
      });
    } else {
      await handleNonHostRoom(seconds: 15);
    }
  }

  reconnectSocket() async {
    await socketProvider!.fireStream();
    await socketProvider!.socketReceiveStatusPlayer();
    await socketProvider!.socketReceiveStatusGame();
    await socketProvider!.socketReceiveEndingGameBySchedule();
    if (roomProvider!.roomMatchDetailUser!.status_player != 3) {
      int finalScore =
          ((widget.finalScoreRate + widget.finalTimeRate) * 100).round();
      await socketProvider!.socketSendStatusPlayer(
          channelCode: roomProvider!.roomMatch!.channel_code!,
          roomMatchDetailModel: roomProvider!.getAndUpdateStatusPlayerByID(
              userID: authProvider!.user!.id,
              statusPlayer: 3,
              score: finalScore),
          score: finalScore);
    }
    if (roomProvider!.roomMatch!.status_game == 1) {
      await handleNonHostRoom(seconds: 5);
    } else if (roomProvider!.roomMatch!.status_game == 2) {
      roomProvider!.roomMatch!.room_match_detail!
          .sort((now, next) => now.score!.compareTo(next.score ?? 0));

      setState(() {
        roomMatch = roomProvider!.roomMatch;
        onLoading = false;
      });

      _confettiController.play();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socketProvider!.pausedStream();
    _confettiController.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    UserModel? user = authProvider!.user;
    bool isDisconnected = false;
    bool isShow = false;
    int reconnectTimes = 0;
    // RoomMatchModel? roomMatch = roomProvider!.roomMatch!;
    // bool onLoading = true;

    _connectivityProvider?.streamConnectivity.listen(
      (event) {
        if (event.keys.toList()[0] == ConnectivityResult.none) {
          print('on Disconnect');
          isDisconnected = true;
          if (isShow == false) {
            isShow = true;
            Timer.periodic(const Duration(seconds: 5), (timer) async {
              print("on reconnecting : result");
              if (!isDisconnected) {
                print('connecting');
                await reconnectSocket();
                timer.cancel();
                print('back to connecting');
              }
              if (reconnectTimes > 2) {
                timer.cancel();
                logger.d("Stop reconnecting to server");

                if (socketProvider!.isConnected) {
                  await socketProvider!.disconnect();
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 1000),
                  content: Text(
                    "Koneksi terputus, semua pemain keluar dari lobi permainan!",
                    textAlign: TextAlign.center,
                    style: primaryTextStyle.copyWith(
                        fontWeight: bold, fontSize: 20),
                  ),
                  backgroundColor: whiteColor,
                ));
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              }

              reconnectTimes++;
            });
          }

          if (event.keys.toList()[0] != ConnectivityResult.none) {
            isDisconnected = false;
            reconnectTimes = 0;
            // bakal jalanin ketika host terhubung dengan server
          }
        }
      },
    );

    Widget textHeader() {
      return Container(
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Column(
              children: [
                Text(
                  (setLanguage.code == 'en'
                      ? '${widget.languageModel?.language_name_en}'
                      : '${widget.languageModel?.language_name_id}'),
                  textAlign: TextAlign.center,
                  style:
                      whiteTextStyle.copyWith(fontSize: 32, fontWeight: bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  '${widget.level?.level_name}',
                  style:
                      whiteTextStyle.copyWith(fontSize: 23, fontWeight: bold),
                ),
              ],
            ),
          ));
    }

    Widget backtoMenu() {
      return Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: ButtonBounce(
            onClick: () {
              socketProvider!.disconnectService();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            color: redColor,
            borderColor: redColor2,
            shadowColor: redColor3,
            widthButton: 245,
            heightButton: 60,
            child: Center(
              child: Text(
                setLanguage.back_to_menu,
                style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
              ),
            )),
      );
    }

    Path drawStar(Size size) {
      double degToRad(double deg) => deg * (pi / 180.0);

      const numberOfPoints = 5;
      final halfWidth = size.width / 2;
      final externalRadius = halfWidth;
      final internalRadius = halfWidth / 2.5;
      final degreesPerStep = degToRad(360 / numberOfPoints);
      final halfDegreesPerStep = degreesPerStep / 2;
      final path = Path();
      final fullAngle = degToRad(360);
      path.moveTo(size.width, halfWidth);

      for (double step = 0; step < fullAngle; step += degreesPerStep) {
        path.lineTo(halfWidth + externalRadius * cos(step),
            halfWidth + externalRadius * sin(step));
        path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
            halfWidth + internalRadius * sin(step + halfDegreesPerStep));
      }
      path.close();
      return path;
    }

    Widget rankCard(RoomMatchDetailModel? roomDetail, int? rank) {
      RoomMatchDetailModel? roomUser = roomProvider!.roomMatchDetailUser;
      bool isRoomUser = (roomDetail!.id == roomUser!.id) ? true : false;
      String rankImage = StyleHelper.getImageRank(rank);
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isRoomUser ? whiteColor : primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: isRoomUser ? backgroundColor2 : whiteColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Text(
                    "$rank",
                    style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: bold,
                        color: isRoomUser ? whiteColor : blackColor),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  child: Text(
                    "${roomDetail.player!.username}",
                    style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: bold,
                        color: isRoomUser ? blackColor : whiteColor),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: (rank! < 4 && rank > 0)
                      ? Image.asset(
                          'assets/images/$rankImage',
                          height: 30,
                          width: 30,
                        )
                      : Container()),
              const SizedBox(
                width: 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: 60,
                child: Text(
                  "${roomDetail.score}",
                  textAlign: TextAlign.right,
                  style: blackTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: bold,
                      color: isRoomUser ? blackColor : whiteColor),
                ),
              ),
            ],
          ));
    }

    Widget cardBody() {
      roomProvider!.roomMatch!.room_match_detail!
          .sort((now, next) => -now.score!.compareTo(next.score ?? 0));
      List<RoomMatchDetailModel>? listDetail =
          roomProvider!.roomMatch!.room_match_detail;
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 80, left: 5, right: 5),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            ElasticIn(child: textHeader()),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: listDetail!.map((e) {
                  return AnimationConfiguration.staggeredList(
                      position: listDetail.indexOf(e),
                      child: SlideAnimation(
                        horizontalOffset: 50,
                        child: FadeInAnimation(
                            child: rankCard(e, listDetail.indexOf(e) + 1)),
                      ));
                }).toList(),
              ),
            ),
            // ),
          ],
        ),
      );
    }

    Widget cardBodyOnLoad() {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 80, left: 10, right: 10),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              ElasticIn(child: textHeader()),
              const SizedBox(
                height: 8,
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
          ));
    }

    Widget body() {
      /**
       * 1. panggil data room baru dan detail dari server
       * 1. kirim/bagi hasil ke pemain lain
       * 2. nunggu semua pemain sudah selesai main 
       * 3. time up, (misal ada yg ga nyelesain permainan, maka otomatis buat bar ranks)
       * 3. munculin bar ranks
       * 4. update status game selesai
       * 5. selesai
       */

      socketProvider!.statusPlayerStream.listen(
        (source) {
          print("on statusPlayerStream result");
          try {
            var data = json.decode(source.toString());
            if (data['target'] == 'update-status-player') {
              roomProvider!.updateStatusPlayer(
                  roomDetailId: data['room_detail_id'],
                  status: data['status_player'],
                  isReady: data['is_ready'],
                  score: data['score']);
              //! jika host maka akan update status game
              roomProvider!.roomMatch!.room_match_detail!
                  .sort((now, next) => now.score!.compareTo(next.score ?? 0));
              roomMatch = roomProvider!.roomMatch;
            }

            logger.d(
                "check all are game done => ${roomProvider!.checkAllAreGameDone()}");
          } catch (e) {
            logger.e("statusPlayerStream" + e.toString());
          }
        },
      );

      socketProvider!.statusGameStream.listen((source) {
        print("on statusGameStream result");
        var data = json.decode(source.toString());
        try {
          if (data['target'] == 'update-status-game' &&
              data['status_game'] == 2) {
            roomProvider!.updateStatusGame(data['room_id'], 2);
            onLoading = false;
            roomProvider!.roomMatch!.room_match_detail!
                .sort((now, next) => now.score!.compareTo(next.score ?? 0));
            roomMatch = roomProvider!.roomMatch;
            _confettiController.play();
          }
        } catch (e) {
          logger.e("statusGameStream" + e.toString());
        }
      });

      socketProvider!.endingBySchedulingStream.listen((source) {
        print("on ending Game Result ");
        var data = json.decode(source.toString());
        try {
          if (data['target'] == 'ending-game-by-schedule') {
            RoomMatchModel roomMatch = RoomMatchModel.fromJson(data['data']);
            if (roomMatch.id == roomProvider!.roomMatch!.id) {
              roomProvider!.roomMatch = roomMatch;
            }
          }
        } catch (e) {
          logger.e("ending game result" + e.toString());
        }
      });

      return StreamBuilder(
          stream: socketProvider!.streamDataSocket,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              try {
                var data = json.decode(snapshot.data.toString());
                logger.d("data  => ${data.toString()}");
                //! mengecek status pemain
                // if (data['target'] == 'update-status-player') {
                //   roomProvider!.updateStatusPlayer(
                //       roomDetailId: data['room_detail_id'],
                //       status: data['status_player'],
                //       isReady: data['is_ready'],
                //       score: data['score']);
                //   //! jika host maka akan update status game
                //   roomMatch = roomProvider!.roomMatch;
                // }
                // logger.d(
                //     "is host=> ${roomProvider!.checkIsHost(userID: user!.id)}");
                // logger.d(
                //     "check all are game done => ${roomProvider!.checkAllAreGameDone()}");

                if (roomProvider!.checkIsHost(userID: user!.id) == 1) {
                  if (roomProvider!.checkAllAreGameDone() &&
                      roomProvider!.roomMatch!.status_game == 1) {
                    roomProvider!.updateStatusGame(roomMatch!.id, 2);

                    socketProvider!.socketSendStatusGame(
                        channelCode: roomMatch!.channel_code!,
                        roomMatch: roomProvider!.roomMatch);
                    roomProvider!.roomMatch!.room_match_detail!.sort(
                        (now, next) => now.score!.compareTo(next.score ?? 0));
                    roomMatch = roomProvider!.roomMatch;
                    onLoading = false;
                    _confettiController.play();
                  }
                }

                // if (data['target'] == 'update-status-game') {
                //   if (roomProvider!.checkIsHost(userID: user.id) == 0 &&
                //       roomProvider!.roomMatch!.status_game == 1) {
                //     if (data['status_game'] == 2) {
                //       roomProvider!.updateStatusGame(
                //           data['room_id'], data['status_game']);
                //       onLoading = false;
                //       roomProvider!.roomMatch!.room_match_detail!.sort(
                //           (now, next) => now.score!.compareTo(next.score ?? 0));
                //       roomMatch = roomProvider!.roomMatch;
                //       _confettiController.play();
                //     }
                //   }
                // }
              } catch (e, t) {
                logger.e(t);
              }
              return onLoading ? cardBodyOnLoad() : cardBody();
            } else {
              return onLoading ? cardBodyOnLoad() : cardBody();
            }
          });
    }

    Widget confettiStar() {
      return ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality
            .explosive, // don't specify a direction, blast randomly
        shouldLoop: true, // start again as soon as the animation is finished
        colors: const [
          Color(0xffFD47F6),
          Color(0xffFF7CFA),
          Color(0xffFF00F5),
          Color(0xffBD00B6),
          Color(0xffF5BCF3),
          Color(0xffFF00F5)
        ], // manually specify the colors to be used
        createParticlePath: drawStar, // define a custom shape/path.
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: primaryColor5,
        body: Stack(
          fit: StackFit.expand,
          children: [
            body(),
            Align(
              alignment: Alignment.topCenter,
              child: confettiStar(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(color: whiteColor),
            height: 90,
            child: backtoMenu()),
      ),
    );
  }
}
