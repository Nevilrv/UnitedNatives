import 'package:united_natives/ResponseModel/appointment.dart';

class DoctorBySpecialitiesModel {
  String? status;
  List<DoctorSpecialities>? doctorSpecialities;
  String? message;
  int? doctorsCount;

  DoctorBySpecialitiesModel(
      {this.status, this.doctorSpecialities, this.doctorsCount, this.message});

  DoctorBySpecialitiesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      doctorSpecialities = <DoctorSpecialities>[];
      json['data'].forEach((v) {
        doctorSpecialities?.add(DoctorSpecialities.fromJson(v));
      });
    }
    message = json['message'];
    doctorsCount = json['doctorsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (doctorSpecialities != null) {
      data['data'] = doctorSpecialities?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['doctorsCount'] = doctorsCount;
    return data;
  }
}

class NavigationModel {
  DoctorSpecialities? doctorSpecialities;
  String? mySelectedDate;
  int? time;
  int? minute;
  String? utcDateTime;
  final Appointment? doctor;

  NavigationModel({
    this.doctorSpecialities,
    this.mySelectedDate,
    this.time,
    this.doctor,
    this.minute,
    this.utcDateTime,
  });
}

class DoctorSpecialities {
  String? id;
  String? userId;
  String? certificateNo;
  String? speciality;
  String? education;
  String? perAppointmentCharge;
  String? modified;
  String? created;
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
  String? socialProfilePic;
  String? profilePic;
  var rating;

  DoctorSpecialities(
      {this.id,
      this.userId,
      this.certificateNo,
      this.speciality,
      this.education,
      this.perAppointmentCharge,
      this.modified,
      this.created,
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
      this.socialProfilePic,
      this.profilePic,
      this.rating});

  DoctorSpecialities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    certificateNo = json['certificate_no'];
    speciality = json['speciality'];
    education = json['education'];
    perAppointmentCharge = json['per_appointment_charge'];
    modified = json['modified'];
    created = json['created'];
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
    socialProfilePic = json['social_profile_pic'];
    profilePic = json['profile_pic'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['certificate_no'] = certificateNo;
    data['speciality'] = speciality;
    data['education'] = education;
    data['per_appointment_charge'] = perAppointmentCharge;
    data['modified'] = modified;
    data['created'] = created;
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
    data['social_profile_pic'] = socialProfilePic;
    data['profile_pic'] = profilePic;
    data['rating'] = rating;
    return data;
  }
}
