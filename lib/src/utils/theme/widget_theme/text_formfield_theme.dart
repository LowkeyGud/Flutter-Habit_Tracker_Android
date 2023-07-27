import 'package:flutter/material.dart';
import 'package:habittracker/src/constants/color_before_login.dart';

class HTextFormFieldTheme {
  HTextFormFieldTheme._();
  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: hDarkColor,
    floatingLabelStyle: TextStyle(color: hDarkColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: hDarkColor),
    ),
  );
  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: hPrimaryColor,
    floatingLabelStyle: TextStyle(color: hPrimaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: hPrimaryColor),
    ),
  );
}
