import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';

class HabitUpdatedDialog extends StatelessWidget {
  const HabitUpdatedDialog({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getHorizontalSize(
        327,
      ),
      padding: getPadding(
        left: 26,
        top: 28,
        right: 26,
        bottom: 28,
      ),
      decoration: AppDecoration.fillWhiteA700.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: getVerticalSize(
                  134,
                ),
                width: getHorizontalSize(
                  121,
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: getSize(
                          121,
                        ),
                        width: getSize(
                          121,
                        ),
                        child: Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgThumbsup1,
                              height: getSize(
                                121,
                              ),
                              width: getSize(
                                121,
                              ),
                              alignment: Alignment.center,
                            ),
                            CustomImageView(
                              svgPath: ImageConstant.imgStar1,
                              height: getSize(
                                17,
                              ),
                              width: getSize(
                                17,
                              ),
                              alignment: Alignment.topLeft,
                              margin: getMargin(
                                left: 10,
                                top: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomImageView(
                      svgPath: ImageConstant.imgStar2,
                      height: getSize(
                        33,
                      ),
                      width: getSize(
                        33,
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
              ),
              CustomImageView(
                svgPath: ImageConstant.imgStar3,
                height: getSize(
                  17,
                ),
                width: getSize(
                  17,
                ),
                margin: getMargin(
                  left: 1,
                  top: 44,
                  bottom: 72,
                ),
              ),
            ],
          ),
          Container(
            width: getHorizontalSize(
              165,
            ),
            margin: getMargin(
              top: 31,
            ),
            child: Text(
              "msg_habit_updated_successfully".tr,
              maxLines: null,
              textAlign: TextAlign.center,
              style: AppStyle.txtPJSBold24Gray90001.copyWith(
                letterSpacing: getHorizontalSize(
                  0.12,
                ),
              ),
            ),
          ),
          Container(
            width: getHorizontalSize(
              271,
            ),
            margin: getMargin(
              top: 5,
            ),
          ),
          CustomButton(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            height: getVerticalSize(
              56,
            ),
            text: "lbl_continue".tr,
            margin: getMargin(
              top: 28,
            ),
          ),
        ],
      ),
    );
  }
}
