import 'package:flutter/material.dart';
import 'package:united_natives/utils/constants.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color? color;
  final double? borderRadius;
  final EdgeInsets? padding;
  final double? textSize;

  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderRadius,
    this.padding,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
          side: BorderSide(color: color ?? kColorPrimary, width: 1),
        ),
      ),
      child: Padding(
        padding: padding ??
            const EdgeInsets.only(top: 9, bottom: 10, left: 16, right: 16),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color ?? kColorPrimary,
                fontSize: textSize ??
                    Theme.of(context).textTheme.labelLarge?.fontSize,
              ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
