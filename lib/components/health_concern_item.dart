import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

class HealthConcernItem extends StatelessWidget {
  final String specialityName;
  final String specialityImg;
  final Function onTap;

  const HealthConcernItem(
      {Key key,
      @required this.onTap,
      @required this.specialityName,
      this.specialityImg})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(specialityImg) ??
                    AssetImage('assets/images/medicine.png'),
                radius: 25,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  Translate.of(context).translate(specialityName) + '\n',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
