import 'dart:convert';

UpdatePersonalMedicationNotesResponseModel
    updatePersonalMedicationNotesResponseModelFromJson(String str) =>
        UpdatePersonalMedicationNotesResponseModel.fromJson(json.decode(str));

String updatePersonalMedicationNotesResponseModelToJson(
        UpdatePersonalMedicationNotesResponseModel data) =>
    json.encode(data.toJson());

class UpdatePersonalMedicationNotesResponseModel {
  String status;
  bool data;
  String message;

  UpdatePersonalMedicationNotesResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory UpdatePersonalMedicationNotesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UpdatePersonalMedicationNotesResponseModel(
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
