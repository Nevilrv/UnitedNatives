import 'package:united_natives/model/api_state_enum.dart';

class GetAllPatient {
  String? status;
  List<Patient>? data;
  String? message;
  APIState? apiState;

  GetAllPatient({this.status, this.data, this.message});

  GetAllPatient.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Patient>[];
      json['data'].forEach((v) {
        data?.add(Patient.fromJson(v));
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

class Patient {
  String? id;
  String? userType;
  String? isAdmin;
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
  String? deviceTokens;
  String? adminReadStat;
  String? modified;
  String? created;
  String? bloodGroup;
  String? maritalStatus;
  String? height;
  String? weight;
  String? emergencyContact;
  String? caseManager;
  String? insuranceEligibility;
  String? tribalStatus;
  String? chatKey;

  Patient(
      {this.id,
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
      this.bloodGroup,
      this.maritalStatus,
      this.height,
      this.weight,
      this.emergencyContact,
      this.caseManager,
      this.insuranceEligibility,
      this.tribalStatus,
      this.chatKey});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    isAdmin = json['is_admin'];
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
    deviceTokens = json['device_tokens'];
    adminReadStat = json['admin_read_stat'];
    modified = json['modified'];
    created = json['created'];
    bloodGroup = json['blood_group'];
    maritalStatus = json['marital_status'];
    height = json['height'];
    weight = json['weight'];
    emergencyContact = json['emergency_contact'];
    caseManager = json['case_manager'];
    insuranceEligibility = json['insurance_eligibility'];
    tribalStatus = json['tribal_status'];
    chatKey = json['chat_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['is_admin'] = isAdmin;
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
    data['device_tokens'] = deviceTokens;
    data['admin_read_stat'] = adminReadStat;
    data['modified'] = modified;
    data['created'] = created;
    data['blood_group'] = bloodGroup;
    data['marital_status'] = maritalStatus;
    data['height'] = height;
    data['weight'] = weight;
    data['emergency_contact'] = emergencyContact;
    data['case_manager'] = caseManager;
    data['insurance_eligibility'] = insuranceEligibility;
    data['tribal_status'] = tribalStatus;
    data['chat_key'] = chatKey;
    return data;
  }
}
