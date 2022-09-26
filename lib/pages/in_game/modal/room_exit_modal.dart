import 'package:acakkata/providers/socket_provider.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RoomExitModal extends StatefulWidget {
  const RoomExitModal({Key? key}) : super(key: key);

  @override
  State<RoomExitModal> createState() => _RoomExitModalState();
}

class _RoomExitModalState extends State<RoomExitModal> {
  @override
  Widget build(BuildContext context) {
    SocketProvider socketProvider =
        Provider.of<SocketProvider>(context, listen: false);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Dialog(
        insetAnimationCurve: Curves.easeInOut,
        backgroundColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
            height: 300,
            child: PopoverListView(
                child: Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Host keluar permainan, permainan tidak dapat dilanjutkan karena host meninggalkan ruang permainan",
                    style: whiteTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: ButtonBounce(
                        color: primaryColor,
                        borderColor: primaryColor2,
                        shadowColor: primaryColor3,
                        widthButton: 210,
                        heightButton: 50,
                        child: Center(
                          child: Wrap(
                            children: [
                              Text(
                                'Oke',
                                style: whiteTextStyle.copyWith(
                                    fontSize: 14, fontWeight: bold),
                              ),
                            ],
                          ),
                        ),
                        onClick: () async {
                          if (socketProvider.isConnected) {
                            await socketProvider.disconnect();
                          }
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        }),
                  )
                ],
              ),
            ))),
      ),
    );
  }
}
