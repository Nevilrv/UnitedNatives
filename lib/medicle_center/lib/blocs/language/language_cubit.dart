import 'package:bloc/bloc.dart';
import 'package:united_natives/medicle_center/lib/configs/language.dart';
import 'package:united_natives/medicle_center/lib/configs/preferences.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(AppLanguage.defaultLanguage);

  ///On Change Language
  void onUpdate(Locale locale) {
    emit(locale);

    ///Preference save
    Preferences.setString(
      Preferences.language,
      locale.languageCode,
    );
  }
}
