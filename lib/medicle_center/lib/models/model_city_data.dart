import 'dart:convert';

List<CityModel> cityModelFromJson(String str) =>
    List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));

String cityModelToJson(List<CityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  String id;
  String stateId;
  String name;
  dynamic createdAt;
  dynamic updatedAt;
  int doctorsCount;
  int medicalCenterInState;
  int medicalCenterInCity;

  CityModel({
    this.id,
    this.stateId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.doctorsCount,
    this.medicalCenterInState,
    this.medicalCenterInCity,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"] ?? "",
        stateId: json["state_id"] ?? "",
        name: json["name"] ?? "",
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        doctorsCount: json["doctors_count"] ?? 0,
        medicalCenterInState: json["medical_center_in_state"] ?? 0,
        medicalCenterInCity: json["medical_center_in_city"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "doctors_count": doctorsCount,
        "medical_center_in_state": medicalCenterInState,
        "medical_center_in_city": medicalCenterInCity,
      };
}
