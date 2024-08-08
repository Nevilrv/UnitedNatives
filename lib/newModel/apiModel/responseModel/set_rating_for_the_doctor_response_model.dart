import 'dart:convert';

SetRatingForTheDoctorResponseModel setRatingForTheDoctorResponseModelFromJson(
        String str) =>
    SetRatingForTheDoctorResponseModel.fromJson(json.decode(str));

String setRatingForTheDoctorResponseModelToJson(
        SetRatingForTheDoctorResponseModel data) =>
    json.encode(data.toJson());

class SetRatingForTheDoctorResponseModel {
  String? status;
  bool? data;
  String? message;

  SetRatingForTheDoctorResponseModel({
    this.status,
    this.data,
    this.message,
  });

  factory SetRatingForTheDoctorResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SetRatingForTheDoctorResponseModel(
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
