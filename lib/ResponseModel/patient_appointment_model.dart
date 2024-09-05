import 'dart:convert';

PatientAppointmentModel patientAppointmentModelFromJson(String str) =>
    PatientAppointmentModel.fromJson(json.decode(str));

String patientAppointmentModelToJson(PatientAppointmentModel data) =>
    json.encode(data.toJson());

class PatientAppointmentModel {
  String? status;
  SlotData? data;
  String? message;

  PatientAppointmentModel({
    this.status,
    this.data,
    this.message,
  });

  factory PatientAppointmentModel.fromJson(Map<String, dynamic> json) =>
      PatientAppointmentModel(
        status: json["status"],
        data: SlotData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class SlotData {
  List<WeekAvailability>? weekAvailability;

  SlotData({
    this.weekAvailability,
  });

  factory SlotData.fromJson(Map<String, dynamic> json) => SlotData(
        weekAvailability: List<WeekAvailability>.from(
            json["week_availability"].map((x) => WeekAvailability.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "week_availability":
            List<dynamic>.from(weekAvailability!.map((x) => x.toJson())),
      };
}

class WeekAvailability {
  DateTime? date;
  Availability? availability;
  int? availableSlotCount;
  int actualSlotCount;

  WeekAvailability({
    this.date,
    this.availability,
    this.availableSlotCount,
    required this.actualSlotCount,
  });

  factory WeekAvailability.fromJson(Map<String, dynamic> json) =>
      WeekAvailability(
        date: DateTime.parse(json["date"]),
        availability: json["availability"] == null ||
                json["availability"] == [] ||
                json["availability"].isEmpty
            ? null
            : Availability.fromJson(json["availability"]),
        availableSlotCount: json["available_slot_count"],
        actualSlotCount: json["actualSlotCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "availability": availability?.toJson(),
        "available_slot_count": availableSlotCount,
        "actualSlotCount": actualSlotCount,
      };
}

class Availability {
  String? userId;
  DateTime? availDate;
  List<AvailData>? availData;

  Availability({
    this.userId,
    this.availDate,
    this.availData,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        userId: json["user_id"],
        availDate: DateTime.parse(json["avail_date"]),
        availData: json["avail_data"] == null
            ? null
            : List<AvailData>.from(
                json["avail_data"].map((x) => AvailData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "avail_date":
            "${availDate?.year.toString().padLeft(4, '0')}-${availDate?.month.toString().padLeft(2, '0')}-${availDate?.day.toString().padLeft(2, '0')}",
        "avail_data": List<dynamic>.from(availData!.map((x) => x.toJson())),
      };
}

class AvailData {
  DateTime? startTime;
  DateTime? endTime;
  String? avail;
  String? status;

  AvailData({
    this.startTime,
    this.endTime,
    this.avail,
    this.status,
  });

  factory AvailData.fromJson(Map<String, dynamic> json) => AvailData(
        startTime: DateTime.parse(json["start_time"].toString().trim()),
        endTime: DateTime.parse(json["end_time"].toString().trim()),
        avail: json["avail"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "avail": avail,
        "status": status,
      };
}
