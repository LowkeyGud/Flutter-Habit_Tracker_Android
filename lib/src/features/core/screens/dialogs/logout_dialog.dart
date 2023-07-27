import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';

// ignore_for_file: must_be_immutable
class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: getHorizontalSize(312),
        padding: getPadding(all: 16),
        decoration: AppDecoration.fillWhiteA70001
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: getHorizontalSize(191),
                  margin: getMargin(top: 17),
                  child: Text("msg_are_you_sure_you".tr,
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: AppStyle.txtPJSSemiBold18Gray90001
                          .copyWith(letterSpacing: getHorizontalSize(0.09)))),
              CustomButton(
                  onTap: () => Navigator.pop(context),
                  height: getVerticalSize(46),
                  width: getHorizontalSize(180),
                  text: "lbl_cancel".tr,
                  margin: getMargin(top: 29),
                  shape: ButtonShape.RoundedBorder20,
                  padding: ButtonPadding.PaddingAll14,
                  fontStyle: ButtonFontStyle.PJSSemiBold14),
              GestureDetector(
                  onTap: () {
                    AuthenticationRepository().logout();
                  },
                  child: Padding(
                      padding: getPadding(top: 20, bottom: 17),
                      child: Text("lbl_log_out".tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPJSSemiBold14.copyWith(
                              letterSpacing: getHorizontalSize(0.07)))))
            ]));
  }
}
