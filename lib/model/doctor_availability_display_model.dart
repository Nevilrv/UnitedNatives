// class DoctorAvailabilityForDisplayOnlyModel {
//   String status;
//   DoctorAvailabilityDisplayData doctorAvailabilityDisplayData;
//   String message;
//
//   DoctorAvailabilityForDisplayOnlyModel(
//       {this.status, this.doctorAvailabilityDisplayData, this.message});
//
//   DoctorAvailabilityForDisplayOnlyModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     doctorAvailabilityDisplayData = json['data'] != null ? new DoctorAvailabilityDisplayData.fromJson(json['data']) : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.doctorAvailabilityDisplayData != null) {
//       data['data'] = this.doctorAvailabilityDisplayData.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class DoctorAvailabilityDisplayData {
//   List<WeeklyAvailability> weeklyAvailability;
//   Availability postedDateAvailability;
//
//   DoctorAvailabilityDisplayData({this.weeklyAvailability, this.postedDateAvailability});
//
//   DoctorAvailabilityDisplayData.fromJson(Map<String, dynamic> json) {
//     if (json['weekly_availability'] != null) {
//       weeklyAvailability = new List<WeeklyAvailability>();
//       json['weekly_availability'].forEach((v) {
//         weeklyAvailability.add(new WeeklyAvailability.fromJson(v));
//       });
//     }
//     postedDateAvailability = json['posted_date_availability'] != null
//         ? new Availability.fromJson(json['posted_date_availability'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.weeklyAvailability != null) {
//       data['weekly_availability'] =
//           this.weeklyAvailability.map((v) => v.toJson()).toList();
//     }
//     if (this.postedDateAvailability != null) {
//       data['posted_date_availability'] = this.postedDateAvailability.toJson();
//     }
//     return data;
//   }
// }
//
// class WeeklyAvailability {
//   String date;
//   Availability availability;
//   int availableSlotCount;
//
//   WeeklyAvailability({this.date, this.availability, this.availableSlotCount});
//
//   WeeklyAvailability.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     availability = json['availability'] != null
//         ? new Availability.fromJson(json['availability'])
//         : null;
//     availableSlotCount = json['available_slot_count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     if (this.availability != null) {
//       data['availability'] = this.availability.toJson();
//     }
//     data['available_slot_count'] = this.availableSlotCount;
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
//
//   Availability(
//       {this.id,
//         this.userId,
//         this.availDate,
//         this.avail0,
//         this.avail1,
//         this.avail2,
//         this.avail3,
//         this.avail4,
//         this.avail5,
//         this.avail6,
//         this.avail7,
//         this.avail8,
//         this.avail9,
//         this.avail10,
//         this.avail11,
//         this.avail12,
//         this.avail13,
//         this.avail14,
//         this.avail15,
//         this.avail16,
//         this.avail17,
//         this.avail18,
//         this.avail19,
//         this.avail20,
//         this.avail21,
//         this.avail22,
//         this.avail23,
//         this.created});
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
//     data['created'] = this.created;
//     return data;
//   }
// }
// To parse this JSON data, do
//
//     final doctorAvailabilityForDisplayOnlyModel = doctorAvailabilityForDisplayOnlyModelFromJson(jsonString);

/// =========== NEW ===

/*import 'dart:convert';

DoctorAvailabilityForDisplayOnlyModel
    doctorAvailabilityForDisplayOnlyModelFromJson(String str) =>
        DoctorAvailabilityForDisplayOnlyModel.fromJson(json.decode(str));

String doctorAvailabilityForDisplayOnlyModelToJson(
        DoctorAvailabilityForDisplayOnlyModel data) =>
    json.encode(data.toJson());

class DoctorAvailabilityForDisplayOnlyModel {
  DoctorAvailabilityForDisplayOnlyModel({
    this.status,
    this.data,
    this.message,
  });

  String status;
  Data data;
  String message;

  factory DoctorAvailabilityForDisplayOnlyModel.fromJson(
          Map<String, dynamic> json) =>
      DoctorAvailabilityForDisplayOnlyModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.weeklyAvailability,
    this.postedDateAvailability,
  });

  List<WeeklyAvailability> weeklyAvailability;
  PostedDateAvailabilityClass postedDateAvailability;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        weeklyAvailability: List<WeeklyAvailability>.from(
            json["weekly_availability"]
                .map((x) => WeeklyAvailability.fromJson(x))),
        postedDateAvailability: json["posted_date_availability"] == null
            ? null
            : PostedDateAvailabilityClass.fromJson(
                json["posted_date_availability"]),
      );

  Map<String, dynamic> toJson() => {
        "weekly_availability":
            List<dynamic>.from(weeklyAvailability.map((x) => x.toJson())),
        "posted_date_availability": postedDateAvailability.toJson(),
      };
}

class PostedDateAvailabilityClass {
  PostedDateAvailabilityClass({
    this.id,
    this.userId,
    this.availDate,
    this.avail0,
    this.avail1,
    this.avail2,
    this.avail3,
    this.avail4,
    this.avail5,
    this.avail6,
    this.avail7,
    this.avail8,
    this.avail9,
    this.avail10,
    this.avail11,
    this.avail12,
    this.avail13,
    this.avail14,
    this.avail15,
    this.avail16,
    this.avail17,
    this.avail18,
    this.avail19,
    this.avail20,
    this.avail21,
    this.avail22,
    this.avail23,
    this.created,
  });

  String id;
  String userId;
  DateTime availDate;
  String avail0;
  String avail1;
  String avail2;
  String avail3;
  String avail4;
  String avail5;
  String avail6;
  String avail7;
  String avail8;
  String avail9;
  String avail10;
  String avail11;
  String avail12;
  String avail13;
  String avail14;
  String avail15;
  String avail16;
  String avail17;
  String avail18;
  String avail19;
  String avail20;
  String avail21;
  String avail22;
  String avail23;
  DateTime created;

  factory PostedDateAvailabilityClass.fromJson(Map<String, dynamic> json) =>
      PostedDateAvailabilityClass(
        id: json["id"],
        userId: json["user_id"],
        availDate: json["avail_date"] == null
            ? null
            : DateTime.parse(json["avail_date"]),
        avail0: json["avail_0"],
        avail1: json["avail_1"],
        avail2: json["avail_2"],
        avail3: json["avail_3"],
        avail4: json["avail_4"],
        avail5: json["avail_5"],
        avail6: json["avail_6"],
        avail7: json["avail_7"],
        avail8: json["avail_8"],
        avail9: json["avail_9"],
        avail10: json["avail_10"],
        avail11: json["avail_11"],
        avail12: json["avail_12"],
        avail13: json["avail_13"],
        avail14: json["avail_14"],
        avail15: json["avail_15"],
        avail16: json["avail_16"],
        avail17: json["avail_17"],
        avail18: json["avail_18"],
        avail19: json["avail_19"],
        avail20: json["avail_20"],
        avail21: json["avail_21"],
        avail22: json["avail_22"],
        avail23: json["avail_23"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "avail_date":
            "${availDate.year.toString().padLeft(4, '0')}-${availDate.month.toString().padLeft(2, '0')}-${availDate.day.toString().padLeft(2, '0')}",
        "avail_0": avail0,
        "avail_1": avail1,
        "avail_2": avail2,
        "avail_3": avail3,
        "avail_4": avail4,
        "avail_5": avail5,
        "avail_6": avail6,
        "avail_7": avail7,
        "avail_8": avail8,
        "avail_9": avail9,
        "avail_10": avail10,
        "avail_11": avail11,
        "avail_12": avail12,
        "avail_13": avail13,
        "avail_14": avail14,
        "avail_15": avail15,
        "avail_16": avail16,
        "avail_17": avail17,
        "avail_18": avail18,
        "avail_19": avail19,
        "avail_20": avail20,
        "avail_21": avail21,
        "avail_22": avail22,
        "avail_23": avail23,
        "created": created.toIso8601String(),
      };
}

class WeeklyAvailability {
  WeeklyAvailability({
    this.date,
    this.availability,
    this.availableSlotCount,
  });

  DateTime date;
  dynamic availability;
  int availableSlotCount;

  factory WeeklyAvailability.fromJson(Map<String, dynamic> json) =>
      WeeklyAvailability(
        date: DateTime.parse(json["date"]),
        availability: json["availability"],
        availableSlotCount: json["available_slot_count"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "availability": availability,
        "available_slot_count": availableSlotCount,
      };
}*/

// To parse this JSON data, do
//
//     final doctorAvailabilityForDisplayOnlyModel = doctorAvailabilityForDisplayOnlyModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final doctorAvailabilityForDisplayOnlyModel = doctorAvailabilityForDisplayOnlyModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final doctorAvailabilityForDisplayOnlyModel = doctorAvailabilityForDisplayOnlyModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final doctorAvailabilityForDisplayOnlyModel = doctorAvailabilityForDisplayOnlyModelFromJson(jsonString);

import 'dart:convert';

DoctorAvailabilityForDisplayOnlyModel
    doctorAvailabilityForDisplayOnlyModelFromJson(String str) =>
        DoctorAvailabilityForDisplayOnlyModel.fromJson(json.decode(str));

String doctorAvailabilityForDisplayOnlyModelToJson(
        DoctorAvailabilityForDisplayOnlyModel data) =>
    json.encode(data.toJson());

class DoctorAvailabilityForDisplayOnlyModel {
  String status;
  Data data;
  String message;

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
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  List<WeeklyAvailability> weeklyAvailability;
  PostedDateAvailabilityClass postedDateAvailability;

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
            List<dynamic>.from(weeklyAvailability.map((x) => x.toJson())),
        "posted_date_availability": postedDateAvailability.toJson(),
      };
}

class PostedDateAvailabilityClass {
  String userId;
  DateTime availDate;
  List<AvailData> availData;

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
            "${availDate.year.toString().padLeft(4, '0')}-${availDate.month.toString().padLeft(2, '0')}-${availDate.day.toString().padLeft(2, '0')}",
        "avail_data": List<dynamic>.from(availData.map((x) => x.toJson())),
      };
}

class AvailData {
  DateTime startTime;
  DateTime endTime;
  String avail;

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
        "start_time": startTime.toIso8601String(),
        "end_time": endTime.toIso8601String(),
        "avail": avail,
      };
}

class WeeklyAvailability {
  DateTime date;
  PostedDateAvailabilityClass availability;
  int availableSlotCount;

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
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "availability": availability.toJson(),
        "available_slot_count": availableSlotCount,
      };
}
