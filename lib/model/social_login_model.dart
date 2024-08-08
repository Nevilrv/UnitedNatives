class SocialLoginModel {
  String? status;
  SocialLoginData? socialLoginData;
  String? message;

  SocialLoginModel({this.status, this.socialLoginData, this.message});

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    socialLoginData =
        json['data'] != null ? SocialLoginData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (socialLoginData != null) {
      data['data'] = socialLoginData?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class SocialLoginData {
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

  SocialLoginData(
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
      this.created});

  SocialLoginData.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
