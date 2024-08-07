// To parse this JSON data, do
//
//     final getCityResponseModel = getCityResponseModelFromJson(jsonString);

import 'dart:convert';

List<GetCityResponseModel> getCityResponseModelFromJson(String str) =>
    List<GetCityResponseModel>.from(
        json.decode(str).map((x) => GetCityResponseModel.fromJson(x)));

String getCityResponseModelToJson(List<GetCityResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCityResponseModel {
  String id;
  String stateId;
  String name;
  dynamic createdAt;
  dynamic updatedAt;

  GetCityResponseModel({
    this.id,
    this.stateId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory GetCityResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCityResponseModel(
        id: json["id"],
        stateId: json["state_id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
