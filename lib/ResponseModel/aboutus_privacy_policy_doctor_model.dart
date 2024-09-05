class AboutUsPrivacyPolicyDoctorModel {
  String? _status;
  Data? _data;

  AboutUsPrivacyPolicyDoctorModel({String? status, Data? data}) {
    _status = status;
    _data = data;
  }

  String? get status => _status;
  set status1(String? status) => _status = status;

  Data? get data => _data;
  set data1(Data? data) => _data = data;

  AboutUsPrivacyPolicyDoctorModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    if (_data != null) {
      data['data'] = _data!.toJson();
    }
    return data;
  }
}

class Data {
  String? _aboutUnh;
  String? _privacyPolicy;

  Data({String? aboutUnh, String? privacyPolicy}) {
    _aboutUnh = aboutUnh;
    _privacyPolicy = privacyPolicy;
  }

  String? get aboutUnh => _aboutUnh;
  set aboutUnh1(String? aboutUnh) => _aboutUnh = aboutUnh;

  String? get privacyPolicy => _privacyPolicy;
  set privacyPolicy1(String? privacyPolicy) => _privacyPolicy = privacyPolicy;

  Data.fromJson(Map<String, dynamic> json) {
    _aboutUnh = json['about_ih'];
    _privacyPolicy = json['privacy_policy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about_ih'] = _aboutUnh;
    data['privacy_policy'] = _privacyPolicy;
    return data;
  }
}
