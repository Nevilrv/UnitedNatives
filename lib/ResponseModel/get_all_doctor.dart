import 'package:united_natives/ResponseModel/api_state_enum.dart';

class GetAllDoctor {
  String? status;
  List<Doctor>? data;
  String? message;
  APIState? apiState;

  GetAllDoctor({this.status, this.data, this.message});

  GetAllDoctor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data?.add(Doctor.fromJson(v));
      });
    }
    message = json['message'];

    if (data!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Doctor {
  String? id;
  String? userType;
  String? firstName;
  String? lastName;
  String? gender;
  String? email;
  String? loginType;
  String? fbId;
  String? googleId;
  String? contactNumber;
  String? dateOfBirth;
  String? password;
  String? socialProfilePic;
  String? profilePic;
  String? adminReadStat;
  String? modified;
  String? created;
  String? certificateNo;
  String? education;
  double? rating;
  String? speciality;
  String? chatKey;

  Doctor({
    this.id,
    this.userType,
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
    this.adminReadStat,
    this.modified,
    this.created,
    this.certificateNo,
    this.education,
    this.rating,
    this.speciality,
    this.chatKey,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    email = json['email'];
    loginType = json['login_type'];
    fbId = json['fb_id'];
    googleId = json['google_id'];
    contactNumber = json['contact_number'];
    dateOfBirth = json['date_of_birth'];
    password = json['password'];
    socialProfilePic = json['social_profile_pic'];
    profilePic = json['profile_pic'];
    adminReadStat = json['admin_read_stat'];
    modified = json['modified'];
    created = json['created'];
    certificateNo = json['certificate_no'];
    education = json['education'];
    rating = json['rating']?.toDouble() ?? 0.0;
    speciality = json['speciality'];
    chatKey = json['chat_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['email'] = email;
    data['login_type'] = loginType;
    data['fb_id'] = fbId;
    data['google_id'] = googleId;
    data['contact_number'] = contactNumber;
    data['date_of_birth'] = dateOfBirth;
    data['password'] = password;
    data['social_profile_pic'] = socialProfilePic;
    data['profile_pic'] = profilePic;
    data['admin_read_stat'] = adminReadStat;
    data['modified'] = modified;
    data['created'] = created;
    data['certificate_no'] = certificateNo;
    data['education'] = education;
    data['rating'] = rating;
    data['speciality'] = speciality;
    data['chat_key'] = chatKey;
    return data;
  }
}
