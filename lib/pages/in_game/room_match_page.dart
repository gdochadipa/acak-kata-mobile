import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/room_match_model.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomMatchPage extends StatefulWidget {
  // const RoomMatchPage({ Key? key }) : super(key: key);

  late final LanguageModel language;

  RoomMatchPage(LanguageModel language);

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

    handleConfirmInGame() {}

    Widget textRoomId() {
      return Container(
        margin: EdgeInsets.only(top: 70),
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
          margin: EdgeInsets.only(top: 30, left: 15, right: 15),
          padding: EdgeInsets.only(left: 15, right: 8, top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: backgroundColor6, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 15,
                          value: 0.5,
                        ),
                      ),
                    ),
                    Center(
                      child: Text("Testting"),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Room Match',
                    style:
                        headerText3.copyWith(fontSize: 16, fontWeight: medium),
                  ),
                  Text(
                    '${widget.language.language_name}',
                    style: thirdTextStyle.copyWith(
                        fontSize: 11, fontWeight: medium, color: grayColor3),
                  ),
                ],
              )
            ],
          ));
    }

    return Scaffold(
      backgroundColor: backgroundColor1,
      body: StreamBuilder(
        stream: socketService.eventStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container();
        },
      ),
    );
  }
}
