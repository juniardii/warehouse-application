import 'package:flutter/material.dart';

class MyColor {
  static const Color bgColor = Color(0xFF004972);
  static const LinearGradient myGradient = LinearGradient(
    colors: [
      Color(0xFF004972),
      Color(0xff000039),
    ],
  );
  static LinearGradient myGradientbtn = LinearGradient(
    colors: [
      const Color(0xFF004972).withOpacity(0.7),
      const Color(0xff000039).withOpacity(0.5),
    ],
  );
}
