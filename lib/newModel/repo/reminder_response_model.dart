import 'dart:convert';

List<RemindersResponseModel> remindersResponseModelFromJson(String str) =>
    List<RemindersResponseModel>.from(
        json.decode(str).map((x) => RemindersResponseModel.fromJson(x)));

String remindersResponseModelToJson(List<RemindersResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RemindersResponseModel {
  int? id;
  String? name;
  String? dose;
  String? image;
  String? time;
  int? isEveryDay;

  RemindersResponseModel({
    this.id,
    this.name,
    this.dose,
    this.image,
    this.time,
    this.isEveryDay,
  });

  factory RemindersResponseModel.fromJson(Map<String, dynamic> json) =>
      RemindersResponseModel(
        id: json["id"],
        name: json["name"],
        dose: json["dose"],
        image: json["image"],
        time: json["time"],
        isEveryDay: json["isEveryDay"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "dose": dose,
        "image": image,
        "time": time,
        "isEveryDay": isEveryDay,
      };
}
