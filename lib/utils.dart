import 'dart:ui';

class Utils {
  static Color hexToColor(String hexCode) {
    return Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
  }
}