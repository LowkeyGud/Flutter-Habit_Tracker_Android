import 'package:flutter/material.dart';
import 'package:habittracker/src/constants/color_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';

class HElevatedButtontheme {
  HElevatedButtontheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    shape: const RoundedRectangleBorder(),
    foregroundColor: hWhiteColor,
    backgroundColor: hDarkColor,
    side: const BorderSide(color: hDarkColor),
    padding: const EdgeInsets.symmetric(vertical: hButtonHeight),
  ));

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      foregroundColor: hDarkColor,
      backgroundColor: hWhiteColor,
      side: const BorderSide(color: hDarkColor),
      padding: const EdgeInsets.symmetric(vertical: hButtonHeight),
    ),
  );
}

class ElevatedButtonStyles {
  // Define the styles as constants or static variables
  static final ButtonStyle redButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.red, // Set the text color
    elevation: 2, // Set the elevation
    textStyle: const TextStyle(fontSize: 16), // Set the text style
    padding: const EdgeInsets.all(12), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Set the border radius
    ),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.grey,
    elevation: 0,
    textStyle: const TextStyle(fontSize: 16),
    padding: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.grey), // Add a border
    ),
  );

  static final ButtonStyle tertiaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.blue,
    elevation: 0,
    textStyle: const TextStyle(fontSize: 16),
    padding: const EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
