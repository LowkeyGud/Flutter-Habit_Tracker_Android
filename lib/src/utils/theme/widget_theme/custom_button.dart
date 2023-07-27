// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget});

  final ButtonShape? shape;

  final ButtonPadding? padding;

  final ButtonVariant? variant;

  final ButtonFontStyle? fontStyle;

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  final double? width;

  final double? height;

  final String? text;

  final Widget? prefixWidget;

  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? const SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? const SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingAll14:
        return getPadding(
          all: 14,
        );
      case ButtonPadding.PaddingT17:
        return getPadding(
          top: 17,
          right: 17,
          bottom: 17,
        );
      case ButtonPadding.PaddingT9:
        return getPadding(
          left: 8,
          top: 9,
          right: 8,
          bottom: 9,
        );
      case ButtonPadding.PaddingAll6:
        return getPadding(
          all: 6,
        );
      default:
        return getPadding(
          all: 17,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.FillRed50:
        return ColorConstant.red50;
      case ButtonVariant.OutlineRedA700:
        return ColorConstant.whiteA70001;
      case ButtonVariant.FillBluegray50:
        return ColorConstant.blueGray50;
      case ButtonVariant.OutlineGray900:
        return null;
      default:
        return ColorConstant.redA700;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineGray900:
        return BorderSide(
          color: ColorConstant.gray900,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineRedA700:
        return BorderSide(
          color: ColorConstant.redA700,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.FillRedA700:
      case ButtonVariant.FillRed50:
      case ButtonVariant.FillBluegray50:
        return null;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder20:
        return BorderRadius.circular(
          getHorizontalSize(
            20.00,
          ),
        );
      case ButtonShape.RoundedBorder8:
        return BorderRadius.circular(
          getHorizontalSize(
            8.00,
          ),
        );
      case ButtonShape.RoundedBorder12:
        return BorderRadius.circular(
          getHorizontalSize(
            12.00,
          ),
        );
      case ButtonShape.RoundedBorder4:
        return BorderRadius.circular(
          getHorizontalSize(
            4.00,
          ),
        );
      case ButtonShape.CircleBorder30:
        return BorderRadius.circular(
          getHorizontalSize(
            30.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            24.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.PJSSemiBold14:
        return TextStyle(
          color: ColorConstant.whiteA70001,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.PJSSemiBold16WhiteA70001:
        return TextStyle(
          color: ColorConstant.whiteA70001,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.PJSSemiBold16Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.PJSm16:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.PJSm12:
        return TextStyle(
          color: ColorConstant.whiteA70001,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.InterRegular12:
        return TextStyle(
          color: ColorConstant.deepOrange400,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.PJSm16RedA700:
        return TextStyle(
          color: ColorConstant.redA700,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.PJSSemiBold16Bluegray300:
        return TextStyle(
          color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      default:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder24,
  RoundedBorder20,
  RoundedBorder8,
  RoundedBorder12,
  RoundedBorder4,
  CircleBorder30,
}

enum ButtonPadding {
  PaddingAll17,
  PaddingAll14,
  PaddingT17,
  PaddingT9,
  PaddingAll6,
}

enum ButtonVariant {
  FillRedA700,
  OutlineGray900,
  FillRed50,
  OutlineRedA700,
  FillBluegray50,
}

enum ButtonFontStyle {
  PJSSemiBold16,
  PJSSemiBold14,
  PJSSemiBold16WhiteA70001,
  PJSSemiBold16Gray900,
  PJSm16,
  PJSm12,
  InterRegular12,
  PJSm16RedA700,
  PJSSemiBold16Bluegray300,
}
