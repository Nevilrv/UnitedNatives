// To parse this JSON data, do
//
//     final getAllDoctorResponseModel = getAllDoctorResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllDoctorResponseModel getAllDoctorResponseModelFromJson(String str) => GetAllDoctorResponseModel.fromJson(json.decode(str));

String getAllDoctorResponseModelToJson(GetAllDoctorResponseModel data) => json.encode(data.toJson());

class GetAllDoctorResponseModel {
  GetAllDoctorResponseModel({
    this.status,
    this.data,
    this.message,
  });

  String status;
  List<Datum> data;
  String message;

  factory GetAllDoctorResponseModel.fromJson(Map<String, dynamic> json) => GetAllDoctorResponseModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  Datum({
    this.id,
    this.userType,
    this.isAdmin,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.loginType,
    this.fbId,
    this.googleId,
    this.contactNumber,
    this.dateOfBirth,
    this.password,
    this.socialProfilePic,
    this.profilePic,
    this.deviceTokens,
    this.adminReadStat,
    this.modified,
    this.created,
    this.certificateNo,
    this.education,
    this.rating,
    this.speciality,
    this.chatKey,
  });

  String id;
  String userType;
  String isAdmin;
  String firstName;
  String lastName;
  String gender;
  String email;
  String loginType;
  dynamic fbId;
  dynamic googleId;
  String contactNumber;
  DateTime dateOfBirth;
  String password;
  dynamic socialProfilePic;
  String profilePic;
  dynamic deviceTokens;
  String adminReadStat;
  DateTime modified;
  DateTime created;
  String certificateNo;
  String education;
  int rating;
  String speciality;
  String chatKey;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userType: json["user_type"],
    isAdmin: json["is_admin"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    gender: json["gender"],
    email: json["email"],
    loginType: json["login_type"],
    fbId: json["fb_id"],
    googleId: json["google_id"],
    contactNumber: json["contact_number"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    password: json["password"],
    socialProfilePic: json["social_profile_pic"],
    profilePic: json["profile_pic"],
    deviceTokens: json["device_tokens"],
    adminReadStat: json["admin_read_stat"],
    modified: DateTime.parse(json["modified"]),
    created: DateTime.parse(json["created"]),
    certificateNo: json["certificate_no"],
    education: json["education"],
    rating: json["rating"],
    speciality: json["speciality"],
    chatKey: json["chat_key"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_type": userType,
    "is_admin": isAdmin,
    "first_name": firstName,
    "last_name": lastName,
    "gender": gender,
    "email": email,
    "login_type": loginType,
    "fb_id": fbId,
    "google_id": googleId,
    "contact_number": contactNumber,
    "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "password": password,
    "social_profile_pic": socialProfilePic,
    "profile_pic": profilePic,
    "device_tokens": deviceTokens,
    "admin_read_stat": adminReadStat,
    "modified": modified.toIso8601String(),
    "created": created.toIso8601String(),
    "certificate_no": certificateNo,
    "education": education,
    "rating": rating,
    "speciality": speciality,
    "chat_key": chatKey,
  };
}
