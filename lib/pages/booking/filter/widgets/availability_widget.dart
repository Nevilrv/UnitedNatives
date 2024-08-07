import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

enum Availability { anyDay, today, next3Days, commingWeekend }

class AvailabilityWidget extends StatefulWidget {
  final Color color;

  const AvailabilityWidget({Key key, @required this.color}) : super(key: key);
  @override
  _AvailabilityWidgetState createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  Availability _availability = Availability.anyDay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          color: widget.color,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              Translate.of(context).translate('availability'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        RadioListTile(
          value: Availability.anyDay,
          onChanged: (value) {
            setState(() {
              _availability = value;
            });
          },
          groupValue: _availability,
          title: Text(Translate.of(context).translate('available_any_day')),
        ),
        RadioListTile(
          value: Availability.today,
          onChanged: (value) {
            setState(() {
              _availability = value;
            });
          },
          groupValue: _availability,
          title: Text(Translate.of(context).translate('available_today')),
        ),
        RadioListTile(
          value: Availability.next3Days,
          onChanged: (value) {
            setState(() {
              _availability = value;
            });
          },
          groupValue: _availability,
          title:
              Text(Translate.of(context).translate('available_in_next_3_days')),
        ),
        RadioListTile(
          value: Availability.commingWeekend,
          onChanged: (value) {
            setState(() {
              _availability = value;
            });
          },
          groupValue: _availability,
          title:
              Text(Translate.of(context).translate('available_coming_weekend')),
        )
      ],
    );
  }
}
