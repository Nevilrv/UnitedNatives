import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/preferences.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/configs/theme.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_theme.dart';
import 'package:flutter/material.dart';

class ThemeState {
  final ThemeModel theme;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final String font;
  final DarkOption darkOption;
  final double textScaleFactor;

  ThemeState({
    this.theme,
    this.lightTheme,
    this.darkTheme,
    this.font,
    this.textScaleFactor,
    this.darkOption,
  });

  factory ThemeState.fromDefault() {
    return ThemeState(
        theme: AppTheme.defaultTheme,
        lightTheme: AppTheme.getTheme(
            theme: AppTheme.defaultTheme,
            brightness: Brightness.light,
            font: AppTheme.defaultFont),
        darkTheme: AppTheme.getTheme(
            theme: AppTheme.defaultTheme,
            brightness: Brightness.dark,
            font: AppTheme.defaultFont),
        font: AppTheme.defaultFont,
        darkOption: AppTheme.darkThemeOption);
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.fromDefault());

  void onChangeTheme({
    ThemeModel theme,
    String font,
    DarkOption darkOption,
    double textScaleFactor,
  }) async {
    ///Setup Theme with setting darkOption
    final currentState = AppBloc.themeCubit.state;
    theme ??= currentState.theme;
    font ??= currentState.font;
    darkOption ??= currentState.darkOption;
    textScaleFactor ??= currentState.textScaleFactor ?? 1.0;
    ThemeState themeState;

    ///Dark mode option
    switch (darkOption) {
      case DarkOption.dynamic:
        Preferences.setString(Preferences.darkOption, 'dynamic');
        themeState = ThemeState(
          theme: theme,
          lightTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            font: font,
          ),
          darkTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            font: font,
          ),
          font: font,
          darkOption: darkOption,
          textScaleFactor: textScaleFactor,
        );
        break;
      case DarkOption.alwaysOn:
        Preferences.setString(Preferences.darkOption, 'on');
        themeState = ThemeState(
          theme: theme,
          lightTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            font: font,
          ),
          darkTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            font: font,
          ),
          font: font,
          darkOption: darkOption,
          textScaleFactor: textScaleFactor,
        );
        break;
      case DarkOption.alwaysOff:
        Preferences.setString(Preferences.darkOption, 'off');
        themeState = ThemeState(
          theme: theme,
          lightTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            font: font,
          ),
          darkTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            font: font,
          ),
          font: font,
          darkOption: darkOption,
          textScaleFactor: textScaleFactor,
        );
        break;
    }

    ///Theme
    Preferences.setString(
      Preferences.theme,
      jsonEncode(themeState.theme.toJson()),
    );

    ///Font
    Preferences.setString(Preferences.font, themeState.font);

    ///Text Scale
    if (themeState.textScaleFactor != null) {
      Preferences.setDouble(
        Preferences.textScaleFactor,
        textScaleFactor,
      );
    }

    ///Notify
    emit(themeState);
  }
}
