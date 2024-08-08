// To parse this JSON data, do
//
//     final myDoctorsListDataResponseModel = myDoctorsListDataResponseModelFromJson(jsonString);

import 'dart:convert';

MyDoctorsListDataResponseModel myDoctorsListDataResponseModelFromJson(
        String str) =>
    MyDoctorsListDataResponseModel.fromJson(json.decode(str));

String myDoctorsListDataResponseModelToJson(
        MyDoctorsListDataResponseModel data) =>
    json.encode(data.toJson());

class MyDoctorsListDataResponseModel {
  String? status;
  List<DoctorData>? data;
  String? message;

  MyDoctorsListDataResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyDoctorsListDataResponseModel.fromJson(Map<String, dynamic> json) =>
      MyDoctorsListDataResponseModel(
        status: json["status"],
        data: List<DoctorData>.from(
            json["data"].map((x) => DoctorData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class DoctorData {
  String? id;
  String? patientId;
  String? doctorName;
  String? doctorNameSlug;
  String? doctorMobile;
  List<Note>? notes;
  DateTime? createdAt;

  DoctorData({
    this.id,
    this.patientId,
    this.doctorName,
    this.doctorNameSlug,
    this.doctorMobile,
    this.notes,
    this.createdAt,
  });

  factory DoctorData.fromJson(Map<String, dynamic> json) => DoctorData(
        id: json["id"],
        patientId: json["patient_id"],
        doctorName: json["doctor_name"],
        doctorNameSlug: json["doctor_name_slug"],
        doctorMobile: json["doctor_mobile"],
        notes: json["notes"] == null
            ? []
            : List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "doctor_name": doctorName,
        "doctor_name_slug": doctorNameSlug,
        "doctor_mobile": doctorMobile,
        "notes": List<Note>.from(notes!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
      };
}

class Note {
  int? id;
  String? note;
  String? createdAt;
  String? updatedAt;

  Note({
    this.id,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        note: json["note"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
