import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/utils/app_themes.dart';

class ThemeController extends GetxController {
  var isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  Color? color;

  updateTheme(dynamic darkTheme) {
    isDark = darkTheme;
    Prefs.setBool(Prefs.DARKTHEME, darkTheme);

    Get.changeTheme(darkTheme ? Themes().isDark : Themes().isLight);

    color = isDark ? Colors.white.withOpacity(0.12) : Colors.grey[200];

    update();
  }
}
