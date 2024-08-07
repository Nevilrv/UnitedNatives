import 'package:doctor_appointment_booking/model/api_state_enum.dart';

class GetAllDoctor {
  String status;
  List<Doctor> data;
  String message;
  APIState apiState;

  GetAllDoctor({this.status, this.data, this.message});

  GetAllDoctor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data.add(new Doctor.fromJson(v));
      });
    }
    message = json['message'];

    if (data.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Doctor {
  String id;
  String userType;
  String firstName;
  String lastName;
  String gender;
  String email;
  String loginType;
  String fbId;
  String googleId;
  String contactNumber;
  String dateOfBirth;
  String password;
  String socialProfilePic;
  String profilePic;
  String adminReadStat;
  String modified;
  String created;
  String certificateNo;
  String education;
  double rating;
  String speciality;
  String chatKey;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['login_type'] = this.loginType;
    data['fb_id'] = this.fbId;
    data['google_id'] = this.googleId;
    data['contact_number'] = this.contactNumber;
    data['date_of_birth'] = this.dateOfBirth;
    data['password'] = this.password;
    data['social_profile_pic'] = this.socialProfilePic;
    data['profile_pic'] = this.profilePic;
    data['admin_read_stat'] = this.adminReadStat;
    data['modified'] = this.modified;
    data['created'] = this.created;
    data['certificate_no'] = this.certificateNo;
    data['education'] = this.education;
    data['rating'] = this.rating;
    data['speciality'] = this.speciality;
    data['chat_key'] = this.chatKey;
    return data;
  }
}
