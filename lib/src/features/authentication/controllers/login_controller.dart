import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // static LoginController get instance => Get.find();

  //Gets data from user input aka formfields/textfields
  final email = TextEditingController();
  final password = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }
}
