import 'package:acakkata/theme.dart';
import 'package:acakkata/widgets/button/circle_bounce_button.dart';
import 'package:flutter/material.dart';

class PopoverListView extends StatelessWidget {
  late Widget child;
  PopoverListView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  border: Border.all(width: 5, color: primaryColor2)),
              child: child,
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
        ),
      ),
    );
  }
}
