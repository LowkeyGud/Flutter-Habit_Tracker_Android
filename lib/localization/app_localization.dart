import 'package:get/get.dart';
import 'package:habittracker/localization/languages/arabic_translations.dart';
import 'package:habittracker/localization/languages/bengali_translations.dart';
import 'package:habittracker/localization/languages/chinese_translations.dart';
import 'package:habittracker/localization/languages/deutsch_translations.dart';
import 'package:habittracker/localization/languages/en_us_translations.dart';
import 'package:habittracker/localization/languages/hindi_translations.dart';
import 'package:habittracker/localization/languages/japanese_translations.dart';
import 'package:habittracker/localization/languages/nepali_translations.dart';
import 'package:habittracker/localization/languages/portuguese_translations.dart';
import 'package:habittracker/localization/languages/russian_translations.dart';

import 'languages/espanol_translations.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'English': enUs,
        'नेपाली': neNe,
        '中国人': chCh,
        'Português': ptBr,
        'Español': espanolTranslations,
        'Deutsch': deutschTranslations,
        'Русский': russianTranslations,
        'हिन्दी': enHindi,
        '日本語': japaneseTranslations,
        'العربية': arabicTranslations,
        'বাংলা': bengaliTranslations,
      };
}
