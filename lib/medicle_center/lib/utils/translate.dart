import 'package:united_natives/medicle_center/lib/app_locale_delegate.dart';
import 'package:united_natives/medicle_center/lib/utils/utils.dart';
import 'package:flutter/material.dart';

class Translate {
  final Locale locale;
  LocalizationsDelegate<Translate> delegate = const AppLocaleDelegate();
  Map<String, String>? _localizedStrings;

  Translate(this.locale);

  static Translate? of(BuildContext context) {
    return Localizations.of<Translate>(context, Translate);
  }

  Future<bool> load() async {
    final jsonMap = await UtilAsset.loadJson(
      "assets/locale/${locale.languageCode}.json",
    );

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key ?? '';
  }
}
