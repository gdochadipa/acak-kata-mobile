import 'package:acakkata/controller/audio/sound.dart';
import 'package:acakkata/controller/audio_controller.dart';
import 'package:acakkata/controller/setting_controller.dart';
import 'package:acakkata/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonBounce extends StatefulWidget {
  final Widget child;
  final double heightShadow;
  final double borderThick;
  final double heightButton;
  final double widthButton;
  final double paddingVerticalButton;
  final double paddingHorizontalButton;
  final GestureTapCallback onClick;
  final Color color;
  final Color borderColor;
  final Color shadowColor;
  final double borderRadius;

  const ButtonBounce(
      {Key? key,
      this.heightShadow = 6.0,
      this.borderThick = 2.5,
      this.heightButton = 50,
      this.widthButton = 50,
      this.paddingVerticalButton = 5,
      this.paddingHorizontalButton = 5,
      this.borderRadius = 15,
      required this.onClick,
      required this.child,
      this.color = const Color(0xff8B62FF),
      this.borderColor = const Color(0xff5833BF),
      this.shadowColor = const Color(0xff4F349E)})
      : super(key: key);

  @override
  State<ButtonBounce> createState() => _ButtonBounceState();
}

class _ButtonBounceState extends State<ButtonBounce> {
  double _padding = 6;
  double _reversePadding = 0;

  int lastTimeClicked = 0;

  @override
  void initState() {
    // TODO: implement initState
    _padding = widget.heightShadow;
    _reversePadding = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioController>();

    double intervalMs = 1500;

    return Container(
      child: SizedBox(
        height: widget.heightButton,
        width: widget.widthButton,
        child: GestureDetector(
          onTap: () {
            int now = DateTime.now().millisecondsSinceEpoch;
            if (now - lastTimeClicked < intervalMs) {
              return;
            }
            lastTimeClicked = now;
            widget.onClick();
          },
          excludeFromSemantics: true,
          onTapDown: (_) => setState(() {
            _padding = 0.0;
            _reversePadding = widget.heightShadow;
          }),
          onTapUp: (_) => setState(() {
            _padding = widget.heightShadow;
            _reversePadding = 0.0;
            audio.playSfx(SfxType.buttonTap, queue: 0);
          }),
          child: AnimatedContainer(
            padding: EdgeInsets.only(bottom: _padding),
            margin: EdgeInsets.only(top: _reversePadding),
            decoration: BoxDecoration(
                color: widget.shadowColor,
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: widget.paddingVerticalButton,
                  horizontal: widget.paddingHorizontalButton),
              decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                      width: widget.borderThick, color: widget.borderColor)),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
