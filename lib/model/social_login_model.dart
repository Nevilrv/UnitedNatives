class SocialLoginModel {
  String status;
  SocialLoginData socialLoginData;
  String message;

  SocialLoginModel({this.status, this.socialLoginData, this.message});

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    socialLoginData = json['data'] != null ? new SocialLoginData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.socialLoginData != null) {
      data['data'] = this.socialLoginData.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class SocialLoginData {
  String id;
  String userType;
  String firstName;
  String lastName;
  String gender;
  String email;
  String loginType;
  String fbId;
  Null googleId;
  Null contactNumber;
  Null dateOfBirth;
  String password;
  String socialProfilePic;
  Null profilePic;
  String modified;
  String created;

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
    data['modified'] = this.modified;
    data['created'] = this.created;
    return data;
  }
}
