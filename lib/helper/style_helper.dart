import 'package:flutter/material.dart';
import 'package:acakkata/theme.dart';

class StyleHelper {
  static Color getColorRandom(String typeColor, int numColor) {
    if (typeColor == 'color') {
      switch (numColor) {
        case 0:
          return primaryColor;

        case 1:
          return greenColor;

        case 2:
          return orangeColor;

        case 3:
          return redColor;

        case 4:
          return blueColor;

        default:
          return primaryColor;
      }
    }

    if (typeColor == 'borderColor') {
      switch (numColor) {
        case 0:
          return primaryColor2;

        case 1:
          return greenColor2;

        case 2:
          return orangeColor2;

        case 3:
          return redColor2;

        case 4:
          return blueColor2;

        default:
          return primaryColor2;
      }
    }

    if (typeColor == 'shadowColor') {
      switch (numColor) {
        case 0:
          return primaryColor3;

        case 1:
          return greenColor3;

        case 2:
          return orangeColor3;

        case 3:
          return redColor3;

        case 4:
          return blueColor3;

        default:
          return primaryColor3;
      }
    }

    return primaryColor;
  }
}
