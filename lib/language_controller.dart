import 'package:get/get.dart';

class LanguageController extends GetxController {
  RxString selectedLanguage = 'English'.obs;

  void changeLanguage(String languageCode) {
    selectedLanguage.value = languageCode;
    // Perform any additional actions related to language change, such as updating UI, reloading data, etc.
  }
}
