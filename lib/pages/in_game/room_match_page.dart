import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/player_profile.dart';
import 'package:acakkata/widgets/skeleton/player_profile_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RoomMatchPage extends StatefulWidget {
  // const RoomMatchPage({ Key? key }) : super(key: key);

  late final LanguageModel language;

  RoomMatchPage(this.language);

  @override
  State<RoomMatchPage> createState() => _RoomMatchPageState();
}

class _RoomMatchPageState extends State<RoomMatchPage> {
  SocketService socketService = SocketService();

  @override
  void initState() {
    // TODO: implement initState
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
    await socketService.bindEventSearchRoom();
    await socketService.bindReceiveStatusPlayer();
  }

  disconnectSocket() async {
    await socketService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    UserModel? user = authProvider.user;
    RoomProvider roomProvider = Provider.of<RoomProvider>(context);
    RoomMatchModel? roomMatch = roomProvider.roomMatch!;
    List<bool> isReadyPlayer = [false, false];
    bool afterConfirm = false;
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );

    handleConfirmInGame() {
      roomMatch.room_match_detail!
          .where((detail) => detail.id!.contains(""))
          .toList();
    }

    Widget textRoomId() {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: Center(
          child: Text(
            "#${roomMatch.room_code}",
            style: thirdTextStyle.copyWith(fontSize: 12, fontWeight: regular),
          ),
        ),
      );
    }

    Widget header() {
      return Container(
          margin: EdgeInsets.only(top: 15, left: 15, right: 15),
          padding: EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: backgroundColor2,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: backgroundColor2.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3))
              ]),
          child: Row(
            children: [
              SizedBox(
                height: 90,
                width: 90,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          value: 0.75,
                          backgroundColor: backgroundColor5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(backgroundColor1),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "3/4",
                        style: whiteTextStyle.copyWith(
                            fontSize: 16, fontWeight: semiBold),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${roomMatch.room_code}',
                    style: whiteTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                  ),
                  Text(
                    '${widget.language.language_name}',
                    style: whiteTextStyle.copyWith(
                        fontSize: 14, fontWeight: medium),
                  ),
                ],
              )
            ],
          ));
    }

    Widget body(List<RoomMatchDetailModel>? listRoomMatchDetail) {
      return Container(
        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // textRoomId(),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                PlayerProfile(listRoomMatchDetail![0], isReadyPlayer[0]),
                PlayerProfile(listRoomMatchDetail[0], isReadyPlayer[0]),
                PlayerProfile(listRoomMatchDetail[0], isReadyPlayer[0]),
                PlayerProfileSkeleton()
                // PlayerProfile(listRoomMatchDetail[1], isReadyPlayer[1])
              ],
            ),
          )
        ]),
      );
    }

    Widget ConfirmReadyMatch() {
      return Container(
        height: 45,
        width: (MediaQuery.of(context).size.width - 82) / 2,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor1,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [backgroundColor1, backgroundColor2]),
            borderRadius: BorderRadius.circular(15)),
        child: TextButton(
            onPressed: afterConfirm
                ? null
                : () {
                    // handleConfirmInGame(roomMatch.id);
                  },
            style: TextButton.styleFrom(
                backgroundColor:
                    afterConfirm ? secondaryDisabled : secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text(
              'Ready',
              style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            )),
      );
    }

    Widget cancelButton() {
      return Container(
        height: 45,
        width: (MediaQuery.of(context).size.width - 82) / 2,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: backgroundColor1,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [backgroundColor1, backgroundColor2]),
            borderRadius: BorderRadius.circular(15)),
        child: TextButton(
            onPressed: afterConfirm
                ? null
                : () {
                    // handleConfirmInGame(roomMatch.id);
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

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(8),
        child: Row(
          children: [ConfirmReadyMatch(), cancelButton()],
        ),
      ),
      body: StreamBuilder(
        stream: socketService.eventStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // logger.d(snapshot.data);
          }

          return Container(
            padding: EdgeInsets.only(top: 28, left: 13, right: 13),
            decoration: BoxDecoration(
              color: backgroundColor1,
              // gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [backgroundColor1, backgroundColor2]),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    header(),
                    body(roomMatch.room_match_detail),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
