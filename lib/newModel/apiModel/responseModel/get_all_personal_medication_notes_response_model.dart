// To parse this JSON data, do
//
//     final getAllPersonalMedicationNotesResponseModel = getAllPersonalMedicationNotesResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllPersonalMedicationNotesResponseModel
    getAllPersonalMedicationNotesResponseModelFromJson(String str) =>
        GetAllPersonalMedicationNotesResponseModel.fromJson(json.decode(str));

String getAllPersonalMedicationNotesResponseModelToJson(
        GetAllPersonalMedicationNotesResponseModel data) =>
    json.encode(data.toJson());

class GetAllPersonalMedicationNotesResponseModel {
  String? status;
  List<PersonalMedicationNotesItemData>? data;
  String? message;

  GetAllPersonalMedicationNotesResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory GetAllPersonalMedicationNotesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllPersonalMedicationNotesResponseModel(
        status: json["status"],
        data: List<PersonalMedicationNotesItemData>.from(json["data"]
            .map((x) => PersonalMedicationNotesItemData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class PersonalMedicationNotesItemData {
  String? id;
  String? patientId;
  String? title;
  String? notes;
  DateTime? datetime;
  DateTime? createdAt;

  PersonalMedicationNotesItemData({
    this.id,
    this.patientId,
    this.title,
    this.notes,
    this.datetime,
    this.createdAt,
  });

  factory PersonalMedicationNotesItemData.fromJson(Map<String, dynamic> json) =>
      PersonalMedicationNotesItemData(
        id: json["id"],
        patientId: json["patient_id"],
        title: json["title"],
        notes: json["notes"],
        datetime: json["datetime"] == null
            ? null
            : DateTime.tryParse(json["datetime"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "title": title,
        "notes": notes,
        "datetime": datetime,
        "created_at": createdAt?.toIso8601String(),
      };
}
