// class PatientAppointmentModel {
//   String status;
//   PatientAppointment patientAppointment;
//   String message;
//
//   PatientAppointmentModel({this.status, this.patientAppointment, this.message});
//
//   PatientAppointmentModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     patientAppointment = json['data'] != null
//         ? new PatientAppointment.fromJson(json['data'])
//         : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.patientAppointment != null) {
//       data['data'] = this.patientAppointment.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class PatientAppointment {
//   List<WeekAvailability> weekAvailability;
//
//   PatientAppointment({this.weekAvailability});
//
//   PatientAppointment.fromJson(Map<String, dynamic> json) {
//     if (json['week_availability'] != null) {
//       weekAvailability = <WeekAvailability>[];
//       json['week_availability'].forEach((v) {
//         weekAvailability.add(new WeekAvailability.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.weekAvailability != null) {
//       data['week_availability'] =
//           this.weekAvailability.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class WeekAvailability {
//   String date;
//   Availability availability;
//   int availableSlotCount;
//   int actualSlotCount;
//
//   WeekAvailability(
//       {this.date,
//       this.availability,
//       this.availableSlotCount,
//       this.actualSlotCount});
//
//   WeekAvailability.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     availability = json['availability'].isNotEmpty ?? true
//         ? new Availability.fromJson(json['availability'])
//         : null;
//     availableSlotCount = json['available_slot_count'];
//     actualSlotCount = json['actualSlotCount'] ?? 0;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     if (this.availability != null) {
//       data['availability'] = this.availability.toJson();
//     }
//     data['available_slot_count'] = this.availableSlotCount;
//     data['actualSlotCount'] = this.actualSlotCount;
//     return data;
//   }
// }
//
// class Availability {
//   String id;
//   String userId;
//   String availDate;
//   String avail0;
//   String avail1;
//   String avail2;
//   String avail3;
//   String avail4;
//   String avail5;
//   String avail6;
//   String avail7;
//   String avail8;
//   String avail9;
//   String avail10;
//   String avail11;
//   String avail12;
//   String avail13;
//   String avail14;
//   String avail15;
//   String avail16;
//   String avail17;
//   String avail18;
//   String avail19;
//   String avail20;
//   String avail21;
//   String avail22;
//   String avail23;
//   String created;
//   String availStatus0;
//   String availStatus1;
//   String availStatus2;
//   String availStatus3;
//   String availStatus4;
//   String availStatus5;
//   String availStatus6;
//   String availStatus7;
//   String availStatus8;
//   String availStatus9;
//   String availStatus10;
//   String availStatus11;
//   String availStatus12;
//   String availStatus13;
//   String availStatus14;
//   String availStatus15;
//   String availStatus16;
//   String availStatus17;
//   String availStatus18;
//   String availStatus19;
//   String availStatus20;
//   String availStatus21;
//   String availStatus22;
//   String availStatus23;
//
//   Availability(
//       {this.id,
//       this.userId,
//       this.availDate,
//       this.avail0,
//       this.avail1,
//       this.avail2,
//       this.avail3,
//       this.avail4,
//       this.avail5,
//       this.avail6,
//       this.avail7,
//       this.avail8,
//       this.avail9,
//       this.avail10,
//       this.avail11,
//       this.avail12,
//       this.avail13,
//       this.avail14,
//       this.avail15,
//       this.avail16,
//       this.avail17,
//       this.avail18,
//       this.avail19,
//       this.avail20,
//       this.avail21,
//       this.avail22,
//       this.avail23,
//       this.availStatus0,
//       this.availStatus1,
//       this.availStatus2,
//       this.availStatus3,
//       this.availStatus4,
//       this.availStatus5,
//       this.availStatus6,
//       this.availStatus7,
//       this.availStatus8,
//       this.availStatus9,
//       this.availStatus10,
//       this.availStatus11,
//       this.availStatus12,
//       this.availStatus13,
//       this.availStatus14,
//       this.availStatus15,
//       this.availStatus16,
//       this.availStatus17,
//       this.availStatus18,
//       this.availStatus19,
//       this.availStatus20,
//       this.availStatus21,
//       this.availStatus22,
//       this.availStatus23,
//       this.created});
//
//   Availability.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     availDate = json['avail_date'];
//     avail0 = json['avail_0'];
//     avail1 = json['avail_1'];
//     avail2 = json['avail_2'];
//     avail3 = json['avail_3'];
//     avail4 = json['avail_4'];
//     avail5 = json['avail_5'];
//     avail6 = json['avail_6'];
//     avail7 = json['avail_7'];
//     avail8 = json['avail_8'];
//     avail9 = json['avail_9'];
//     avail10 = json['avail_10'];
//     avail11 = json['avail_11'];
//     avail12 = json['avail_12'];
//     avail13 = json['avail_13'];
//     avail14 = json['avail_14'];
//     avail15 = json['avail_15'];
//     avail16 = json['avail_16'];
//     avail17 = json['avail_17'];
//     avail18 = json['avail_18'];
//     avail19 = json['avail_19'];
//     avail20 = json['avail_20'];
//     avail21 = json['avail_21'];
//     avail22 = json['avail_22'];
//     avail23 = json['avail_23'];
//     availStatus0 = json['avail_0_status'];
//     availStatus1 = json['avail_1_status'];
//     availStatus2 = json['avail_2_status'];
//     availStatus3 = json['avail_3_status'];
//     availStatus4 = json['avail_4_status'];
//     availStatus5 = json['avail_5_status'];
//     availStatus6 = json['avail_6_status'];
//     availStatus7 = json['avail_7_status'];
//     availStatus8 = json['avail_8_status'];
//     availStatus9 = json['avail_9_status'];
//     availStatus10 = json['avail_10_status'];
//     availStatus11 = json['avail_11_status'];
//     availStatus12 = json['avail_12_status'];
//     availStatus13 = json['avail_13_status'];
//     availStatus14 = json['avail_14_status'];
//     availStatus15 = json['avail_15_status'];
//     availStatus16 = json['avail_16_status'];
//     availStatus17 = json['avail_17_status'];
//     availStatus18 = json['avail_18_status'];
//     availStatus19 = json['avail_19_status'];
//     availStatus20 = json['avail_20_status'];
//     availStatus21 = json['avail_21_status'];
//     availStatus22 = json['avail_22_status'];
//     availStatus23 = json['avail_23_status'];
//     created = json['created'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['avail_date'] = this.availDate;
//     data['avail_0'] = this.avail0;
//     data['avail_1'] = this.avail1;
//     data['avail_2'] = this.avail2;
//     data['avail_3'] = this.avail3;
//     data['avail_4'] = this.avail4;
//     data['avail_5'] = this.avail5;
//     data['avail_6'] = this.avail6;
//     data['avail_7'] = this.avail7;
//     data['avail_8'] = this.avail8;
//     data['avail_9'] = this.avail9;
//     data['avail_10'] = this.avail10;
//     data['avail_11'] = this.avail11;
//     data['avail_12'] = this.avail12;
//     data['avail_13'] = this.avail13;
//     data['avail_14'] = this.avail14;
//     data['avail_15'] = this.avail15;
//     data['avail_16'] = this.avail16;
//     data['avail_17'] = this.avail17;
//     data['avail_18'] = this.avail18;
//     data['avail_19'] = this.avail19;
//     data['avail_20'] = this.avail20;
//     data['avail_21'] = this.avail21;
//     data['avail_22'] = this.avail22;
//     data['avail_23'] = this.avail23;
//     data['avail_0_status'] = this.availStatus0;
//     data['avail_1_status'] = this.availStatus1;
//     data['avail_2_status'] = this.availStatus2;
//     data['avail_3_status'] = this.availStatus3;
//     data['avail_4_status'] = this.availStatus4;
//     data['avail_5_status'] = this.availStatus5;
//     data['avail_6_status'] = this.availStatus6;
//     data['avail_7_status'] = this.availStatus7;
//     data['avail_8_status'] = this.availStatus8;
//     data['avail_9_status'] = this.availStatus9;
//     data['avail_10_status'] = this.availStatus10;
//     data['avail_11_status'] = this.availStatus11;
//     data['avail_12_status'] = this.availStatus12;
//     data['avail_13_status'] = this.availStatus13;
//     data['avail_14_status'] = this.availStatus14;
//     data['avail_15_status'] = this.availStatus15;
//     data['avail_16_status'] = this.availStatus16;
//     data['avail_17_status'] = this.availStatus17;
//     data['avail_18_status'] = this.availStatus18;
//     data['avail_19_status'] = this.availStatus19;
//     data['avail_20_status'] = this.availStatus20;
//     data['avail_21_status'] = this.availStatus21;
//     data['avail_22_status'] = this.availStatus22;
//     data['avail_23_status'] = this.availStatus23;
//     data['created'] = this.created;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final patientAppointmentModel = patientAppointmentModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final patientAppointmentModel = patientAppointmentModelFromJson(jsonString);

import 'dart:convert';

PatientAppointmentModel patientAppointmentModelFromJson(String str) =>
    PatientAppointmentModel.fromJson(json.decode(str));

String patientAppointmentModelToJson(PatientAppointmentModel data) =>
    json.encode(data.toJson());

class PatientAppointmentModel {
  String status;
  SlotData data;
  String message;

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
        "data": data.toJson(),
        "message": message,
      };
}

class SlotData {
  List<WeekAvailability> weekAvailability;

  SlotData({
    this.weekAvailability,
  });

  factory SlotData.fromJson(Map<String, dynamic> json) => SlotData(
        weekAvailability: List<WeekAvailability>.from(
            json["week_availability"].map((x) => WeekAvailability.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "week_availability":
            List<dynamic>.from(weekAvailability.map((x) => x.toJson())),
      };
}

class WeekAvailability {
  DateTime date;
  Availability availability;
  int availableSlotCount;
  int actualSlotCount;

  WeekAvailability({
    this.date,
    this.availability,
    this.availableSlotCount,
    this.actualSlotCount,
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
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "availability": availability.toJson(),
        "available_slot_count": availableSlotCount,
        "actualSlotCount": actualSlotCount,
      };
}

class Availability {
  String userId;
  DateTime availDate;
  List<AvailData> availData;

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
            "${availDate.year.toString().padLeft(4, '0')}-${availDate.month.toString().padLeft(2, '0')}-${availDate.day.toString().padLeft(2, '0')}",
        "avail_data": List<dynamic>.from(availData.map((x) => x.toJson())),
      };
}

class AvailData {
  DateTime startTime;
  DateTime endTime;
  String avail;
  String status;

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
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "avail": avail,
        "status": status,
      };
}
