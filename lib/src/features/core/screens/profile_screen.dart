import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/language_controller.dart';
import 'package:habittracker/src/features/core/screens/dialogs/logout_dialog.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';

class LanguageSwitch extends StatelessWidget {
  LanguageSwitch({super.key});

  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SwitchListTile(
          title: Text('Switch_Language'.tr),
          value: languageController.selectedLanguage.value == 'en_US',
          onChanged: (value) {
            final newLanguage = value ? 'en_US' : 'ch_simplified';
            languageController.changeLanguage(newLanguage);
            Get.updateLocale(Locale(newLanguage));
          },
        ));
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = AuthenticationRepository().auth.currentUser;

  String fullname = '';

  String email = '';

  @override
  void initState() {
    super.initState();
    fetchHabitData();
  }

  Future<void> fetchHabitData() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('User').doc(user!.email);
      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        Map<String, dynamic> userData =
            userDocSnapshot.data() as Map<String, dynamic>;
        setState(() {
          fullname = userData['FullName'];
          email = userData['Email'];
        });
      } else {
        // Document doesn't exist
        // Handle accordingly
      }
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstant.whiteA700,
      body: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
              padding: getPadding(top: 34),
              child: Padding(
                  padding: getPadding(left: 24, right: 21, bottom: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 255, 214, 211),
                            ),
                            child: const Icon(Icons.person_3),
                          ),
                          title: Text(
                            fullname,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {},
                        ),
                        LanguageSwitch(),
                        CustomButton(
                            height: getVerticalSize(60),
                            text: "lbl_log_out".tr,
                            margin: getMargin(left: 3, top: 32),
                            variant: ButtonVariant.OutlineRedA700,
                            shape: ButtonShape.CircleBorder30,
                            fontStyle: ButtonFontStyle.PJSm16RedA700,
                            onTap: () {
                              onTapLogout();
                            })
                      ])))),
    ));
  }

  /// Displays a dialog with the [LogoutDialog] content.
  ///
  /// The [LogoutDialog] widget is created with a new
  /// instance of the [LogoutController],
  /// which is obtained using the Get.put() method.
  onTapLogout() {
    Get.dialog(const AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.only(left: 0),
      content: LogoutDialog(),
    ));
  }
}
