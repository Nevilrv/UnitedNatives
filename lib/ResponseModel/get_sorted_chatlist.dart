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

  int? chatId;
  String? fromType;
  int? fromId;
  String? toType;
  int? toId;
  String? message;
  String? attachment;
  int? chatKey;
  DateTime? chatDatetime;
  int? doctorId;
  String? doctorFirstName;
  String? doctorLastName;
  String? lastMessage;

  factory GetSortedChatList.fromJson(Map<String, dynamic> json) =>
      GetSortedChatList(
        chatId: json["chat_id"],
        fromType: json["from_type"],
        fromId: json["from_id"],
        toType: json["to_type"],
        toId: json["to_id"],
        message: json["message"],
        attachment: json["attachment"],
        chatKey: json["chat_key"],
        chatDatetime: json["chat_datetime"],
        doctorId: json["doctor_id"],
        doctorFirstName: json["doctor_first_name"],
        doctorLastName: json["doctor_last_name"],
        lastMessage: json["last_message"],
      );

  Map<String, dynamic> toJson() => {
        "chat_id": chatId,
        "from_type": fromType,
        "from_id": fromId,
        "to_type": toType,
        "to_id": toId,
        "message": message,
        "attachment": attachment,
        "chat_key": chatKey,
        "chat_datetime": chatDatetime,
        "doctor_id": doctorId,
        "doctor_first_name": doctorFirstName,
        "doctor_last_name": doctorLastName,
        "last_message": lastMessage,
      };
}
