import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/constants/color_before_login.dart';
import 'package:habittracker/src/constants/image_string_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

import '../../signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: 10.0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              backgroundColor: hWhiteColor,
              foregroundColor: hDarkColor,
              side: const BorderSide(
                color: hDarkColor,
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(vertical: hButtonHeight),
            ),
            icon: const Image(image: AssetImage(hGoogleLogo), width: 20.0),
            onPressed: () {
              AuthenticationRepository.instance.signInWithGoogle();
            },
            label: const Text(hSignInWithGoogle),
          ),
        ),
        const SizedBox(height: 10.0),
        TextButton(
          onPressed: () {
            Get.off(() => const SignUpScreen());
          },
          child: Text.rich(
            TextSpan(
                text: hDontHaveAnAccount,
                style: Theme.of(context).textTheme.bodySmall,
                children: const [
                  TextSpan(text: hSignUp, style: TextStyle(color: Colors.blue))
                ]),
          ),
        ),
      ],
    );
  }
}
