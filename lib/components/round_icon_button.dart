import 'package:flutter/material.dart';

import '../utils/constants.dart';

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Color? iconColor;
  final double? elevation;
  final Function()? onPressed;

  const RoundIconButton(
      {super.key,
      required this.icon,
      this.size,
      this.color,
      this.iconColor,
      this.elevation,
      @required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      elevation: elevation ?? 0,
      fillColor: color ?? Colors.white,
      constraints: BoxConstraints.tightFor(
        width: size ?? 56,
        height: size ?? 56,
      ),
      child: Icon(
        icon,
        color: iconColor ?? kColorBlue,
      ),
    );
  }
}
