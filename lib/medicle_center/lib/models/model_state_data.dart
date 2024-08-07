import 'dart:convert';

List<StateModel> stateModelFromJson(String str) =>
    List<StateModel>.from(json.decode(str).map((x) => StateModel.fromJson(x)));

String stateModelToJson(List<StateModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateModel {
  String id;
  String name;
  String code;
  String createdAt;
  String updatedAt;
  int doctorsCount;
  int medicalCenterInState;

  StateModel({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.doctorsCount,
    this.medicalCenterInState,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        doctorsCount: json["doctors_count"],
        medicalCenterInState: json["medical_center_in_state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "doctors_count": doctorsCount,
        "medical_center_in_state": medicalCenterInState,
      };
}
