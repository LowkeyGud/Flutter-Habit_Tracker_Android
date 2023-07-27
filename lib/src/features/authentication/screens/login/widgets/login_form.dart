import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/features/core/screens/app_entry_point.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/features/authentication/controllers/login_controller.dart';
import 'package:habittracker/src/features/authentication/screens/forgotpass/forgot_pass_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: hEmail,
                  hintText: hEmail,
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: hPassword,
                  hintText: hPassword,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      controller.togglePasswordVisibility();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Get.to(() => ForgetPasswordScreen());
                  },
                  child: const Text(hForgetPassword)),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: controller.email.text,
                        password: controller.password.text,
                      );
                      Get.offAll(const AppEntryPoint());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Get.snackbar("Not Signed Up Yet🤦‍♂️",
                            "User not found for that email",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(1),
                            colorText:
                                const Color.fromARGB(255, 255, 255, 255));
                      } else if (e.code == 'wrong-password') {
                        Get.snackbar(
                            "Invalid Password😑", "Forgot your passsword?",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(1),
                            colorText:
                                const Color.fromARGB(255, 255, 255, 255));
                      }
                    }
                  },
                  child: Text(hLogin.toUpperCase())),
            ),
          ],
        ),
      ),
    );
  }
}
