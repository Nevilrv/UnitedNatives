import 'dart:convert';

HealthResponseModel healthResponseModelFromJson(String str) =>
    HealthResponseModel.fromJson(json.decode(str));

String healthResponseModelToJson(HealthResponseModel data) =>
    json.encode(data.toJson());

class HealthResponseModel {
  HealthResponseModel({
    this.status,
    this.data,
    this.message,
  });

  String? status;
  List<Datum>? data;
  String? message;

  factory HealthResponseModel.fromJson(Map<String, dynamic> json) =>
      HealthResponseModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    this.id,
    this.userId,
    this.reportType,
    this.tableHeaders,
    this.tableData,
    this.modified,
    this.created,
  });

  String? id;
  String? userId;
  String? reportType;
  String? tableHeaders;
  String? tableData;
  DateTime? modified;
  DateTime? created;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        reportType: json["report_type"],
        tableHeaders: json["table_headers"],
        tableData: json["table_data"],
        modified: DateTime.parse(json["modified"]),
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "report_type": reportType,
        "table_headers": tableHeaders,
        "table_data": tableData,
        "modified": modified?.toIso8601String(),
        "created": created?.toIso8601String(),
      };
}
