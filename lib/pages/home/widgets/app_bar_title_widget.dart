import 'package:flutter/material.dart';
import 'package:united_natives/utils/pref_manager.dart';

class AppBarTitleWidget extends StatelessWidget {
  const AppBarTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        isDark
            ? Image.asset('assets/images/neww_b_Logo.png',
                width: 50.0, height: 50.0, fit: BoxFit.cover)
            : Image.asset(
                'assets/images/neww_w_Logo.png',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
        const SizedBox(
          width: 5,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'United ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 24)),
              const TextSpan(
                text: 'Natives',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
