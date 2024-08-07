// To parse this JSON data, do
//
//     final getStatesResponseModel = getStatesResponseModelFromJson(jsonString);

import 'dart:convert';

List<GetStatesResponseModel> getStatesResponseModelFromJson(String str) =>
    List<GetStatesResponseModel>.from(
        json.decode(str).map((x) => GetStatesResponseModel.fromJson(x)));

String getStatesResponseModelToJson(List<GetStatesResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetStatesResponseModel {
  String id;
  String name;
  String code;
  String createdAt;
  String updatedAt;

  GetStatesResponseModel({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
  });

  factory GetStatesResponseModel.fromJson(Map<String, dynamic> json) =>
      GetStatesResponseModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
