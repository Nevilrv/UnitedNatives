import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../utils/pref_manager.dart';

enum Language { english, spanish, italian, portuguese }

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  State<ChangeLanguagePage> createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  var _language;
  @override
  void initState() {
    super.initState();
    switch (Prefs.getString('language', def: 'en')) {
      case 'en':
        _language = Language.english;
        break;

      case 'es':
        _language = Language.spanish;
        break;

      case 'it':
        _language = Language.italian;
        break;

      case 'pt':
        _language = Language.portuguese;
        break;

      default:
        break;
    }
  }

  _changeLanguage(int index) {
    Locale? locale = EasyLocalization.of(context)?.locale;
    switch (index) {
      case 0:
        _language = Language.english;
        Prefs.setString(Prefs.LANGUAGE, 'en');
        break;

      case 1:
        _language = Language.spanish;
        Prefs.setString(Prefs.LANGUAGE, 'es');
        break;

      case 2:
        _language = Language.italian;
        Prefs.setString(Prefs.LANGUAGE, 'it');
        break;

      case 3:
        _language = Language.portuguese;
        Prefs.setString(Prefs.LANGUAGE, 'pt');
        break;
    }

    locale = EasyLocalization.of(context)?.supportedLocales[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          Translate.of(context)!.translate('language_settings'),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RadioListTile(
              value: Language.english,
              onChanged: (value) => _changeLanguage(0),
              groupValue: _language,
              title: Text(
                Translate.of(context)!.translate('english'),
              ),
            ),
            const Divider(
              height: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            RadioListTile(
              value: Language.spanish,
              onChanged: (value) => _changeLanguage(1),
              groupValue: _language,
              title: Text(
                Translate.of(context)!.translate('spanish'),
              ),
            ),
            const Divider(
              height: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            RadioListTile(
              value: Language.italian,
              onChanged: (value) => _changeLanguage(2),
              groupValue: _language,
              title: Text(
                Translate.of(context)!.translate('italian'),
              ),
            ),
            const Divider(
              height: 0.5,
              indent: 10,
              endIndent: 10,
            ),
            RadioListTile(
              value: Language.portuguese,
              onChanged: (value) => _changeLanguage(3),
              groupValue: _language,
              title: Text(
                Translate.of(context)!.translate('portuguese'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
