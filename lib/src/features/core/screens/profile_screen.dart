import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/language_controller.dart';
import 'package:habittracker/src/features/core/screens/dialogs/logout_dialog.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';

import 'package:flutter/material.dart';
import 'package:habittracker/src/app_export.dart';
import 'package:habittracker/src/utils/theme/widget_theme/custom_button.dart';

class DropdownController extends GetxController {
  RxString selectedOption = 'English'.obs;
  List<String> options = [
    'English',
    'नेपाली',
    '中国人',
    'Español',
    'Deutsch',
    'Português',
    'Русский',
    'हिन्दी',
    '日本語',
    'العربية',
    'বাংলা',
  ];
}

class LanguageSwitch extends StatelessWidget {
  LanguageSwitch({super.key});

  final LanguageController languageController = Get.find();
  final DropdownController _dropdownController = Get.put(DropdownController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _dropdownController.selectedOption.value,
            onChanged: (String? newValue) {
              _dropdownController.selectedOption.value = newValue!;
              languageController.changeLanguage(newValue);
              Get.updateLocale(Locale(newValue));
            },
            items: _dropdownController.options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            isExpanded: true,
          ),
        ),
      ),
    );
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
  String photoURL = '';

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
          photoURL = userData['Photo-Url'];
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
                            child: photoURL.isNotEmpty
                                ? CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: photoURL,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.person_3),
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
                        const SizedBox(height: 15.0),
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
