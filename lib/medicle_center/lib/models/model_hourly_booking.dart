import 'package:doctor_appointment_booking/medicle_center/lib/models/model_booking_style.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/models/model_schedule.dart';

class HourlyBookingModel extends BookingStyleModel {
  DateTime startDate;
  ScheduleModel schedule;
  List<ScheduleModel> hourList;

  HourlyBookingModel({
    price,
    adult,
    children,
    this.startDate,
    this.schedule,
    this.hourList,
  }) : super(price: price, adult: adult, children: children);

  @override
  Map<String, dynamic> get params {
    return {
      'booking_style': 'hourly',
      'adult': adult,
      'children': children,
      'start_date': startDate,
      'start_time': schedule,
      'end_time': schedule,
    };
  }

  factory HourlyBookingModel.fromJson(Map<String, dynamic> json) {
    return HourlyBookingModel(
      price: json['price'] as String,
      startDate: DateTime.tryParse(json['start_date']),
      hourList: List.from(json['select_options'] ?? []).map((e) {
        return ScheduleModel.fromJson(e);
      }).toList(),
    );
  }
}
