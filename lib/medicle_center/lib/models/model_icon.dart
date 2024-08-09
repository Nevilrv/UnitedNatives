import 'package:flutter/material.dart';

class IconModel {
  final String? title;
  final Widget? icon;
  final String? value;

  IconModel({
    this.title,
    this.icon,
    this.value,
  });

  @override
  bool operator ==(other) => other is IconModel && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
