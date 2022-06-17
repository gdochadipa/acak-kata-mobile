
import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/room_match_detail_model.dart';
import 'package:acakkata/pages/in_game/waiting_join_room_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:acakkata/widgets/loading/LoadingOverlay.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
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
  SocketProvider? socketProvider;
  bool _validation = false;
  String? _textValidation = '';
  // SocketService socketService = SocketService();
  late FocusNode roomCode = FocusNode();
  bool isLoading = false;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  @override
  void initState() {
    // TODO: implement initState
    roomProvider = Provider.of<RoomProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    super.initState();
    connectSocket();
  }

  connectSocket() async {
    // await socketService.fireSocket();
  }

  disconnectSocket() async {
    // await socketService.disconnect();
    socketProvider!.disconnectService();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    roomCode.dispose();
    // disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);
    S? setLanguage = S.of(context);

    /// !ketika join room berhasil status player itu sama dengan 1
    handleSearchRoom() async {
      try {
        setState(() {
          _validation = false;
        });
        if (await roomProvider!
            .checkingRoomWithCode("1", roomCodeController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              "Berhasil menemukan Room",
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));
          // socketService.emitJoinRoom(
          //     '${roomProvider!.roomMatch!.channel_code}', 'client');

          RoomMatchDetailModel roomSend = roomProvider!.listRoommatchDet!
              .where((detail) => detail.player_id! == authProvider!.user!.id)
              .first;
          roomSend.is_ready = 1;
          await socketProvider!.socketSendJoinRoom(
              channelCode: '${roomProvider!.roomMatch!.channel_code}',
              playerCode: '${authProvider!.user!.userCode}',
              languageCode:
                  '${roomProvider!.roomMatch!.language!.language_code}',
              roomMatchDet: roomSend);

          Navigator.push(
              context,
              CustomPageRoute(WaitingJoinRoomPage(
                languageModel: roomProvider!.roomMatch!.language!,
                isOnline: true,
              )));

          // socketService.emitSearchRoom(
          //     '${roomProvider!.roomMatch!.channel_code}',
          //     '${roomProvider!.roomMatch!.language!.language_code}',
          //     roomSend);
        }
      } catch (e, trace) {
        logger.e(e);
        logger.e(trace);
        String error = e.toString().replaceAll('Exception:', '');
        setState(() {
          _validation = true;
          _textValidation = error;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Dialog(
        insetAnimationCurve: Curves.easeInOut,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: PopoverListView(
            child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Masukan Kode Ruangan",
                style:
                    blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: blackColor),
                    color: backgroundColor1,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      style: primaryTextStyle.copyWith(fontSize: 20),
                      controller: roomCodeController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'AXXXXX',
                        hintStyle: subtitleTextStyle,
                      ),
                    )),
                  ],
                )),
              ),
              const SizedBox(
                height: 5,
              ),
              if (_validation)
                Text(
                  _textValidation ?? 'Gagal membuat room',
                  textAlign: TextAlign.left,
                  style: alertTextStyle.copyWith(fontSize: 11),
                ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
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
                    onPressed: () {
                      handleSearchRoom();
                    }),
              )
            ],
          ),
        )),
      ),
    );
  }
}
