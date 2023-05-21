import 'package:acakkata/theme.dart';
import 'package:flutter/material.dart';

class ListItemPopOver extends StatelessWidget {
  late Widget title;
  late Widget leading;
  late VoidCallback onClick;
  ListItemPopOver(
      {Key? key,
      required this.title,
      required this.leading,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            leading,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: DefaultTextStyle(
                child: title,
                style:
                    blackTextStyle.copyWith(fontWeight: regular, fontSize: 16),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
