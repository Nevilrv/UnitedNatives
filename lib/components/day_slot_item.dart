import 'package:doctor_appointment_booking/controller/book_appointment_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../utils/constants.dart';

class DaySlotItem extends StatelessWidget {
  final int index;
  final Function onTap;
  final String date;
  final int slot;

  final BookAppointmentController _bookAppointmentController = Get.find();

  DaySlotItem(
      {Key key,
      @required this.index,
      @required this.onTap,
      @required this.date,
      @required this.slot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(
            horizontal: 25,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: _bookAppointmentController.selectedIndex.value == index
                  ? Colors.blue[300]
                  : Colors.grey,
              width: 2, //selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(date))}',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: kColorPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '$slot ${Translate.of(context).translate('slots_available').toLowerCase()}',
                style: TextStyle(
                  color: Colors.greenAccent[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
