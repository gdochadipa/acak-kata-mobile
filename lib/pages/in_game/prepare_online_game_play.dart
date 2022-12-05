import 'dart:developer';

import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/waiting_online_room_page.dart';
import 'package:acakkata/pages/level/level_list_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrepareOnlineGamePlay extends StatefulWidget {
  final LanguageModel languageModel;
  late final int? selectedQuestion;
  late final int? selectedTime;
  late final int? levelWords;
  late final int? isHost;
  late final bool? isOnline;
  late final String? Stage;
  late final LevelModel? levelModel;
  late final bool? isCustom;
  PrepareOnlineGamePlay(
      {Key? key,
      required this.languageModel,
      this.selectedQuestion,
      this.selectedTime,
      this.isHost,
      this.levelWords,
      this.isOnline,
      this.Stage,
      this.levelModel,
      this.isCustom})
      : super(key: key);

  @override
  State<PrepareOnlineGamePlay> createState() => _PrepareOnlineGamePlayState();
}

class _PrepareOnlineGamePlayState extends State<PrepareOnlineGamePlay> {
  TextEditingController room_code = TextEditingController(text: '');
  TextEditingController gameTime = TextEditingController(text: '');
  SocketService socketService = SocketService();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  bool? isLoading = false;

  late RoomProvider roomProvider =
      Provider.of<RoomProvider>(context, listen: false);
  late AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);

  @override
  void initState() {
    // TODO: implement initState
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
    // disconnectSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    TextEditingController countPlayer = TextEditingController(text: '');
    TextEditingController dateTime = TextEditingController(text: '');
    Logger logger = Logger(
      printer: PrettyPrinter(methodCount: 0),
    );
    DateTime? valueDateTime;
    final _form = GlobalKey<FormState>();

    AppBar header() {
      return AppBar(
        leading: GestureDetector(
          child: SizedBox(
            child: Image.asset(
              'assets/images/arrow.png',
              width: 5,
              height: 5,
            ),
          ),
          onTap: () {
            // Navigator.pushNamedAndRemoveUntil(
            //     context, '/home', (route) => false);
            Navigator.pushAndRemoveUntil(
                context,
                CustomPageRoute(
                  LevelListPage(
                    isOnline: false,
                    languageModel: widget.languageModel,
                  ),
                ),
                (route) => false);
          },
        ),
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Image.asset(
                    'assets/images/${widget.languageModel.language_icon}',
                    width: 30,
                    height: 30,
                  ),
                )),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                Center(
                  child: Text(
                    (setLanguage.code == 'en'
                        ? '${widget.languageModel.language_name_en}'
                        : '${widget.languageModel.language_name_id}'),
                    style: whiteTextStyle.copyWith(
                      fontWeight: extraBold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Center(
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

    handleCreateRoom() async {
      setState(() {
        isLoading = true;
      });

      try {
        if (await roomProvider.createRoom(
            language_code: widget.languageModel.language_code,
            max_player: int.parse(countPlayer.text),
            time_watch: widget.selectedTime,
            total_question: widget.selectedQuestion,
            datetime_match: DateFormat('yyyy-MM-dd hh:mm')
                .parseUTC(dateTime.text)
                .toLocal(),
            level: widget.levelModel!.id,
            length_word: widget.levelWords)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              setLanguage.successfuly_create_room,
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));

          prefs.then((pref) {
            pref.setString("last_channel_code",
                roomProvider.roomMatch!.channel_code ?? '');
          });

          Navigator.push(
              context,
              CustomPageRoute(WaitingOnlineRoomPage(
                languageModel: widget.languageModel,
                isOnline: true,
              )));
        }
      } catch (e, stackTrace) {
        logger.e(e);
        logger.e(stackTrace);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            e.toString().replaceAll('Exception:', ''),
            textAlign: TextAlign.center,
          ),
          backgroundColor: alertColor,
        ));
      }
    }

    Widget buttonCreateRoom() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ButtonBounce(
            color: whiteColor,
            borderColor: whiteColor2,
            shadowColor: whiteColor3,
            widthButton: 245,
            heightButton: 50,
            child: Center(
              child: Wrap(
                children: [
                  Text(
                    setLanguage.create_room_match,
                    style: primaryTextStyle.copyWith(
                        fontSize: 14, fontWeight: bold),
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
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              } else {
                handleCreateRoom();
              }
            }),
      );
    }

    Widget dateTimePlay() {
      final format = DateFormat("yyyy-MM-dd HH:mm");
      return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: whiteColor, borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Row(
            children: [
              Expanded(
                  child: DateTimeField(
                style: primaryTextStyle.copyWith(fontSize: 14),
                format: format,
                initialValue: valueDateTime,
                controller: dateTime,
                cursorColor: whiteColor,
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      initialDate: currentValue ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()));
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                validator: (value) {
                  if (dateTime.text == '') {
                    return "Waktu belum diisi";
                  }
                  return null;
                },
                decoration: InputDecoration.collapsed(
                    hintText: setLanguage.ending_time,
                    hintStyle: whiteTextStyle.copyWith(fontSize: 12)),
              )),
            ],
          ),
        ),
      );
    }

    Widget body() {
      return SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setLanguage.max_player,
                  textAlign: TextAlign.left,
                  style: whiteTextStyle.copyWith(
                      fontSize: 17, fontWeight: semiBold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          style: primaryTextStyle.copyWith(fontSize: 14),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: countPlayer,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Isi jumlah pemain";
                            }

                            if (int.parse(text) <= 1) {
                              return "Minimal 2 pemain";
                            }

                            if (int.parse(text) > 11) {
                              return "Maksimal 10 pemain";
                            }

                            return null;
                          },
                          decoration: InputDecoration.collapsed(
                              hintText: setLanguage.max_player,
                              hintStyle:
                                  subtitleTextStyle.copyWith(fontSize: 12)),
                        ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  setLanguage.ending_time,
                  textAlign: TextAlign.left,
                  style: whiteTextStyle.copyWith(
                      fontSize: 17, fontWeight: semiBold),
                ),
                const SizedBox(
                  height: 5,
                ),
                dateTimePlay(),
                const SizedBox(
                  height: 5,
                ),
                buttonCreateRoom()
              ],
            ),
          ),
        ),
      );
    }

    return WillPopScope(
        child: Scaffold(
          appBar: header(),
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: body(),
                ),
              ],
            ),
          ),
          backgroundColor: primaryColor5,
        ),
        onWillPop: () async => false);
  }
}
