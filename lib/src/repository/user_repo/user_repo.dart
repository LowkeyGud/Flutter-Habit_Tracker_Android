import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/features/authentication/models/user_model.dart';
import 'package:habittracker/src/repository/error_handlers/default_signup_failure.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user, FirebaseAuth auth) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      // print("Money: $userCredential.user");
      if (userCredential.user != null) {
        await _db.collection("User").doc(user.email).set(user.toJson());
        Get.snackbar(
          "All set",
          "Your Account has been successfully created.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } on FirebaseAuthException catch (e) {
      final ex = DefaultSignUpFailure.code(e.code);
      Get.showSnackbar(GetSnackBar(
        message: ex.message,
        duration: const Duration(seconds: 3),
      ));
    }
  }

  dbUpdate(User? user) async {
    await _db.collection("User").doc(user!.email).set({
      "FullName": user.displayName,
      "Email": user.email,
      "Photo-Url": user.photoURL,
    });
    Get.snackbar(
      "All set",
      "Welcome ${user.displayName}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );
  }
}
