class User {
  String? id;
  String? isAdmin;
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
  String? bloodGroup;
  String? maritalStatus;
  String? height;
  String? weight;
  String? emergencyContact;
  String? currentCaseManagerInfo;
  String? insuranceEligibility;
  String? tribalStatus;
  String? perAppointmentCharge;
  String? certificateNo;
  String? education;
  String? speciality;
  String? state;
  String? city;
  String? medicalCenterID;
  String? isNativeAmerican;
  String? isIhUser;
  String? cityId;
  String? stateId;
  String? providerType;
  String? insuranceCompanyName;
  String? howDidYouHearAboutUs;
  String? allergies;
  String? usVeteranStatus;
  String? tribalFederallyMember;
  String? tribalFederallyState;
  String? tribalBackgroundStatus;
  String? cityName;
  String? stateName;
  String? medicalCenterName;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_admin'] = isAdmin;
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
    data['bloodGroup'] = bloodGroup;
    data['maritalStatus'] = maritalStatus;
    data['height_dec'] = height;
    data['weight_dec'] = weight;
    data['emergency_contact_dec'] = emergencyContact;
    data['case_manager_dec'] = currentCaseManagerInfo;
    data['insuranceEligibility'] = insuranceEligibility;
    data['tribalStatus'] = tribalStatus;
    data['per_appointment_charge'] = perAppointmentCharge;
    data['speciality'] = speciality;
    data['education'] = education;
    data['certificate_no'] = certificateNo;
    data['state'] = state;
    data['city'] = city;
    data['medical_center_id'] = medicalCenterID;
    data['is_native_american'] = isNativeAmerican;
    data['is_IH_user'] = isIhUser;
    data['state'] = stateId;
    data['city'] = cityId;
    data['provider_type'] = providerType;
    data['medical_insurance_name'] = insuranceCompanyName;
    data['how_did_you_hear_about_us'] = howDidYouHearAboutUs;
    data['us_veteran_status'] = usVeteranStatus;
    data['allergies'] = allergies;
    data['tribal_federally_member'] = tribalFederallyMember;
    data['tribal_federally_state'] = tribalFederallyState;
    data['tribal_background_status'] = tribalBackgroundStatus;
    data['cityName;'] = cityName;
    data['stateName;'] = stateName;
    data['medicalCenterName;'] = medicalCenterName;

    return data;
  }

  @override
  toString() {
    return "id : $id, bloodGroup: $bloodGroup, maritalStatus: $maritalStatus";
  }
}
