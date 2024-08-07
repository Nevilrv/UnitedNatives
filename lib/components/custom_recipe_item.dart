import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:flutter/material.dart';

class CustomRecipeItem extends StatelessWidget {
  final String purpose;
  final String title;
  final String subTitle;
  final String days;
  final String pills;

  const CustomRecipeItem(
      {Key key,
      @required this.title,
      @required this.purpose,
      @required this.subTitle,
      @required this.days,
      @required this.pills})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Purpose of visit : ",
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                ),
                Expanded(
                  child: Text(
                    purpose,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  child: Image.asset(
                    'assets/images/icon_pill_bottle.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.red.shade700,
                            ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        subTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 15),
            Divider(height: 1, color: Colors.white),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: 75),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('days_of_treat'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        days,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('pill_per_day'),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        pills,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
