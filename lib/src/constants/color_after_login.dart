import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray5001 = fromHex('#fcfcfc');

  static Color gray5002 = fromHex('#f9f9f9');
  static Color bgGray = gray5002;

  static Color blueGray50 = fromHex('#ecf1f6');

  static Color red600 = fromHex('#e53935');

  static Color black9003f = fromHex('#3f000000');

  static Color gray50 = fromHex('#f6f8fe');

  static Color red50 = fromHex('#fff2ed');

  static Color greenA700 = fromHex('#00c566');

  static Color black900 = fromHex('#000000');

  static Color indigo5001 = fromHex('#e3e7eb');

  static Color blueGray800 = fromHex('#434e58');

  static Color gray90061 = fromHex('#61111111');

  static Color deepOrange400 = fromHex('#ff784b');

  static Color redA700 = fromHex('#ee0000');

  static Color gray600 = fromHex('#6c6c6c');

  static Color blueGray5001 = fromHex('#edf2f7');

  static Color gray60087 = fromHex('#876c6c6c');

  static Color gray400 = fromHex('#bfbfbf');

  static Color gray60001 = fromHex('#66707a');

  static Color blueGray400 = fromHex('#78828a');

  static Color blueGray300 = fromHex('#9ca4ab');

  static Color gray90087 = fromHex('#87111111');

  static Color indigo50 = fromHex('#e3e9ed');

  static Color amber600 = fromHex('#ffb300');

  static Color redA200 = fromHex('#ff4747');

  static Color gray900 = fromHex('#111111');

  static Color createButtonBorder = fromHex('#E9EBED');

  static Color gray90001 = fromHex('#171725');

  static Color gray9006101 = fromHex('#61171725');

  static Color gray200 = fromHex('#e8eaec');

  static Color gray100 = fromHex('#f7f7f7');

  static Color whiteA70000 = fromHex('#00ffffff');

  static Color whiteA70001 = fromHex('#fefefe');

  static Color gray10001 = fromHex('#f5f5f5');

  static Color gray9003d = fromHex('#3d1f1d2b');

  static Color black90019 = fromHex('#19000000');

  static Color blueGray40001 = fromHex('#888888');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
