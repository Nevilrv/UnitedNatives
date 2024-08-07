import 'dart:convert';

DeletePersonalMedicationNotesResponseModel
    deletePersonalMedicationNotesResponseModelFromJson(String str) =>
        DeletePersonalMedicationNotesResponseModel.fromJson(json.decode(str));

String deletePersonalMedicationNotesResponseModelToJson(
        DeletePersonalMedicationNotesResponseModel data) =>
    json.encode(data.toJson());

class DeletePersonalMedicationNotesResponseModel {
  String status;
  bool data;
  String message;

  DeletePersonalMedicationNotesResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory DeletePersonalMedicationNotesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      DeletePersonalMedicationNotesResponseModel(
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
