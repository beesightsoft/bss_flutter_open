
import 'dart:math';
import 'dart:ui';

class Utils{
  static double distance(Offset o1, Offset o2) {
    return sqrt(pow(o1.dx - o2.dx, 2) + pow(o1.dy - o2.dy, 2));
  }

  static double padding = 48.0;
  static double sizeTable = 48.0;
  static double sizeChair = 32.0;

}