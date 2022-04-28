import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinRoomModal extends StatefulWidget {
  const JoinRoomModal({Key? key}) : super(key: key);

  @override
  State<JoinRoomModal> createState() => _JoinRoomModalState();
}

class _JoinRoomModalState extends State<JoinRoomModal> {
  TextEditingController roomCodeController = TextEditingController(text: '');
  RoomProvider? roomProvider;
  AuthProvider? authProvider;

  SocketService socketService = SocketService();
  late FocusNode roomCode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    super.initState();
    connectSocket();
  }

  connectSocket() async {
    await socketService.fireSocket();
  }

  disconnectSocket() async {
    await socketService.disconnect();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    roomCode.dispose();
    disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// !masalahnya disini untuk language code nya, kyknya perbaiki untuk
    /// !pencarian room pada api dan socket engga butuh language code
    handleSearchRoom() async {
      try {
        if (await roomProvider!
            .checkingRoomWithCode("1", roomCodeController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Berhasil menemukan Room",
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));
          socketService.emitJoinRoom(roomCodeController.text, 'client');
          RoomMatchDetailModel roomSend = roomProvider!.listRoommatchDet!
              .where((detail) =>
                  detail.player_id!.contains('${authProvider!.user!.id}'))
              .first;
          socketService.emitSearchRoom(roomCodeController.text, 'en', roomSend);
        }
      } catch (e) {
        print(e);
        String error = e.toString().replaceAll('Exception:', '');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }
    }

    S? setLanguage = S.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Dialog(
        insetAnimationCurve: Curves.easeInOut,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: PopoverListView(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Masukan Kode Ruangan",
                style:
                    blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: blackColor),
                    color: backgroundColor1,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: primaryTextStyle.copyWith(fontSize: 20),
                      controller: roomCodeController,
                      decoration: InputDecoration.collapsed(
                          hintText: 'AXXXXX', hintStyle: subtitleTextStyle),
                    ))
                  ],
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                child: ClickyButton(
                    color: purpleColor,
                    shadowColor: purpleAccentColor,
                    width: 210,
                    height: 60,
                    child: Wrap(
                      children: [
                        Text(
                          'Cari Room',
                          style: whiteTextStyle.copyWith(
                              fontSize: 14, fontWeight: bold),
                        ),
                      ],
                    ),
                    onPressed: () {}),
              )
            ],
          ),
        )),
      ),
    );
  }
}
