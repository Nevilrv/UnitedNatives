import 'package:doctor_appointment_booking/medicle_center/lib/utils/color.dart';
import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final Color primary;
  final Color secondary;

  ThemeModel({
    this.name,
    this.primary,
    this.secondary,
  });

  factory ThemeModel.fromJson(Map<String, dynamic> json) {
    return ThemeModel(
      name: json['name'] ?? '',
      primary: UtilColor.getColorFromHex(json['primary']),
      secondary: UtilColor.getColorFromHex(json['secondary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "primary": primary.toHex,
      "secondary": secondary.toHex,
    };
  }
}
