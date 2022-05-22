import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/models/level_model.dart';
import 'package:acakkata/pages/in_game/waiting_online_room_page.dart';
import 'package:acakkata/providers/auth_provider.dart';
import 'package:acakkata/providers/room_provider.dart';
import 'package:acakkata/service/socket_service.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/custom_page_route.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PrepareOnlineGamePlay extends StatefulWidget {
  late final LanguageModel? languageModel;
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
      this.languageModel,
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
    disconnectSocket();
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          },
        ),
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

    handleCreateRoom() async {
      setState(() {
        isLoading = true;
      });

      try {
        if (await roomProvider.createRoom(
            language_code: widget.languageModel!.language_code,
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
              "Berhasil membuat Room",
              textAlign: TextAlign.center,
            ),
            backgroundColor: successColor,
          ));

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

    Widget ButtonCreateRoom() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: ClickyButton(
            color: whitePurpleColor,
            shadowColor: whiteAccentPurpleColor,
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            width: 245,
            height: 60,
            child: Wrap(
              children: [
                Text(
                  'Buat Room Match',
                  style:
                      primaryTextStyle.copyWith(fontSize: 14, fontWeight: bold),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  'assets/images/arrow_blue.png',
                  height: 25,
                  width: 25,
                )
              ],
            ),
            onPressed: () {
              final isValid = _form.currentState!.validate();
              if (!isValid) {
                return;
              } else {
                handleCreateRoom();
              }
            }),
      );
    }

    Widget DateTimePlay() {
      final format = DateFormat("yyyy-MM-dd HH:mm");
      return Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: backgroundColor9, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Row(
            children: [
              Expanded(
                  child: DateTimeField(
                style: whiteTextStyle.copyWith(fontSize: 14),
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
                },
                decoration: InputDecoration.collapsed(
                    hintText: 'Waktu Mulai Permainan',
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
          padding: EdgeInsets.all(20),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah Pemain',
                  textAlign: TextAlign.left,
                  style: whiteTextStyle.copyWith(
                      fontSize: 17, fontWeight: semiBold),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: backgroundColor9,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          style: whiteTextStyle.copyWith(fontSize: 14),
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          controller: countPlayer,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Isi jumlah pemain";
                            }

                            if (int.parse(text) <= 1) {
                              return "Minimal 2 pemain";
                            }

                            if (int.parse(text) > 5) {
                              return "Maksimal 5 pemain";
                            }

                            return null;
                          },
                          decoration: InputDecoration.collapsed(
                              hintText: 'Jumlah Pemain',
                              hintStyle: whiteTextStyle.copyWith(fontSize: 12)),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Waktu Mulai Permainan',
                  textAlign: TextAlign.left,
                  style: whiteTextStyle.copyWith(
                      fontSize: 17, fontWeight: semiBold),
                ),
                SizedBox(
                  height: 5,
                ),
                DateTimePlay(),
                ButtonCreateRoom()
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
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background_512w.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: body(),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: backgroundColor2,
        ),
        onWillPop: () async => false);
  }
}
