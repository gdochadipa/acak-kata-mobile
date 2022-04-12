import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

abstract class CircleAnimationEvents {
  static const run = 'runAnimation';
  static const reset = 'resetAnimation';
}

class SplashCircleAnimation extends GSprite {
  late GShape splashCircle;

  @override
  void addedToStage() {
    // TODO: implement addedToStage
    visible = false;
    // stage!.onResized.add(callback)
    mps.on(CircleAnimationEvents.reset, _showSplashScreen);
    super.addedToStage();
  }

  void _showSplashScreen() {
    mps.emit1(CircleAnimationEvents.run, true);
    splashCircle.graphics.clear();
    splashCircle.graphics.beginFill(Colors.redAccent);
    splashCircle.graphics.drawCircle(0, 0, stage!.stageWidth);
    splashCircle.graphics.endFill();
    splashCircle.scale = 0;
    stage!.color = kColorTransparent;
    stage!.addChild(splashCircle);
    splashCircle.setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);

    splashCircle.tween(
        duration: 1,
        ease: GEase.easeInOutExpo,
        scale: 1,
        overwrite: 0,
        onComplete: () {
          splashCircle.graphics.clear();
          _runDemo();
        });
  }

  void _runDemo() {
    mps.emit1(CircleAnimationEvents.run, true);

    visible = true;
    stage!.color = Colors.redAccent.value as Color?;

    var t1 = 0.0.twn;
    var t2 = 0.0.twn;
    var t3 = 0.0.twn;
    var t4 = 0.1.twn;

    /// increment the delay to simulate a global timeline.
    var dly = 0.0;
  }
}
