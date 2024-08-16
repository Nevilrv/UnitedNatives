import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    final opacityTween = Tween<double>(begin: 0.0, end: 1.0);
    final translateYTween = Tween<double>(begin: -30.0, end: 0.0);

    return PlayAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      delay: Duration(milliseconds: (500 * delay).round()),
      tween: opacityTween,
      builder: (context, opacity, child) {
        return Transform.translate(
          offset: Offset(0, translateYTween.transform(opacity)),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
