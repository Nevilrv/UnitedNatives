import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TimeSlotItem extends StatelessWidget {
  final String time;
  final String time1;
  final Function onTap;
  final bool isClosed;

  const TimeSlotItem(
      {Key key,
      @required this.time,
      this.time1,
      @required this.onTap,
      this.isClosed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.height;

    return isClosed
        ? SizedBox()
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(4),
            child: Container(
              height: h * 0.065,
              width: w * 0.095,
              margin: EdgeInsets.all(w * 0.006),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        isClosed ? Colors.grey.withOpacity(0.35) : Colors.grey,
                    width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    time,
                    style: TextStyle(
                        color: isClosed
                            ? kColorPrimary.withOpacity(0.35)
                            : kColorPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    time1,
                    style: TextStyle(
                        color: isClosed
                            ? kColorPrimary.withOpacity(0.35)
                            : kColorPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
  }
}
