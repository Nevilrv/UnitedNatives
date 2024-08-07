// To parse this JSON data, do
//
//     final getAllSubCategories = getAllSubCategoriesFromJson(jsonString);

import 'dart:convert';

List<GetSortedChatList> getSortedChatListFromJson(String str) =>
    List<GetSortedChatList>.from(
        json.decode(str).map((x) => GetSortedChatList.fromJson(x)));

String getSortedChatListToJson(List<GetSortedChatList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSortedChatList {
  GetSortedChatList({
    this.chatId,
    this.fromType,
    this.fromId,
    this.toType,
    this.toId,
    this.message,
    this.attachment,
    this.chatKey,
    this.chatDatetime,
    this.doctorId,
    this.doctorFirstName,
    this.doctorLastName,
    this.lastMessage,
  });

  int chatId;
  String fromType;
  int fromId;
  String toType;
  int toId;
  String message;
  String attachment;
  int chatKey;
  DateTime chatDatetime;
  int doctorId;
  String doctorFirstName;
  String doctorLastName;
  String lastMessage;

  factory GetSortedChatList.fromJson(Map<String, dynamic> json) =>
      GetSortedChatList(
        chatId: json["chat_id"] == null ? null : json["chat_id"],
        fromType: json["from_type"] == null ? null : json["from_type"],
        fromId: json["from_id"] == null ? null : json["from_id"],
        toType: json["to_type"] == null ? null : json["to_type"],
        toId: json["to_id"] == null ? null : json["to_id"],
        message: json["message"] == null ? null : json["message"],
        attachment: json["attachment"] == null ? null : json["attachment"],
        chatKey: json["chat_key"] == null ? null : json["chat_key"],
        chatDatetime:
            json["chat_datetime"] == null ? null : json["chat_datetime"],
        doctorId: json["doctor_id"] == null ? null : json["doctor_id"],
        doctorFirstName: json["doctor_first_name"] == null
            ? null
            : json["doctor_first_name"],
        doctorLastName:
            json["doctor_last_name"] == null ? null : json["doctor_last_name"],
        lastMessage: json["last_message"] == null ? null : json["last_message"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId == null ? null : chatId,
        "from_type": fromType == null ? null : fromType,
        "from_id": fromId == null ? null : fromId,
        "to_type": toType == null ? null : toType,
        "to_id": toId == null ? null : toId,
        "message": message == null ? null : message,
        "attachment": attachment == null ? null : attachment,
        "chat_key": chatKey == null ? null : chatKey,
        "chat_datetime": chatDatetime == null ? null : chatDatetime,
        "doctor_id": doctorId == null ? null : doctorId,
        "doctor_first_name": doctorFirstName == null ? null : doctorFirstName,
        "doctor_last_name": doctorLastName == null ? null : doctorLastName,
        "last_message": lastMessage == null ? null : lastMessage,
      };
}
