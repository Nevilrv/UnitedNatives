import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class NoAppointments2Widget extends StatelessWidget {
  const NoAppointments2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Image.asset('assets/images/icon_no_appointments.png'),
          const SizedBox(
            height: 10,
          ),
          Text(
            Translate.of(context)!.translate('there_is_no_appontments'),
            style: const TextStyle(
              color: kColorDarkBlue,
              fontSize: 22,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            Translate.of(context)!.translate('create_new_appointment'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 100,
            child: Icon(
              Icons.arrow_downward,
              color: kColorBlue,
            ),
          ),
        ],
      ),
    );
  }
}
