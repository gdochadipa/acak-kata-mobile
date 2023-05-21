import 'package:acakkata/models/language_model.dart';
import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final LanguageModel language;
  final Color backgroundColor;
  final TextStyle textStyle;
  final Color iconColor;
  const HeaderBar(
      this.language, this.backgroundColor, this.textStyle, this.iconColor);
  // const HeaderBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: iconColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '${language.language_name}',
        style: textStyle,
      ),
      actions: const [],
    );
  }
}
