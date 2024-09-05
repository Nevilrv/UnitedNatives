// To parse this JSON data, do
//
//     final patientGetAppointmentRatingModel = patientGetAppointmentRatingModelFromJson(jsonString);

import 'dart:convert';

PatientGetAppointmentRatingModel patientGetAppointmentRatingModelFromJson(
        String str) =>
    PatientGetAppointmentRatingModel.fromJson(json.decode(str));

String patientGetAppointmentRatingModelToJson(
        PatientGetAppointmentRatingModel data) =>
    json.encode(data.toJson());

class PatientGetAppointmentRatingModel {
  PatientGetAppointmentRatingModel({
    this.status,
    this.data,
  });

  String? status;
  Data? data;

  factory PatientGetAppointmentRatingModel.fromJson(
          Map<String, dynamic> json) =>
      PatientGetAppointmentRatingModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.patientId,
    this.doctorId,
    this.appointmentId,
    this.rating,
    this.review,
    this.created,
  });

  String? id;
  String? patientId;
  String? doctorId;
  String? appointmentId;
  String? rating;
  dynamic review;
  DateTime? created;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        patientId: json["patient_id"],
        doctorId: json["doctor_id"],
        appointmentId: json["appointment_id"],
        rating: json["rating"],
        review: json["review"],
        created: DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "doctor_id": doctorId,
        "appointment_id": appointmentId,
        "rating": rating,
        "review": review,
        "created": created?.toIso8601String(),
      };
}
