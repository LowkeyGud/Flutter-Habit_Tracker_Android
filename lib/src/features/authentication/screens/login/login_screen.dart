import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/common_widgets/form/form_header.dart';
import 'package:habittracker/src/constants/image_string_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/features/authentication/controllers/login_controller.dart';

import 'widgets/login_footer.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    //Get the size in LoginHeaderWidget()
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHeaderWidget(
                  image: hWelcomeImage,
                  title: hWelcomeTitle,
                  subTitle: hWelcomeSubtitle,
                ),
                LoginForm(),
                LoginFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
