import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class PopoverListView extends StatelessWidget {
  late Widget child;
  PopoverListView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _buildHandle(BuildContext context) {
      final theme = Theme.of(context);
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: primaryTextColor,
                  size: 25,
                ),
              ),
            ),
            Container(
              height: 5,
              decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: const BorderRadius.all(Radius.circular(2.5))),
            )
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHandle(context), child],
      )),
    );
  }
}
