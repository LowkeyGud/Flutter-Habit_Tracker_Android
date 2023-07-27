import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:habittracker/src/features/authentication/controllers/on_boarding_controller.dart';

// ignore: must_be_immutable
class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onBoardingController = OnBoardingController();
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            liquidController: onBoardingController.controller,
            onPageChangeCallback: onBoardingController.onPageChangeCallback,
            pages: onBoardingController.pages,
          ),
          Obx(
            () => (onBoardingController.currentPage.value != 2)
                ? Positioned(
                    bottom: 70,
                    child: CustomButton(
                      height: getVerticalSize(46),
                      width: getHorizontalSize(81),
                      text: "lbl_next".tr,
                      shape: ButtonShape.RoundedBorder20,
                      padding: ButtonPadding.PaddingAll14,
                      fontStyle: ButtonFontStyle.PJSSemiBold14,
                      onTap: () => onBoardingController.animateToNextSlide(),
                    ),
                  )
                : Positioned(
                    bottom: 70,
                    child: CustomButton(
                        height: getVerticalSize(46),
                        width: getHorizontalSize(129),
                        text: "lbl_get_started".tr,
                        shape: ButtonShape.RoundedBorder20,
                        padding: ButtonPadding.PaddingAll14,
                        fontStyle: ButtonFontStyle.PJSSemiBold14,
                        onTap: () {
                          onBoardingController.completeOnboarding();
                          Get.offAll(() => const Welcome());
                        }),
                  ),
          ),
          Positioned(
            top: 30,
            right: 20,
            child: TextButton(
              onPressed: () => onBoardingController.skip(),
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
