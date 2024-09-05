class PatientUpdateDataModel {
  String? status;
  PatientUpdateData? patientUpdateData;
  String? message;

  PatientUpdateDataModel({this.status, this.patientUpdateData, this.message});

  PatientUpdateDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    patientUpdateData =
        json['data'] != null ? PatientUpdateData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (patientUpdateData != null) {
      data['data'] = patientUpdateData?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class PatientUpdateData {
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
  String? modified;
  String? created;
  String? height;
  String? weight;
  String? emergencyContact;
  String? caseManager;
  String? certificate;
  String? education;
  String? speciality;
  String? perAppointmentCharge;
  String? stateName;
  String? cityName;

  PatientUpdateData(
      {this.id,
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
      this.modified,
      this.created,
      this.height,
      this.weight,
      this.emergencyContact,
      this.caseManager,
      this.certificate,
      this.education,
      this.speciality,
      this.perAppointmentCharge,
      this.stateName,
      this.cityName});

  PatientUpdateData.fromJson(Map<String, dynamic> json) {
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
    modified = json['modified'];
    created = json['created'];
    height = json['height'];
    weight = json['weight'];
    emergencyContact = json['emergency_contact'];
    caseManager = json['case_manager'] ?? json['current_case_manager'];
    certificate = json['certificate_no'];
    education = json['education'];
    speciality = json['speciality'];
    perAppointmentCharge = json['per_appointment_rate'];
    cityName = json['city'];
    stateName = json['state'];
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
    data['modified'] = modified;
    data['created'] = created;
    data['height'] = height;
    data['weight'] = weight;
    data['emergency_contact'] = emergencyContact;
    data['case_manager'] = caseManager;
    data['certificate_no'] = certificate;
    data['education'] = education;
    data['speciality'] = speciality;
    data['per_appointment_rate'] = perAppointmentCharge;
    data['city'] = cityName;
    data['state'] = stateName;
    return data;
  }
}
