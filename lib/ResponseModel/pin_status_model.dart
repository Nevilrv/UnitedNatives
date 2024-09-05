class PINStatusModel {
  String? status;
  String? toInitiate;
  PINStatusData? pinStatusData;
  String? message;

  PINStatusModel(
      {this.status, this.toInitiate, this.pinStatusData, this.message});

  PINStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    toInitiate = json['to_initiate'];
    pinStatusData =
        json['data'] != null ? PINStatusData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['to_initiate'] = toInitiate;
    if (pinStatusData != null) {
      data['data'] = pinStatusData?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class PINStatusData {
  String? id;
  String? userId;
  String? adminVerified;
  String? userConsent;
  String? requestStatus;

  PINStatusData(
      {this.id,
      this.userId,
      this.adminVerified,
      this.userConsent,
      this.requestStatus});

  PINStatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    adminVerified = json['admin_verified'];
    userConsent = json['user_consent'];
    requestStatus = json['request_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['admin_verified'] = adminVerified;
    data['user_consent'] = userConsent;
    data['request_status'] = requestStatus;
    return data;
  }
}
