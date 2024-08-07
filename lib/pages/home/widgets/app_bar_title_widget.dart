import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:flutter/material.dart';

class AppBarTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _isDark
            ? Image.asset('assets/images/neww_b_Logo.png',
                width: 50.0, height: 50.0, fit: BoxFit.cover)
            : Image.asset(
                'assets/images/neww_w_Logo.png',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
        SizedBox(
          width: 5,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'United ',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 24)),
              TextSpan(
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
