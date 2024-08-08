import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? textSize;
  final Color? color;
  final Color? fontColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.textSize,
    this.color,
    this.fontColor,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: elevation ?? 0,
      fillColor: color ?? kColorBlue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4)),
      child: Padding(
        padding: padding ??
            const EdgeInsets.only(top: 9, bottom: 9, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: fontColor ?? Colors.white, fontSize: textSize),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
