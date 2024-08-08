import 'dart:convert';

GetAllNotesModel getAllNotesModelFromJson(String str) =>
    GetAllNotesModel.fromJson(json.decode(str));

String getAllNotesModelToJson(GetAllNotesModel data) =>
    json.encode(data.toJson());

class GetAllNotesModel {
  GetAllNotesModel({
    this.status,
    this.data,
    this.message,
  });

  String? status;
  List<Datum>? data;
  String? message;

  factory GetAllNotesModel.fromJson(Map<String, dynamic> json) =>
      GetAllNotesModel(
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
    this.patientId,
    this.doctorId,
    this.notes,
    this.modified,
    this.created,
  });

  String? id;
  String? patientId;
  String? doctorId;
  String? notes;
  DateTime? modified;
  DateTime? created;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        patientId: json["patient_id"],
        doctorId: json["doctor_id"],
        notes: json["notes"],
        modified: DateTime.parse(json["modified"]),
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "doctor_id": doctorId,
        "notes": notes,
        "modified": modified?.toIso8601String(),
        "created": created?.toIso8601String(),
      };
}
