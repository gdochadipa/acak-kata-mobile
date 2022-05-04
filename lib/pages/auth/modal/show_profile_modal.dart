import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/clicky_button.dart';
import 'package:acakkata/widgets/popover/popover_listview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 100,
                  width: 100,
                  decoration:
                      BoxDecoration(color: grayColor2, shape: BoxShape.circle),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Player ID",
                          style: blackTextStyle.copyWith(
                              fontSize: 13, fontWeight: semiBold)),
                      Text("#${widget.userModel!.userCode}",
                          style: blackTextStyle.copyWith(
                              fontSize: 20, fontWeight: bold))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Username",
                          style: blackTextStyle.copyWith(
                              fontSize: 13, fontWeight: semiBold)),
                      Text("${widget.userModel!.username}",
                          style: blackTextStyle.copyWith(
                              fontSize: 20, fontWeight: bold))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Player E-mail",
                          style: blackTextStyle.copyWith(
                              fontSize: 13, fontWeight: semiBold)),
                      Text("${widget.userModel!.email}",
                          style: blackTextStyle.copyWith(
                              fontSize: 20, fontWeight: bold))
                    ],
                  ),
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
                            'Edit Profile',
                            style: whiteTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold),
                          ),
                        ],
                      ),
                      onPressed: () {}),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
