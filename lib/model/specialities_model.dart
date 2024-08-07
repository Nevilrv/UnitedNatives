class SpecialitiesModel {
  String status;
  List<Specialities> specialities;
  String message;

  SpecialitiesModel({this.status, this.specialities, this.message});

  SpecialitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      specialities = <Specialities>[];
      json['data'].forEach((v) {
        specialities.add(new Specialities.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.specialities != null) {
      data['data'] = this.specialities.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Specialities {
  String id;
  String specialityName;
  String specialityIcon;
  String created;
  String modified;
  String doctorsCount;
  // bool isCheckedBox = false;

  Specialities({
    this.id,
    this.specialityName,
    this.specialityIcon,
    this.created,
    this.modified,
    this.doctorsCount,
  });

  Specialities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialityName = json['speciality_name'];
    specialityIcon = json['speciality_image'];
    created = json['created'];
    modified = json['modified'];
    doctorsCount = json['doctors_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['speciality_name'] = this.specialityName;
    data['speciality_image'] = this.specialityIcon;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['doctors_count'] = this.doctorsCount;
    return data;
  }
}
