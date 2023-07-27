import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:habittracker/firebase_options.dart';
import 'package:habittracker/language_controller.dart';
import 'package:habittracker/src/repository/auth_repo/auth_repo.dart';
import 'package:habittracker/src/utils/theme/theme.dart';

import 'package:flutter/services.dart';
import 'src/app_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init();
  // boxHabit = await Hive.openBox<Habit>('habitBox');
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  final languageController = Get.put(LanguageController());
  runApp(MyApp(languageController: languageController));
}

class MyApp extends StatelessWidget {
  final LanguageController languageController;

  const MyApp({super.key, required this.languageController});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: GAppTheme.lightTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConstant.redA700),
        // useMaterial3: true,
      ),
      darkTheme: GAppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 600),
      translations: AppLocalization(),
      locale: Locale(languageController
          .selectedLanguage.value), //for setting localization strings
      fallbackLocale: const Locale('en', 'US'),
      home: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
