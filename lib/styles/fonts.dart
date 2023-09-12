import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Kanit {
  static TextStyle getAppFont({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
  }) {
    return GoogleFonts.kanit(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ));
  }
}

class Lora {
  static TextStyle getAppFont({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
  }) {
    return GoogleFonts.lora(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ));
  }
}

class TextFonts {
  static final primaryText = Kanit.getAppFont(
      fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white);
  static final secondaryText =
      Kanit.getAppFont(fontSize: 25, color: Colors.black);
  static final normalwhiteText =
      Kanit.getAppFont(fontSize: 20, color: Colors.white);
  static final ternaryText =
      Kanit.getAppFont(fontSize: 20, color: Colors.black);
  static final labelText = Kanit.getAppFont(fontSize: 15, color: Colors.black);
}

class PdfFonts {
  static final primaryFont = Lora.getAppFont(
      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  static final secondaryFont =
      Lora.getAppFont(fontSize: 10, color: Colors.black);
  static final secTittle = Lora.getAppFont(fontSize: 10, color: Colors.white);
  static final ternaryFont = Lora.getAppFont(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
}
