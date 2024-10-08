import 'package:flutter/material.dart';
import 'package:united_natives/pages/reminder2/animations/fade_animation.dart';

class MedicineEmptyState extends StatelessWidget {
  const MedicineEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      .5,
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/emergency.gif',
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          const Text(
            'No Reminder Added yet',
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 22, letterSpacing: 1.2),
          )
        ],
      ),
    );
  }
}
