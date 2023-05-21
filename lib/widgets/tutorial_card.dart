import 'package:acakkata/generated/l10n.dart';
import 'package:acakkata/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TutorialCard extends StatefulWidget {
  final VoidCallback onClick;
  final String titleId;
  final String titleEn;
  final Color color;
  final Color borderColor;
  final Color shadowColor;

  const TutorialCard({
    Key? key,
    required this.onClick,
    required this.titleId,
    required this.titleEn,
    this.color = const Color(0xff8B62FF),
    this.borderColor = const Color(0xff5833BF),
    this.shadowColor = const Color(0xff4F349E),
  }) : super(key: key);

  @override
  State<TutorialCard> createState() => _TutorialCardState();
}

class _TutorialCardState extends State<TutorialCard> {
  double _padding = 10;
  double _reversePadding = 0;
  double _heightShadow = 10;

  @override
  void initState() {
    // TODO: implement initState
    _padding = _heightShadow;
    _reversePadding = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    S? setLanguage = S.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: widget.onClick,
        onTapDown: (_) => setState(() {
          _padding = 0.0;
          _reversePadding = _heightShadow;
        }),
        onTapUp: (_) => setState(() {
          _padding = _heightShadow;
          _reversePadding = 0.0;
        }),
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: _padding),
          margin: EdgeInsets.only(top: _reversePadding),
          decoration: BoxDecoration(
              color: widget.shadowColor,
              borderRadius: BorderRadius.circular(15)),
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.only(top: 13, bottom: 13, left: 10),
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 5, color: widget.borderColor)),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: AutoSizeText(
                        (setLanguage.code == 'en'
                            ? '${widget.titleEn}'
                            : '${widget.titleId}'),
                        style: whiteTextStyle.copyWith(
                            fontWeight: bold, fontSize: 16),
                        presetFontSizes: const [18, 16],
                        maxLines: 2,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
