import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../../constants/image_string_before_login.dart';
import '../../../constants/text_strings.dart';
import '../models/model_onboarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();

  // Logic for showing OnBoardingScreen only once
  final box = GetStorage();

  bool get shouldShowOnboarding => !(box.read('hasShownOnboarding') ?? false);

  void completeOnboarding() {
    box.write('hasShownOnboarding', true);
  }

  // Onboarding Pages
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tonBoardingImage1,
        title: hOnboardingTitle1,
        subtitle: hOnboardingSubTitle1,
        counterText: hOnBoardingCounter1,
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tonBoardingImage2,
        title: hOnboardingTitle2,
        subtitle: hOnboardingSubTitle2,
        counterText: hOnBoardingCounter2,
        bgColor: Colors.white,
      ),
    ),
    OnBoardingPageWidget(
      model: OnBoardingModel(
        image: tonBoardingImage3,
        title: hOnboardingTitle3,
        subtitle: hOnboardingSubTitle3,
        counterText: hOnBoardingCounter3,
        bgColor: Colors.white,
      ),
    ),
  ];

  // Skipp button functionality
  skip() => controller.jumpToPage(page: 2);

  // Sliding Animation using LiquidController
  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }

  onPageChangeCallback(int activePageIndex) =>
      currentPage.value = activePageIndex;
}
