import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class ResultOnlineGamePage extends StatefulWidget {
  final LanguageModel? languageModel;
  final double finalTimeRate;
  final double finalScoreRate;
  final LevelModel? level;
  final bool? isCustom;
  ResultOnlineGamePage(
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
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  @override
  void initState() {
    // TODO: implement initState

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    connectSocket();
    handleFinishGame();
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
        playerCode: authProvider!.user!.userCode!);
    await socketProvider!.socketReceiveStatusPlayer();
    await socketProvider!.socketReceiveStatusGame();
  }

  handleFinishGame() async {
    try {
      int finalScore =
          ((widget.finalScoreRate + widget.finalTimeRate) * 100).round();

      await roomProvider!.findRoomMatchID(id: roomProvider!.roomMatch!.id);
      await socketProvider!.socketSendStatusPlayer(
          channelCode: roomProvider!.roomMatch!.channel_code!,
          roomMatchDetailModel: roomProvider!.getRoomMatchDetailByUser(
              userID: authProvider!.user!.id, statusPlayer: 3),
          score: finalScore);
    } catch (e, t) {
      logger.e(e);
      logger.e(t);
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
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    UserModel? user = authProvider!.user;
    RoomMatchModel? roomMatch = roomProvider!.roomMatch!;
    bool onLoading = true;

    Widget textHeader() {
      return Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          padding: EdgeInsets.symmetric(vertical: 10),
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
                SizedBox(
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

    Widget BacktoMenu() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ClickyButton(
            onPressed: isLoading
                ? () {}
                : () {
                    socketProvider!.disconnectService();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  },
            color: alertColor,
            shadowColor: alertAccentColor,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Text(
              "${setLanguage.back_to_menu}",
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: bold),
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

    Widget barRank(int number_rank, RoomMatchDetailModel roomMatchDetail) {
      double heightBar = 0;
      switch (number_rank) {
        case 1:
          heightBar = 10;
          break;
        case 2:
          heightBar = 100;
          break;
        case 3:
          heightBar = 150;
          break;
        default:
          heightBar = 10;
          break;
      }
      return Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: heightBar, bottom: 5),
          padding: EdgeInsets.only(top: 5),
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: barColor),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "${number_rank}",
                style: whiteTextStyle.copyWith(fontSize: 36, fontWeight: bold),
              ),
            ),
          ),
        ),
      );
    }

    Widget platePlayer(int rank) {
      return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: purpleCard,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Text",
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: whiteTextStyle.copyWith(
                          fontSize: 16, fontWeight: bold),
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: blackColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "70",
                    textAlign: TextAlign.center,
                    style:
                        whiteTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget rankBars() {
      return AnimatedContainer(
        transform:
            _isInitialValue ? Matrix4.identity() : Matrix4.rotationX(100),
        duration: Duration(milliseconds: 800),
        height: heightRanks,
        margin: const EdgeInsets.only(top: 5),
        child: Row(
          children: roomMatch!.room_match_detail!.length >= 3
              ? [
                  barRank(2, roomMatch!.room_match_detail![1]),
                  barRank(1, roomMatch!.room_match_detail![0]),
                  barRank(3, roomMatch!.room_match_detail![2])
                ]
              : roomMatch!.room_match_detail!
                  .map((e) =>
                      barRank(roomMatch!.room_match_detail!.indexOf(e) + 1, e))
                  .toList(),
        ),
      );
    }

    Widget rankPlayers() {
      return Container(
        child: Row(
          children: [platePlayer(2), platePlayer(1), platePlayer(3)],
        ),
      );
    }

    Widget yourRank() {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: blackColor, borderRadius: BorderRadius.circular(5)),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Text(
                    "4",
                    style:
                        whiteTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                child: Container(
                  child: Text(
                    "Nama",
                    style:
                        blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  "70",
                  style:
                      blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                ),
              ),
            ],
          ));
    }

    Widget cardBody() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 80, left: 10, right: 10),
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            ElasticIn(child: textHeader()),
            const SizedBox(
              height: 8,
            ),
            ElasticIn(
              child: rankBars(),
            ),
            ElasticIn(
                delay: const Duration(milliseconds: 1500),
                child: rankPlayers()),
            const SizedBox(
              height: 10,
            ),
            ElasticIn(
                delay: const Duration(milliseconds: 1500), child: yourRank()),
            BacktoMenu()
          ],
        ),
      );
    }

    Widget cardBodyOnLoad() {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 80, left: 10, right: 10),
          padding: EdgeInsets.all(5),
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
      return StreamBuilder(
          stream: socketProvider!.streamDataSocket,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              try {
                var data = json.decode(snapshot.data.toString());
                logger.d("data  => ${data.toString()}");
                //! mengecek status pemain
                if (data['target'] == 'update-status-player') {
                  roomProvider!.updateStatusPlayer(
                      roomDetailId: data['room_detail_id'],
                      status: data['status_player'],
                      isReady: data['is_ready'],
                      score: data['score']);
                  //! jika host maka akan update status game
                  roomMatch = roomProvider!.roomMatch;
                }
                logger.d(
                    "is host=> ${roomProvider!.checkIsHost(userID: user!.id)}");
                logger.d(
                    "check all are game done => ${roomProvider!.checkAllAreGameDone()}");

                if (roomProvider!.checkIsHost(userID: user.id) == 1) {
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

                if (data['target'] == 'update-status-game') {
                  if (roomProvider!.checkIsHost(userID: user.id) == 0 &&
                      roomProvider!.roomMatch!.status_game == 0) {
                    if (data['status_game'] == 2) {
                      roomProvider!.updateStatusGame(
                          data['room_id'], data['status_game']);
                      onLoading = false;
                      roomProvider!.roomMatch!.room_match_detail!.sort(
                          (now, next) => now.score!.compareTo(next.score ?? 0));
                      roomMatch = roomProvider!.roomMatch;
                      _confettiController.play();
                    }
                  }
                }
              } catch (e, t) {
                logger.e(t);
              }
              return onLoading ? cardBodyOnLoad() : cardBody();
            } else {
              return cardBodyOnLoad();
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
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ], // manually specify the colors to be used
        createParticlePath: drawStar, // define a custom shape/path.
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor2,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background_512w.png"),
                    fit: BoxFit.cover)),
          ),
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: body(),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: confettiStar(),
          ),
        ],
      ),
    );
  }
}
