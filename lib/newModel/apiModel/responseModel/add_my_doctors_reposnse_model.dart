// To parse this JSON data, do
//
//     final addMyDoctorsResponseModel = addMyDoctorsResponseModelFromJson(jsonString);

import 'dart:convert';

AddMyDoctorsResponseModel addMyDoctorsResponseModelFromJson(String str) =>
    AddMyDoctorsResponseModel.fromJson(json.decode(str));

String addMyDoctorsResponseModelToJson(AddMyDoctorsResponseModel data) =>
    json.encode(data.toJson());

class AddMyDoctorsResponseModel {
  String status;
  bool data;
  String message;

  AddMyDoctorsResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory AddMyDoctorsResponseModel.fromJson(Map<String, dynamic> json) =>
      AddMyDoctorsResponseModel(
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
