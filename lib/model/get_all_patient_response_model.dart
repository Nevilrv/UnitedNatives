import 'package:doctor_appointment_booking/model/api_state_enum.dart';

class GetAllPatient {
  String status;
  List<Patient> data;
  String message;
  APIState apiState;

  GetAllPatient({this.status, this.data, this.message});

  GetAllPatient.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Patient>[];
      json['data'].forEach((v) {
        data.add(new Patient.fromJson(v));
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

class Patient {
  String id;
  String userType;
  String isAdmin;
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
  String deviceTokens;
  String adminReadStat;
  String modified;
  String created;
  String bloodGroup;
  String maritalStatus;
  String height;
  String weight;
  String emergencyContact;
  String caseManager;
  String insuranceEligibility;
  String tribalStatus;
  String chatKey;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['is_admin'] = this.isAdmin;
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
    data['device_tokens'] = this.deviceTokens;
    data['admin_read_stat'] = this.adminReadStat;
    data['modified'] = this.modified;
    data['created'] = this.created;
    data['blood_group'] = this.bloodGroup;
    data['marital_status'] = this.maritalStatus;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['emergency_contact'] = this.emergencyContact;
    data['case_manager'] = this.caseManager;
    data['insurance_eligibility'] = this.insuranceEligibility;
    data['tribal_status'] = this.tribalStatus;
    data['chat_key'] = this.chatKey;
    return data;
  }
}
