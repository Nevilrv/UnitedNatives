// To parse this JSON data, do
//
//     final addVideoConferenceResponseModel = addVideoConferenceResponseModelFromJson(jsonString);

import 'dart:convert';

AddVideoConferenceResponseModel addVideoConferenceResponseModelFromJson(
        String str) =>
    AddVideoConferenceResponseModel.fromJson(json.decode(str));

String addVideoConferenceResponseModelToJson(
        AddVideoConferenceResponseModel data) =>
    json.encode(data.toJson());

class AddVideoConferenceResponseModel {
  String status;
  bool data;
  String message;

  AddVideoConferenceResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory AddVideoConferenceResponseModel.fromJson(Map<String, dynamic> json) =>
      AddVideoConferenceResponseModel(
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
