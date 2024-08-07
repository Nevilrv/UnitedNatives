class User {
  String id;
  String isAdmin;
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
  String modified;
  String created;
  String bloodGroup;
  String maritalStatus;
  String height;
  String weight;
  String emergencyContact;
  String currentCaseManagerInfo;
  String insuranceEligibility;
  String tribalStatus;
  String perAppointmentCharge;
  String certificateNo;
  String education;
  String speciality;
  String state;
  String city;
  String medicalCenterID;
  String isNativeAmerican;
  String isIhUser;
  String cityId;
  String stateId;
  String providerType;
  String insuranceCompanyName;
  String howDidYouHearAboutUs;
  String allergies;
  String usVeteranStatus;
  String tribalFederallyMember;
  String tribalFederallyState;
  String tribalBackgroundStatus;
  String cityName;
  String stateName;
  String medicalCenterName;

  User({
    this.id,
    this.isAdmin,
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
    this.bloodGroup,
    this.maritalStatus,
    this.height,
    this.weight,
    this.emergencyContact,
    this.currentCaseManagerInfo,
    this.insuranceEligibility,
    this.tribalStatus,
    this.perAppointmentCharge,
    this.certificateNo,
    this.education,
    this.speciality,
    this.state,
    this.city,
    this.medicalCenterID,
    this.isNativeAmerican,
    this.isIhUser,
    this.stateId,
    this.cityId,
    this.providerType,
    this.insuranceCompanyName,
    this.howDidYouHearAboutUs,
    this.allergies,
    this.usVeteranStatus,
    this.tribalFederallyMember,
    this.tribalFederallyState,
    this.tribalBackgroundStatus,
    this.cityName,
    this.stateName,
    this.medicalCenterName,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAdmin = json['is_admin'];
    userType = json['user_type'] ?? "";
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    email = json['email'];
    loginType = json['login_type'];
    fbId = json['fb_id'];
    googleId = json['google_id'];
    contactNumber = json['contact_number'];
    dateOfBirth = json['date_of_birth'] ?? "";
    password = json['password'];
    socialProfilePic = json['social_profile_pic'];
    profilePic = json['profile_pic'];
    modified = json['modified'];
    created = json['created'];
    bloodGroup = json['blood_group_dec'] ?? "";
    maritalStatus = json['marital_status'] ?? "";
    height = json['height_dec'] ?? "";
    weight = json['weight_dec'] ?? "";
    emergencyContact = json['emergency_contact_dec'] ?? "";
    currentCaseManagerInfo =
        json['case_manager_dec'] ?? json['current_case_manager'] ?? "";
    insuranceEligibility = json['insurance_eligibility'];
    tribalStatus = json['tribal_status'];
    perAppointmentCharge = json['per_appointment_charge'];
    certificateNo = json['certificate_no'];
    education = json['education'];
    speciality = json['speciality'];
    state = json['state'] ?? "";
    city = json['city'] ?? "";
    medicalCenterID = json['medical_center_id'] ?? "";
    isNativeAmerican = json["is_native_american"];
    isIhUser = json["is_IH_user"];
    stateId = json["state"] ?? "";
    cityId = json["city"] ?? "";
    providerType = json["provider_type"] ?? "";
    insuranceCompanyName = json["medical_insurance_name"] ?? "";
    howDidYouHearAboutUs = json["how_did_you_hear_about_us"] ?? "";
    allergies = json["allergies"] ?? "";
    usVeteranStatus = json["us_veteran_status"] ?? "";
    tribalFederallyMember = json["tribal_federally_member"] ?? "";
    tribalFederallyState = json["tribal_federally_state"] ?? "";
    tribalBackgroundStatus = json["tribal_background_status"] ?? "";
    cityName = json["cityName"] ?? "";
    stateName = json["stateName"] ?? "";
    medicalCenterName = json["medicalCenterName"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_admin'] = this.isAdmin;
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
    data['modified'] = this.modified;
    data['created'] = this.created;
    data['bloodGroup'] = this.bloodGroup;
    data['maritalStatus'] = this.maritalStatus;
    data['height_dec'] = this.height;
    data['weight_dec'] = this.weight;
    data['emergency_contact_dec'] = this.emergencyContact;
    data['case_manager_dec'] = this.currentCaseManagerInfo;
    data['insuranceEligibility'] = this.insuranceEligibility;
    data['tribalStatus'] = this.tribalStatus;
    data['per_appointment_charge'] = this.perAppointmentCharge;
    data['speciality'] = this.speciality;
    data['education'] = this.education;
    data['certificate_no'] = this.certificateNo;
    data['state'] = this.state;
    data['city'] = this.city;
    data['medical_center_id'] = this.medicalCenterID;
    data['is_native_american'] = this.isNativeAmerican;
    data['is_IH_user'] = this.isIhUser;
    data['state'] = this.stateId;
    data['city'] = this.cityId;
    data['provider_type'] = this.providerType;
    data['medical_insurance_name'] = this.insuranceCompanyName;
    data['how_did_you_hear_about_us'] = this.howDidYouHearAboutUs;
    data['us_veteran_status'] = this.usVeteranStatus;
    data['allergies'] = this.allergies;
    data['tribal_federally_member'] = this.tribalFederallyMember;
    data['tribal_federally_state'] = this.tribalFederallyState;
    data['tribal_background_status'] = this.tribalBackgroundStatus;
    data['cityName;'] = this.cityName;
    data['stateName;'] = this.stateName;
    data['medicalCenterName;'] = this.medicalCenterName;

    return data;
  }

  toString() {
    return "id : $id, bloodGroup: $bloodGroup, maritalStatus: $maritalStatus";
  }
}
