import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/features/core/screens/habit.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

class LoginController extends GetxController {
  // static LoginController get instance => Get.find();

  //Gets data from user input aka formfields/textfields
  final email = TextEditingController();
  final password = TextEditingController();

  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  Future<void> registerUser(String email, String password) async {
    await AuthenticationRepository.instance
        .loginWithEmailAndPassword(email, password);
    Get.to(() => const HabitUpdateScreen());
  }
}
