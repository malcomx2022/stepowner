import 'package:flutter/material.dart';

import '../../utils/change_language/shared_preference_helper.dart';

class LanguageProvider extends ChangeNotifier {
  late SharedPreferenceHelper _sharedPrefsHelper;

  /// TODO Localization: Specify the default language here by replacing 'en' with the default language code
  Locale _appLocale = const Locale('en');

  LanguageProvider() {
    _sharedPrefsHelper = SharedPreferenceHelper();
  }

  Locale get appLocale {
    _sharedPrefsHelper.appLocale?.then((localeValue) {
      _appLocale = Locale(localeValue);
    });

    return _appLocale;
  }

  void updateLanguage(String languageCode) {
    if (languageCode == "zh") {
      _appLocale = const Locale("zh");
    }

    /// TODO Localization: Add else-if blocks for more languages
    // else if (languageCode == "fr") {
    //   _appLocale = const Locale("fr");
    // }
    else {
      _appLocale = const Locale("en");
    }

    _sharedPrefsHelper.changeLanguage(languageCode);
    notifyListeners();
  }
}
