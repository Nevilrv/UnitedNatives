import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/utils/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  Color color;

  updateTheme(dynamic darkTheme) {
    isDark = darkTheme;
    Prefs.setBool(Prefs.DARKTHEME, darkTheme);

    Get.changeTheme(darkTheme ? Themes().isDark : Themes().isLight);

    color = isDark ? Colors.white.withOpacity(0.12) : Colors.grey[200];

    update();
  }
}
