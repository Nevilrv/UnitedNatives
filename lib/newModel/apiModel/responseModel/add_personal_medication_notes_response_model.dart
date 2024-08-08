import 'dart:convert';

AddPersonalMedicationNotesResponseModel
    addPersonalMedicationNotesResponseModelFromJson(String str) =>
        AddPersonalMedicationNotesResponseModel.fromJson(json.decode(str));

String addPersonalMedicationNotesResponseModelToJson(
        AddPersonalMedicationNotesResponseModel data) =>
    json.encode(data.toJson());

class AddPersonalMedicationNotesResponseModel {
  String? status;
  bool? data;
  String? message;

  AddPersonalMedicationNotesResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory AddPersonalMedicationNotesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      AddPersonalMedicationNotesResponseModel(
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
