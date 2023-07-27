import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habittracker/src/constants/sizes.dart';
import 'package:habittracker/src/constants/text_strings.dart';
import 'package:habittracker/src/features/authentication/controllers/signup_controller.dart';
import 'package:habittracker/src/features/authentication/models/user_model.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: hFormHeight - 10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FULL NAME

            TextFormField(
              controller: controller.fullName,
              decoration: const InputDecoration(
                  label: Text(hFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded)),
            ),

            // EMAIL

            const SizedBox(height: 10),
            TextFormField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  label: Text(hEmail), prefixIcon: Icon(Icons.email_outlined)),
            ),

            // PASSWORD

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

            // SIGN UP BUTTON

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = UserModel(
                      email: controller.email.text.trim(),
                      password: controller.password.text.trim(),
                      fullName: controller.fullName.text.trim(),
                    );

                    SignupController.instance.registerUser(user);

                    // SignupController.instance.createUser(user);
                    // Get.to(() => const Dashboard());
                  }
                },
                child: Text(hSignUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
