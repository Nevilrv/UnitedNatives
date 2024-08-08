class GetDirectDoctorResponseModel {
  String? status;
  List<Data>? data;
  String? message;

  GetDirectDoctorResponseModel({this.status, this.data, this.message});

  GetDirectDoctorResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
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

class DirectDoctorModel {
  Data? doctorSpecialities;
  String? mySelectedDate;
  int? time;

  DirectDoctorModel({this.doctorSpecialities, this.mySelectedDate, this.time});
}

class Data {
  String? id;
  String? userId;
  String? isDirectAvailable;
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
  int? rating;

  Data(
      {this.id,
      this.userId,
      this.isDirectAvailable,
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isDirectAvailable = json['is_direct_available'];
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
    data['is_direct_available'] = isDirectAvailable;
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
