// To parse this JSON data, do
//
//     final deleteChatMessageResponseModel = deleteChatMessageResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteChatMessageResponseModel deleteChatMessageResponseModelFromJson(
        String str) =>
    DeleteChatMessageResponseModel.fromJson(json.decode(str));

String deleteChatMessageResponseModelToJson(
        DeleteChatMessageResponseModel data) =>
    json.encode(data.toJson());

class DeleteChatMessageResponseModel {
  String status;
  Data data;

  DeleteChatMessageResponseModel({
    this.status,
    this.data,
  });

  factory DeleteChatMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteChatMessageResponseModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  String status;
  String message;

  Data({
    this.status,
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
