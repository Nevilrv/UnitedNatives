import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:united_natives/utils/constants.dart';

enum AppTheme {
  LightTheme,
  DarkTheme,
}

class Themes {
  final isLight = ThemeData(
    useMaterial3: true, // Add this line to use Material 3
    colorScheme: const ColorScheme.light(
      primary: kColorPrimary,
      surface: Colors.white, // or any other color you want
    ),
    brightness: Brightness.light,
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      titleTextStyle: TextStyle(
        color: kColorDarkBlue,
        fontFamily: 'NunitoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    dividerColor: Colors.grey[300],
    textTheme: TextTheme(
      titleLarge: kTextStyleButton,
      titleMedium: kTextStyleSubtitle1.copyWith(color: kColorPrimaryDark),
      titleSmall: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
      bodyLarge: kTextStyleBody2.copyWith(color: kColorPrimaryDark),
      bodyMedium: kTextStyleHeadline6.copyWith(color: kColorPrimaryDark),
      bodySmall: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
    ),
    iconTheme: const IconThemeData(color: kColorPrimary),
    cardTheme: CardTheme(
      elevation: 0,
      color: const Color(0xffEBF2F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        //side: BorderSide(width: 1, color: Colors.grey[200]),
      ),
    ),
  );

  final isDark = ThemeData(
    useMaterial3: true, // Add this line to use Material 3
    colorScheme: const ColorScheme.dark(
      primary: kColorPrimary,
    ),
    brightness: Brightness.dark,
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      iconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'NunitoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dividerColor: Colors.white54,
    textTheme: TextTheme(
      titleLarge: kTextStyleButton,
      titleMedium: kTextStyleSubtitle1.copyWith(color: Colors.white),
      titleSmall:
          kTextStyleSubtitle2.copyWith(color: Colors.white.withOpacity(0.87)),
      bodyLarge:
          kTextStyleBody2.copyWith(color: Colors.white.withOpacity(0.87)),
      bodyMedium:
          kTextStyleHeadline6.copyWith(color: Colors.white.withOpacity(0.87)),
      bodySmall:
          kTextStyleSubtitle2.copyWith(color: Colors.white.withOpacity(0.87)),
    ),
    iconTheme: const IconThemeData(color: kColorPrimary),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.87),
        ),
      ),
    ),
  );
}

final appThemeData = {
  AppTheme.LightTheme: ThemeData(
    useMaterial3: true, // Add this line to use Material 3
    colorScheme: const ColorScheme.light(
      primary: kColorPrimary,
      surface: Colors.white, // or any other color you want
    ),
    brightness: Brightness.light,
    platform: TargetPlatform.iOS,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      elevation: 1,
      color: Colors.white,
      iconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      titleTextStyle: TextStyle(
        color: kColorDarkBlue,
        fontFamily: 'NunitoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    dividerColor: Colors.grey[300],
    textTheme: TextTheme(
      titleLarge: kTextStyleButton,
      titleMedium: kTextStyleSubtitle1.copyWith(color: kColorPrimaryDark),
      titleSmall: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
      bodyLarge: kTextStyleBody2.copyWith(color: kColorPrimaryDark),
      bodyMedium: kTextStyleHeadline6.copyWith(color: kColorPrimaryDark),
      bodySmall: kTextStyleSubtitle2.copyWith(color: kColorPrimaryDark),
    ),
    iconTheme: const IconThemeData(
      color: kColorPrimary,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: const Color(0xffEBF2F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        //side: BorderSide(width: 1, color: Colors.grey[200]),
      ),
    ),
  ),
  AppTheme.DarkTheme: ThemeData(
    useMaterial3: true, // Add this line to use Material 3
    colorScheme: const ColorScheme.dark(
      primary: kColorPrimary,
      secondary: kColorPrimary,
    ),
    brightness: Brightness.dark,
    platform: TargetPlatform.iOS,

    appBarTheme: const AppBarTheme(
      elevation: 1,
      iconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      actionsIconTheme: IconThemeData(
        color: kColorPrimary,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'NunitoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dividerColor: Colors.white54,
    textTheme: TextTheme(
      titleLarge: kTextStyleButton,
      titleMedium: kTextStyleSubtitle1.copyWith(
        color: Colors.white.withOpacity(0.87),
      ),
      titleSmall: kTextStyleSubtitle2.copyWith(
        color: Colors.white.withOpacity(0.87),
      ),
      bodyLarge: kTextStyleBody2.copyWith(
        color: Colors.white.withOpacity(0.87),
      ),
      bodyMedium: kTextStyleHeadline6.copyWith(
        color: Colors.white.withOpacity(0.87),
      ),
      bodySmall: kTextStyleSubtitle2.copyWith(
        color: Colors.white.withOpacity(0.87),
      ),
    ),
    iconTheme: const IconThemeData(
      color: kColorPrimary,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(width: 0, color: Colors.transparent),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.87),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return kColorPrimary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return kColorPrimary;
        }
        return null;
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return kColorPrimary;
        }
        return null;
      }),
      trackColor:
          WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return kColorPrimary;
        }
        return null;
      }),
    ),
  ),
};

const String defaultProfileImage = "assets/images/defaultProfile.png";
