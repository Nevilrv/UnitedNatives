// To parse this JSON data, do
//
//     final deleteNotesResponseModel = deleteNotesResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteNotesResponseModel deleteNotesResponseModelFromJson(String str) =>
    DeleteNotesResponseModel.fromJson(json.decode(str));

String deleteNotesResponseModelToJson(DeleteNotesResponseModel data) =>
    json.encode(data.toJson());

class DeleteNotesResponseModel {
  String? status;
  bool? data;
  String? message;

  DeleteNotesResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory DeleteNotesResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteNotesResponseModel(
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
