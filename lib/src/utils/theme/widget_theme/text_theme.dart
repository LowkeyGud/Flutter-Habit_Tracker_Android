import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_export.dart';

class HTextTheme {
  HTextTheme._();
  static TextTheme lightTextTheme = TextTheme(
    displaySmall: GoogleFonts.montserrat(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 0, 0, 0),
    ),
    titleSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(136, 0, 0, 0),
      fontSize: 20,
    ),
    bodySmall: GoogleFonts.poppins(
      color: const Color.fromARGB(255, 0, 0, 0),
      fontSize: 15,
    ),
    labelSmall: GoogleFonts.poppins(
      color: const Color.fromARGB(136, 0, 0, 0),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    displaySmall: GoogleFonts.montserrat(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
    titleSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: 20,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 15,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
  );

  static TextStyle normalTextStyle = TextStyle(
    color: ColorConstant.blueGray300,
    fontSize: getFontSize(
      16,
    ),
    fontFamily: 'Plus Jakarta Sans',
    fontWeight: FontWeight.w500,
  );
}
