import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class NoAppointments2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Image.asset('assets/images/icon_no_appointments.png'),
          SizedBox(
            height: 10,
          ),
          Text(
            Translate.of(context).translate('there_is_no_appontments'),
            style: TextStyle(
              color: kColorDarkBlue,
              fontSize: 22,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Translate.of(context).translate('create_new_appointment'),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
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
