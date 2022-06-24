import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/button_bounce.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';

class ShowProfileModal extends StatefulWidget {
  final UserModel? userModel;
  const ShowProfileModal({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowProfileModal> createState() => _ShowProfileModalState();
}

class _ShowProfileModalState extends State<ShowProfileModal> {
  init() async {}

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Dialog(
        insetAnimationCurve: Curves.easeInOut,
        backgroundColor: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 500,
          alignment: Alignment.center,
          child: PopoverListView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: grayColor2, shape: BoxShape.circle),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Player ID",
                            style: whiteTextStyle.copyWith(
                                fontSize: 13, fontWeight: semiBold)),
                        Text("#${widget.userModel!.userCode}",
                            style: whiteTextStyle.copyWith(
                                fontSize: 20, fontWeight: bold))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username",
                            style: whiteTextStyle.copyWith(
                                fontSize: 13, fontWeight: semiBold)),
                        Text("${widget.userModel!.username}",
                            style: whiteTextStyle.copyWith(
                                fontSize: 20, fontWeight: bold))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Player E-mail",
                            style: whiteTextStyle.copyWith(
                                fontSize: 13, fontWeight: semiBold)),
                        Text("${widget.userModel!.email}",
                            style: whiteTextStyle.copyWith(
                                fontSize: 20, fontWeight: bold))
                      ],
                    ),
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
                          child: Text(
                            'Edit Profile',
                            style: whiteTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold),
                          ),
                        ),
                        onClick: () {}),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
