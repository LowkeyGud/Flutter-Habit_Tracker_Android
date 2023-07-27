import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreenn extends GetView {
  final introKey = GlobalKey<IntroductionScreenState>();

  OnboardingScreenn({super.key});

  void _onIntroEnd() {
    // Do something when the onboarding is done
  }

  void _onSkip() {
    // Do something when the onboarding is skipped
  }

  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/images/$assetName.gif', width: 350.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Title of first page",
          body:
              "Here you can write the description of the page, to explain someting...",
          image: _buildImage('Done'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
            bodyTextStyle: bodyStyle,
            imagePadding: EdgeInsets.zero,
          ),
        ),
        PageViewModel(
          title: "Title of second page",
          body:
              "Here you can write the description of the page, to explain someting...",
          image: _buildImage('Done'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
            bodyTextStyle: bodyStyle,
            imagePadding: EdgeInsets.zero,
          ),
        ),
        PageViewModel(
          title: "Title of third page",
          body:
              "Here you can write the description of the page, to explain someting...",
          image: _buildImage('Done'),
          decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
            bodyTextStyle: bodyStyle,
            imagePadding: EdgeInsets.zero,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(),
      onSkip: () => _onSkip(),
      showSkipButton: true,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.orange,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
