import 'package:doctor_appointment_booking/medicle_center/lib/models/model.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/utils.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/widgets/widget.dart';
import 'package:flutter/material.dart';

class DetailHourly extends StatefulWidget {
  final HourlyBookingModel bookingStyle;
  final VoidCallback onCalcPrice;

  const DetailHourly({
    Key key,
     this.bookingStyle,
     this.onCalcPrice,
  }) : super(key: key);

  @override
  _DetailHourlyState createState() {
    return _DetailHourlyState();
  }
}

class _DetailHourlyState extends State<DetailHourly> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Show change start date
  void _onDatePicker() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      initialDate: widget.bookingStyle.startDate ?? DateTime.now(),
      firstDate: DateTime(now.year, now.month),
      context: context,
      lastDate: DateTime(now.year + 1),
    );
    if (result != null) {
      setState(() {
        widget.bookingStyle.startDate = result;
      });
      widget.onCalcPrice();
    }
  }

  ///Show schedule picker
  void _onHourPicker() async {
    final result = await showModalBottomSheet<ScheduleModel>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomPicker(
          picker: PickerModel(
            selected: [widget.bookingStyle.schedule],
            data: widget.bookingStyle.hourList,
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        widget.bookingStyle.schedule = result;
      });
      widget.onCalcPrice();
    }
  }

  ///Show number picker
  void _onPicker(int init, Function(int) callback) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppNumberPicker(
          value: init,
        );
      },
    );
    if (result != null) {
      callback(result);
      widget.onCalcPrice();
    }
  }

  @override
  Widget build(BuildContext context) {
    String viewHour;
    final startTime = widget.bookingStyle.schedule?.start;
    final endTime = widget.bookingStyle.schedule?.end;
    if (startTime?.viewTime != null) {
      viewHour = '${startTime?.viewTime} - ${endTime?.viewTime}';
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppPickerItem(
                      leading: Icon(
                        Icons.person_outline,
                        color: Theme.of(context).hintColor,
                      ),
                      value: widget.bookingStyle.adult?.toString(),
                      title: Translate.of(context).translate('adult'),
                      onPressed: () {
                        _onPicker(widget.bookingStyle.adult, (value) {
                          setState(() {
                            widget.bookingStyle.adult = value;
                          });
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppPickerItem(
                      leading: Icon(
                        Icons.child_friendly_outlined,
                        color: Theme.of(context).hintColor,
                      ),
                      value: widget.bookingStyle.children?.toString(),
                      title: Translate.of(context).translate('children'),
                      onPressed: () {
                        _onPicker(widget.bookingStyle.children, (value) {
                          setState(() {
                            widget.bookingStyle.children = value;
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppPickerItem(
                leading: Icon(
                  Icons.calendar_today_outlined,
                  color: Theme.of(context).hintColor,
                ),
                value: widget.bookingStyle.startDate?.dateView,
                title: Translate.of(context).translate('date'),
                onPressed: _onDatePicker,
              ),
              const SizedBox(height: 16),
              AppPickerItem(
                leading: Icon(
                  Icons.more_time,
                  color: Theme.of(context).hintColor,
                ),
                value: viewHour,
                title: Translate.of(context).translate('hour'),
                onPressed: _onHourPicker,
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Translate.of(context).translate('total'),
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    widget.bookingStyle.price,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
