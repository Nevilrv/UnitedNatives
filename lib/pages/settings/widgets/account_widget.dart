import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:flutter/material.dart';

class AccountWidget extends StatelessWidget {
  final Color color;

  const AccountWidget({Key key, @required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: color,
          padding: EdgeInsets.all(15),
          child: Text(
            Translate.of(context).translate('accounts'),
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: Text(
            Translate.of(context).translate('logout'),
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.exit_to_app, color: Colors.blue),
          onTap: () => Navigator.of(context).pushNamed(Routes.doctorlogin),
        ),
      ],
    );
  }
}
