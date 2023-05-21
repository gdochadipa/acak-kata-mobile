import 'package:acakkata/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TutorialItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  const TutorialItem(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 99,
        ),
        Image.asset(
          imageUrl,
          width: double.infinity,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            subtitle,
            style: blackTextStyle.copyWith(fontSize: 14, fontWeight: medium),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
