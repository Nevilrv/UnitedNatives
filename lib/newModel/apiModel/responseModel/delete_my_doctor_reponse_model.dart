// To parse this JSON data, do
//
//     final deleteMyDoctorResponseModel = deleteMyDoctorResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteMyDoctorResponseModel deleteMyDoctorResponseModelFromJson(String str) =>
    DeleteMyDoctorResponseModel.fromJson(json.decode(str));

String deleteMyDoctorResponseModelToJson(DeleteMyDoctorResponseModel data) =>
    json.encode(data.toJson());

class DeleteMyDoctorResponseModel {
  String status;
  bool data;
  String message;

  DeleteMyDoctorResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory DeleteMyDoctorResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteMyDoctorResponseModel(
        status: json["status"],
        data: json["data"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
        "message": message,
      };
}
