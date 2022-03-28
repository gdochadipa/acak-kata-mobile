import 'package:flutter/material.dart';

class Popover extends StatelessWidget {
  late Widget child;
  Popover({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _buildHandle(BuildContext context) {
      final theme = Theme.of(context);
      return FractionallySizedBox(
        widthFactor: 0.25,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 18.0),
          child: Container(
            height: 5,
            decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(2.5))),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHandle(context), child],
      ),
    );
  }
}
