class SpecialitiesModel {
  String? status;
  List<Specialities>? specialities;
  String? message;

  SpecialitiesModel({this.status, this.specialities, this.message});

  SpecialitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      specialities = <Specialities>[];
      json['data'].forEach((v) {
        specialities?.add(Specialities.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (specialities != null) {
      data['data'] = specialities?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Specialities {
  String? id;
  String? specialityName;
  String? specialityIcon;
  String? created;
  String? modified;
  String? doctorsCount;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['speciality_name'] = specialityName;
    data['speciality_image'] = specialityIcon;
    data['created'] = created;
    data['modified'] = modified;
    data['doctors_count'] = doctorsCount;
    return data;
  }
}
