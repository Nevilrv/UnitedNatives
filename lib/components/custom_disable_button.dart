import 'package:flutter/material.dart';

class CustomDisableButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? textSize;

  const CustomDisableButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: elevation ?? 0,
      fillColor: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4)),
      child: Padding(
        padding: padding ??
            const EdgeInsets.only(top: 9, bottom: 10, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontSize: textSize ??
                      Theme.of(context).textTheme.labelLarge?.fontSize),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
