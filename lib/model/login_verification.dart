class LoginVerification {
  String status;
  LoginVerificationData loginVerificationData;
  String message;

  LoginVerification({this.status, this.loginVerificationData, this.message});

  LoginVerification.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    loginVerificationData =
        json['data'] != null ? new LoginVerificationData.fromJson(json) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.loginVerificationData != null) {
      data['data'] = this.loginVerificationData.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class LoginVerificationData {
  String id;
  String firstName;
  String lastName;
  String loginType;
  String email;
  String profilePic;
  String socialProfilePic;
  String isFirstTime;

  LoginVerificationData(
      {this.id,
      this.firstName,
      this.lastName,
      this.loginType,
      this.email,
      this.profilePic,
      this.socialProfilePic,
      this.isFirstTime});

  LoginVerificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    loginType = json['login_type'];
    email = json['email'];
    profilePic = json['profile_pic'];
    profilePic = json['profile_pic'];
    isFirstTime = json['first_time_login'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['login_type'] = this.loginType;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['social_profile_pic'] = this.socialProfilePic;
    data['first_time_login'] = this.isFirstTime;
    return data;
  }
}
