class SocialLoginGoogle {
  String? status;
  SocialLoginGoogleData? socialLoginGoogleData;
  String? message;

  SocialLoginGoogle({this.status, this.socialLoginGoogleData, this.message});

  SocialLoginGoogle.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    socialLoginGoogleData = json['data'] != null
        ? SocialLoginGoogleData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (socialLoginGoogleData != null) {
      data['data'] = socialLoginGoogleData?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class SocialLoginGoogleData {
  String? id;
  String? firstName;
  String? lastName;
  String? loginType;
  String? email;
  String? profilePic;
  String? socialProfilePic;

  SocialLoginGoogleData(
      {this.id,
      this.firstName,
      this.lastName,
      this.loginType,
      this.email,
      this.profilePic,
      this.socialProfilePic});

  SocialLoginGoogleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    loginType = json['login_type'];
    email = json['email'];
    profilePic = json['profile_pic'];
    socialProfilePic = json['social_profile_pic'];
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
    return data;
  }
}
