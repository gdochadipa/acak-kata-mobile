import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChangeMessageDialog extends StatefulWidget {
  final GestureTapCallback onClickSuccess, onClickCancel;
  final String message;
  const ChangeMessageDialog(
      {required this.onClickSuccess,
      Key? key,
      required this.message,
      required this.onClickCancel})
      : super(key: key);

  @override
  State<ChangeMessageDialog> createState() => _ChangeMessageDialogState();
}

class _ChangeMessageDialogState extends State<ChangeMessageDialog> {
  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width - (2 * defaultMargin),
      child: AlertDialog(
        backgroundColor: transparentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: primaryColor5,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(width: 5, color: primaryColor2)),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.message,
                      style: whiteTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      children: [
                        //* button if Say yes
                        Container(
                          margin: const EdgeInsets.all(2),
                          height: 44,
                          child: TextButton(
                            onPressed: () async {
                              widget.onClickSuccess();
                              // Navigator.pushNamedAndRemoveUntil(
                              //     context, '/home', (route) => false);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              setLanguage.exit_game_yes,
                              overflow: TextOverflow.ellipsis,
                              style: whiteTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          height: 44,
                          child: TextButton(
                            onPressed: () {
                              widget.onClickCancel();
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              side:
                                  BorderSide(width: 1, color: backgroundColor2),
                              backgroundColor: backgroundColor1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              setLanguage.exit_game_no,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: primaryTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: medium,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                alignment: Alignment.topRight,
                child: CircleBounceButton(
                  color: redColor,
                  borderColor: redColor2,
                  shadowColor: redColor3,
                  onClick: () {
                    Navigator.pop(context);
                  },
                  paddingHorizontalButton: 1,
                  paddingVerticalButton: 1,
                  heightButton: 45,
                  widthButton: 45,
                  child: Icon(Icons.close, color: whiteColor, size: 25),
                )),
          ],
        )),
      ),
    );
    ;
  }
}
