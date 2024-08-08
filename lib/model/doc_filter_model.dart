import 'dart:convert';

List<DocFilterModel> docFilterModelFromJson(String str) =>
    List<DocFilterModel>.from(
        json.decode(str).map((x) => DocFilterModel.fromJson(x)));

String docFilterModelToJson(List<DocFilterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DocFilterModel {
  DocFilterModel({
    this.id,
    this.userType,
    this.isAdmin,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.state,
    this.city,
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
    this.isOnline,
    this.lastSeenDttm,
    this.isNativeAmerican,
    this.modified,
    this.created,
    this.certificateNo,
    this.education,
    this.rating,
    this.speciality,
  });

  String? id;
  dynamic userType;
  String? isAdmin;
  dynamic firstName;
  dynamic lastName;
  dynamic gender;
  dynamic email;
  dynamic state;
  String? city;
  dynamic loginType;
  dynamic fbId;
  dynamic googleId;
  dynamic contactNumber;
  dynamic dateOfBirth;
  String? password;
  dynamic socialProfilePic;
  String? profilePic;
  String? deviceTokens;
  String? adminReadStat;
  String? isOnline;
  DateTime? lastSeenDttm;
  dynamic isNativeAmerican;
  DateTime? modified;
  DateTime? created;
  dynamic certificateNo;
  dynamic education;
  int? rating;
  String? speciality;

  factory DocFilterModel.fromJson(Map<String, dynamic> json) => DocFilterModel(
        id: json["id"],
        userType: json["user_type"],
        isAdmin: json["is_admin"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        gender: json["gender"],
        email: json["email"],
        state: json["state"],
        city: json["city"],
        loginType: json["login_type"],
        fbId: json["fb_id"],
        googleId: json["google_id"],
        contactNumber: json["contact_number"],
        dateOfBirth: json["date_of_birth"],
        password: json["password"],
        socialProfilePic: json["social_profile_pic"],
        profilePic: json["profile_pic"],
        deviceTokens: json["device_tokens"],
        adminReadStat: json["admin_read_stat"],
        isOnline: json["is_online"],
        lastSeenDttm: DateTime.parse(json["last_seen_dttm"]),
        isNativeAmerican: json["is_native_american"],
        modified: DateTime.parse(json["modified"]),
        created: DateTime.parse(json["created"]),
        certificateNo: json["certificate_no"],
        education: json["education"],
        rating: json["rating"],
        speciality: json["speciality"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "is_admin": isAdmin,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "email": email,
        "state": state,
        "city": city,
        "login_type": loginType,
        "fb_id": fbId,
        "google_id": googleId,
        "contact_number": contactNumber,
        "date_of_birth": dateOfBirth,
        "password": password,
        "social_profile_pic": socialProfilePic,
        "profile_pic": profilePic,
        "device_tokens": deviceTokens,
        "admin_read_stat": adminReadStat,
        "is_online": isOnline,
        "last_seen_dttm": lastSeenDttm?.toIso8601String(),
        "is_native_american": isNativeAmerican,
        "modified": modified?.toIso8601String(),
        "created": created?.toIso8601String(),
        "certificate_no": certificateNo,
        "education": education,
        "rating": rating,
        "speciality": speciality,
      };
}
