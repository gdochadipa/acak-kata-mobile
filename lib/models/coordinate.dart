import 'dart:math';

class Coordinate {
  double? x;
  double? y;

  Coordinate({this.x, this.y});

  bool compareIsOutsideRange(
      {required double x1, required double y1, required range}) {
    if (x != null && x != null) {
      if (((x! - range) >= x1 || (x! + range) <= x1) ||
          ((y! - range) >= y1 || (y! + range) <= y1)) {
        return true;
      }
    }
    return false;
  }

  bool compareIsInsideRange(
      {required double x1, required double y1, required range}) {
    if (x != null && x != null) {
      if (((x! - range) <= x1 && (x! + range) >= x1) &&
          ((y! - range) <= y1 && (y! + range) >= y1)) {
        return true;
      }
    }
    return false;
  }
}
