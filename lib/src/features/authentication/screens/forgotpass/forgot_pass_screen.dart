import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/common_widgets/form/form_header.dart';
import 'package:habittracker/src/constants/image_string_before_login.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  final textEditingController = TextEditingController();
  final authController = Get.put(AuthenticationRepository());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: Column(
              children: [
                const SizedBox(height: defaultSize * 4),
                FormHeaderWidget(
                  image: hForgotPassImage,
                  title: hForgotPass.toUpperCase(),
                  subTitle: hForgotPassSubtitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: hFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                            label: Text(hEmail),
                            hintText: hEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                authController.sendPasswordResetOTP(
                                    textEditingController.text);
                              },
                              child: const Text(hNext))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
