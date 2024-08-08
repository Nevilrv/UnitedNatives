import 'dart:convert';

SubmitUnitedNativesFormResponseModel
    submitUnitedNativesFormResponseModelFromJson(String str) =>
        SubmitUnitedNativesFormResponseModel.fromJson(json.decode(str));

String submitUnitedNativesFormResponseModelToJson(
        SubmitUnitedNativesFormResponseModel data) =>
    json.encode(data.toJson());

class SubmitUnitedNativesFormResponseModel {
  bool? success;
  String? message;

  SubmitUnitedNativesFormResponseModel({
    this.success,
    this.message,
  });

  factory SubmitUnitedNativesFormResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SubmitUnitedNativesFormResponseModel(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
