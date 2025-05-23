import 'package:flutter/material.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:provider/provider.dart';
import '../../provider/provider_model/language_provider.dart';

/// TODO Localization: Add more languages here.
enum LanguageAction {
  english,
  chinese,
  //french, // Add more languages here
}

class SettingLanguageAction extends StatelessWidget {
  const SettingLanguageAction({super.key});

  @override
  Widget build(BuildContext context) {
    LanguageProvider languageProvider = Provider.of(context);
    Locale appCurrentLocale = languageProvider.appLocale;

    return PopupMenuButton<LanguageAction>(
        icon: const Icon(Icons.language_outlined, color: Colors.red),
        onSelected: (LanguageAction result) {
          switch (result) {
            case LanguageAction.english:
              languageProvider.updateLanguage("en");
              break;
            case LanguageAction.chinese:
              languageProvider.updateLanguage("zh");
              break;

            /// TODO Localization: Add more languages here.
            // case LanguageAction.french:
            //  languageProvider.updateLanguage("fr");
            // break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<LanguageAction>>[
              PopupMenuItem<LanguageAction>(
                  value: LanguageAction.english,
                  enabled:
                      appCurrentLocale == const Locale("en") ? false : true,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("settingPopUpToggleEnglish"),
                    style: const TextStyle(),
                  )),
              PopupMenuItem<LanguageAction>(
                  value: LanguageAction.chinese,
                  enabled:
                      appCurrentLocale == const Locale("zh") ? false : true,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("settingPopUpToggleChinese"),
                    style: const TextStyle(),
                  )),

              /// TODO Localization: Add more languages here.
              // PopupMenuItem<LanguageAction>(
              //   value: LanguageAction.french,
              //   enabled: appCurrentLocale == const Locale("fr") ? false : true,
              //   child: Text(
              //     AppLocalizations.of(context).translate("settingPopUpToggleFrench"),
              //     style: const TextStyle(),
              //   )),
            ]);
  }
}
