class LoginVerification {
  String? status;
  LoginVerificationData? loginVerificationData;
  String? message;

  LoginVerification({this.status, this.loginVerificationData, this.message});

  LoginVerification.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    loginVerificationData =
        json['data'] != null ? LoginVerificationData.fromJson(json) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (loginVerificationData != null) {
      data['data'] = loginVerificationData?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class LoginVerificationData {
  String? id;
  String? firstName;
  String? lastName;
  String? loginType;
  String? email;
  String? profilePic;
  String? socialProfilePic;
  String? isFirstTime;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['login_type'] = loginType;
    data['email'] = email;
    data['profile_pic'] = profilePic;
    data['social_profile_pic'] = socialProfilePic;
    data['first_time_login'] = isFirstTime;
    return data;
  }
}
