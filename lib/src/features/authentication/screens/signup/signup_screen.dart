import 'package:flutter/material.dart';
import 'package:habittracker/src/common_widgets/form/form_header.dart';
import 'package:habittracker/src/constants/image_string_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/features/authentication/screens/signup/widget/signup_footer.dart';

import 'widget/signup_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: const Column(
              children: [
                // FROM HEADER WITH IMAGE AND TITLE

                FormHeaderWidget(
                  image: hWelcomeImage,
                  title: hSignUpTtile,
                  subTitle: hSignUpSubtitle,
                  imageHeight: 0.15,
                ),

                // ACTUAL FORM WITH FORM TEXTFIELDS

                SignUpFormWidget(),

                //ALREADY HAVE A ACCOUNT / GOOGLE SIGN IN

                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
