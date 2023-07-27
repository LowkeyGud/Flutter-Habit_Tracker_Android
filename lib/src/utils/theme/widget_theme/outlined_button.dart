import 'package:flutter/material.dart';
import 'package:habittracker/src/constants/color_after_login.dart';
import 'package:habittracker/src/constants/color_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';

class HOutlinedButtontheme {
  HOutlinedButtontheme._();
  static final lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: BorderSide(color: ColorConstant.redA700),
      backgroundColor: ColorConstant.redA700,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(40),
        ),
      ),
    ),
  );

  static final darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      foregroundColor: hWhiteColor,
      side: const BorderSide(
        color: hWhiteColor,
        width: 2,
      ),
      padding: const EdgeInsets.symmetric(vertical: hButtonHeight),
    ),
  );

  static final ButtonStyle cancelTheme = OutlinedButton.styleFrom(
    foregroundColor: ColorConstant.redA700,
    backgroundColor: Colors.transparent,
    side: const BorderSide(color: Colors.transparent),
  );

  static final ButtonStyle loginButton = OutlinedButton.styleFrom(
    shape: const RoundedRectangleBorder(),
    foregroundColor: hDarkColor,
    backgroundColor: hWhiteColor,
    side: const BorderSide(
      color: hDarkColor,
      width: 2,
    ),
    padding: const EdgeInsets.symmetric(vertical: hButtonHeight),
  );
}
