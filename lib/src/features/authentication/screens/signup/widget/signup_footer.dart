import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/constants/color_before_login.dart';
import 'package:habittracker/src/constants/image_string_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/features/authentication/screens/login/login_screen.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        TextButton(
          onPressed: () {
            Get.off(() => const LoginScreen());
          },
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: hAlreadyHaveAnAccount,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextSpan(text: hLogin.toUpperCase())
          ])),
        )
      ],
    );
  }
}
