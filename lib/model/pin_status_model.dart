class PINStatusModel {
  String status;
  String toInitiate;
  PINStatusData pinStatusData;
  String message;

  PINStatusModel(
      {this.status, this.toInitiate, this.pinStatusData, this.message});

  PINStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    toInitiate = json['to_initiate'];
    pinStatusData =
        json['data'] != null ? new PINStatusData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['to_initiate'] = this.toInitiate;
    if (this.pinStatusData != null) {
      data['data'] = this.pinStatusData.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class PINStatusData {
  String id;
  String userId;
  String adminVerified;
  String userConsent;
  String requestStatus;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['admin_verified'] = this.adminVerified;
    data['user_consent'] = this.userConsent;
    data['request_status'] = this.requestStatus;
    return data;
  }
}
