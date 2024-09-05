import 'dart:convert';

DeletePatientAccountResponseModel deletePatientAccountResponseModelFromJson(
        String str) =>
    DeletePatientAccountResponseModel.fromJson(json.decode(str));

String deletePatientAccountResponseModelToJson(
        DeletePatientAccountResponseModel data) =>
    json.encode(data.toJson());

class DeletePatientAccountResponseModel {
  String? status;
  String? message;

  DeletePatientAccountResponseModel({
    this.status,
    this.message,
  });

  factory DeletePatientAccountResponseModel.fromJson(
          Map<String, dynamic> json) =>
      DeletePatientAccountResponseModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
