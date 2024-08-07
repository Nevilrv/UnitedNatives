class DoctorFilterModel {
  String status;
  List<FilteredDoctor> filteredDoctor;
  String message;

  DoctorFilterModel({this.status, this.filteredDoctor, this.message});

  DoctorFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      filteredDoctor = <FilteredDoctor>[];
      json['data'].forEach((v) {
        filteredDoctor.add(new FilteredDoctor.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.filteredDoctor != null) {
      data['data'] = this.filteredDoctor.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class FilteredDoctor {
  String id;
  String userId;
  String certificateNo;
  String speciality;
  String education;
  String perAppointmentCharge;
  String modified;
  String created;
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
  String socialProfilePic;
  String profilePic;

  FilteredDoctor(
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
      this.profilePic});

  FilteredDoctor.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['certificate_no'] = this.certificateNo;
    data['speciality'] = this.speciality;
    data['education'] = this.education;
    data['per_appointment_charge'] = this.perAppointmentCharge;
    data['modified'] = this.modified;
    data['created'] = this.created;
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
    data['social_profile_pic'] = this.socialProfilePic;
    data['profile_pic'] = this.profilePic;
    return data;
  }
}
