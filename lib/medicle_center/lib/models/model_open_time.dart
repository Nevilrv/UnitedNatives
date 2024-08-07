import 'package:doctor_appointment_booking/medicle_center/lib/models/model_schedule.dart';

class OpenTimeModel {
  final int dayOfWeek;
  final String key;
  final List<ScheduleModel> schedule;

  OpenTimeModel({
    this.dayOfWeek,
    this.key,
    this.schedule,
  });

  factory OpenTimeModel.fromJson(Map<String, dynamic> json) {
    return OpenTimeModel(
      dayOfWeek: json['day_of_week'] ?? 1,
      key: json['key'] ?? "mon",
      schedule: List.from(json['schedule'] ?? []).map((e) {
        return ScheduleModel.fromJson(e);
      }).toList(),
    );
  }
}
