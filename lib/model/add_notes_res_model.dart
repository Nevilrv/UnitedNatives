import 'dart:convert';

AddNotesModel addNotesModelFromJson(String str) =>
    AddNotesModel.fromJson(json.decode(str));

String addNotesModelToJson(AddNotesModel data) => json.encode(data.toJson());

class AddNotesModel {
  AddNotesModel({
    this.status,
    this.message,
  });

  String? status;
  String? message;

  factory AddNotesModel.fromJson(Map<String, dynamic> json) => AddNotesModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
