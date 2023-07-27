// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.autofocus = false,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator});

  final TextFormFieldShape? shape;

  final TextFormFieldPadding? padding;

  final TextFormFieldVariant? variant;

  final TextFormFieldFontStyle? fontStyle;

  final Alignment? alignment;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final bool? isObscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus!,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.PJSBold14:
        return TextStyle(
          color: ColorConstant.whiteA70001,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        );
      case TextFormFieldFontStyle.PJSRegular12:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        );
      case TextFormFieldFontStyle.PJSSemiBold12:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      case TextFormFieldFontStyle.PJSm16Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.PJSSemiBold16:
        return TextStyle(
          color: ColorConstant.gray90001,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      case TextFormFieldFontStyle.PJSSemiBold14:
        return TextStyle(
          color: ColorConstant.gray600,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        );
      case TextFormFieldFontStyle.PJSBold14Gray900:
        return TextStyle(
          color: ColorConstant.gray900,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        );
      default:
        return TextStyle(
          color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      case TextFormFieldShape.RoundedBorder8:
        return BorderRadius.circular(
          getHorizontalSize(
            8.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            24.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.FillGray90001:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.FillGray10001:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.OutlineRedA700:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.redA700,
            width: 1,
          ),
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      case TextFormFieldVariant.FillGray90001:
        return ColorConstant.gray90001;
      case TextFormFieldVariant.FillGray10001:
        return ColorConstant.gray10001;
      case TextFormFieldVariant.OutlineRedA700:
        return ColorConstant.whiteA70001;
      default:
        return ColorConstant.gray50;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.FillGray90001:
        return true;
      case TextFormFieldVariant.FillGray10001:
        return true;
      case TextFormFieldVariant.OutlineRedA700:
        return true;
      case TextFormFieldVariant.None:
        return false;
      default:
        return true;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingAll15:
        return getPadding(
          all: 15,
        );
      case TextFormFieldPadding.PaddingT15_1:
        return getPadding(
          left: 12,
          top: 15,
          right: 12,
          bottom: 15,
        );
      case TextFormFieldPadding.PaddingT43:
        return getPadding(
          left: 16,
          top: 43,
          right: 16,
          bottom: 43,
        );
      case TextFormFieldPadding.PaddingAll12:
        return getPadding(
          all: 12,
        );
      case TextFormFieldPadding.PaddingT20:
        return getPadding(
          top: 20,
          right: 20,
          bottom: 20,
        );
      case TextFormFieldPadding.PaddingT13:
        return getPadding(
          top: 13,
          right: 13,
          bottom: 13,
        );
      default:
        return getPadding(
          left: 15,
          top: 15,
          bottom: 15,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder24,
  RoundedBorder8,
}

enum TextFormFieldPadding {
  PaddingAll15,
  PaddingT15,
  PaddingT15_1,
  PaddingT43,
  PaddingAll12,
  PaddingT20,
  PaddingT13,
}

enum TextFormFieldVariant {
  None,
  FillGray50,
  FillGray90001,
  FillGray10001,
  OutlineRedA700,
}

enum TextFormFieldFontStyle {
  PJSm16,
  PJSBold14,
  PJSRegular12,
  PJSSemiBold12,
  PJSm16Gray900,
  PJSSemiBold16,
  PJSSemiBold14,
  PJSBold14Gray900,
}
