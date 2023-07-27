import 'package:get/get.dart';
import 'package:habittracker/localization/chinese/chinese_translations.dart';
import 'package:habittracker/localization/en_us/en_us_translations.dart';
import 'package:habittracker/localization/nepali/nepali_translations.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUs, 'ne_Ne': neNe, 'ch_simplified': chCh};
}
