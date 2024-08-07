class AboutUsPrivacyPolicyDoctorModel {
  String _status;
  Data _data;

  AboutUsPrivacyPolicyDoctorModel({String status, Data data}) {
    this._status = status;
    this._data = data;
  }

  String get status => this._status;
  set status(String status) => _status = status;
  Data get data => this._data;
  set data(Data data) => _data = data;

  AboutUsPrivacyPolicyDoctorModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  String _aboutUnh;
  String _privacyPolicy;

  Data({String aboutUnh, String privacyPolicy}) {
    this._aboutUnh = aboutUnh;
    this._privacyPolicy = privacyPolicy;
  }

  String get aboutUnh => this._aboutUnh;
  set aboutUnh(String aboutUnh) => _aboutUnh = aboutUnh;
  String get privacyPolicy => this._privacyPolicy;
  set privacyPolicy(String privacyPolicy) => _privacyPolicy = privacyPolicy;

  Data.fromJson(Map<String, dynamic> json) {
    _aboutUnh = json['about_ih'];
    _privacyPolicy = json['privacy_policy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_ih'] = this._aboutUnh;
    data['privacy_policy'] = this._privacyPolicy;
    return data;
  }
}
