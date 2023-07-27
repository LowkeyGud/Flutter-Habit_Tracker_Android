import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/features/authentication/models/user_model.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';
import 'package:habittracker/src/repository/user_repo/user_repo.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  //Gets data from user input aka formfields/textfields
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  final userRepo = Get.put(UserRepo());

  void registerUser(UserModel user) async {
    try {
      await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(user);
          // SignupController.instance.createUser(user);
    } on FirebaseAuthException catch (e) {
      Get.showSnackbar(GetSnackBar(title: 'error', message: e.code));
    }
  }

  // Future<void> createUser(UserModel user) async {
  //   await userRepo.createUser(user);
  // }
}
