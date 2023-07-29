import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/constants/color_before_login.dart';
import 'package:habittracker/src/constants/image_string_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/features/authentication/screens/login/login_screen.dart';
import 'package:habittracker/src/features/authentication/screens/signup/signup_screen.dart';
import 'package:habittracker/src/utils/theme/widget_theme/outlined_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    Brightness brightness = Theme.of(context).brightness;
    final isLightMode = (brightness == Brightness.light);

    return Scaffold(
      backgroundColor: isLightMode ? hWhiteColor : hDarkColor,
      body: Container(
        padding: const EdgeInsets.all(defaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(hWelcomeImage, height: height * 0.6),
            Column(
              children: [
                Text(hWelcomeTitle,
                    style: Theme.of(context).textTheme.displaySmall),
                Text(hWelcomeSubtitle,
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center),
              ],
            ),

            //LOGIN BUTTON

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: HOutlinedButtontheme.loginButton,
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(hLogin.toUpperCase()),
                  ),
                ),

                // SIGN UP BUTTON

                const SizedBox(width: 10.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const SignUpScreen());
                    },
                    child: Text(hSignUp.toUpperCase()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
