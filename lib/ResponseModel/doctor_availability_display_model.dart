import 'dart:convert';

DoctorAvailabilityForDisplayOnlyModel
    doctorAvailabilityForDisplayOnlyModelFromJson(String str) =>
        DoctorAvailabilityForDisplayOnlyModel.fromJson(json.decode(str));

String doctorAvailabilityForDisplayOnlyModelToJson(
        DoctorAvailabilityForDisplayOnlyModel data) =>
    json.encode(data.toJson());

class DoctorAvailabilityForDisplayOnlyModel {
  String? status;
  Data? data;
  String? message;

  DoctorAvailabilityForDisplayOnlyModel({
    this.status,
    this.data,
    this.message,
  });

  factory DoctorAvailabilityForDisplayOnlyModel.fromJson(
          Map<String, dynamic> json) =>
      DoctorAvailabilityForDisplayOnlyModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  List<WeeklyAvailability>? weeklyAvailability;
  PostedDateAvailabilityClass? postedDateAvailability;

  Data({
    this.weeklyAvailability,
    this.postedDateAvailability,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        weeklyAvailability: List<WeeklyAvailability>.from(
            json["weekly_availability"]
                .map((x) => WeeklyAvailability.fromJson(x))),
        postedDateAvailability: json["posted_date_availability"] == null ||
                json["posted_date_availability"] == [] ||
                json["posted_date_availability"].isEmpty
            ? null
            : PostedDateAvailabilityClass.fromJson(
                json["posted_date_availability"]),
      );

  Map<String, dynamic> toJson() => {
        "weekly_availability":
            List<dynamic>.from(weeklyAvailability!.map((x) => x.toJson())),
        "posted_date_availability": postedDateAvailability?.toJson(),
      };
}

class PostedDateAvailabilityClass {
  String? userId;
  DateTime? availDate;
  List<AvailData>? availData;

  PostedDateAvailabilityClass({
    this.userId,
    this.availDate,
    this.availData,
  });

  factory PostedDateAvailabilityClass.fromJson(Map<String, dynamic> json) =>
      PostedDateAvailabilityClass(
        userId: json["user_id"],
        availDate: DateTime.parse(json["avail_date"]),
        availData: json["avail_data"] == null ||
                json["avail_data"] == [] ||
                json["avail_data"].isEmpty
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

  AvailData({
    this.startTime,
    this.endTime,
    this.avail,
  });

  factory AvailData.fromJson(Map<String, dynamic> json) {
    return AvailData(
      startTime: DateTime.parse(json["start_time"].toString().trim()),
      endTime: DateTime.parse(json["end_time"].toString().trim()),
      avail: json["avail"],
    );
  }

  Map<String, dynamic> toJson() => {
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "avail": avail,
      };
}

class WeeklyAvailability {
  DateTime? date;
  PostedDateAvailabilityClass? availability;
  int? availableSlotCount;

  WeeklyAvailability({
    this.date,
    this.availability,
    this.availableSlotCount,
  });

  factory WeeklyAvailability.fromJson(Map<String, dynamic> json) =>
      WeeklyAvailability(
        date: DateTime.parse(json["date"]),
        availability: json["availability"] == null ||
                json["availability"] == [] ||
                json["availability"].isEmpty
            ? null
            : PostedDateAvailabilityClass.fromJson(json["availability"]),
        availableSlotCount: json["available_slot_count"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "availability": availability?.toJson(),
        "available_slot_count": availableSlotCount,
      };
}
