// To parse this JSON data, do
//
//     final messageStatusResponseModel = messageStatusResponseModelFromJson(jsonString);

import 'dart:convert';

MessageStatusResponseModel messageStatusResponseModelFromJson(String str) =>
    MessageStatusResponseModel.fromJson(json.decode(str));

String messageStatusResponseModelToJson(MessageStatusResponseModel data) =>
    json.encode(data.toJson());

class MessageStatusResponseModel {
  MessageStatusResponseModel({
    this.status,
    this.message,
  });

  String? status;
  String? message;

  factory MessageStatusResponseModel.fromJson(Map<String, dynamic> json) =>
      MessageStatusResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
