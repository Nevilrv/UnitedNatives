class StoreMeetingCredantialResponseModel {
  String? status;
  String? message;
  Data? data;

  StoreMeetingCredantialResponseModel({this.status, this.message, this.data});

  StoreMeetingCredantialResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? fromUserId;
  String? toUserId;
  String? meetingId;
  String? meetingPassword;
  String? meetingStatus;
  String? created;
  String? modified;

  Data(
      {this.id,
      this.fromUserId,
      this.toUserId,
      this.meetingId,
      this.meetingPassword,
      this.meetingStatus,
      this.created,
      this.modified});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    meetingId = json['meeting_id'];
    meetingPassword = json['meeting_password'];
    meetingStatus = json['meeting_status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from_user_id'] = fromUserId;
    data['to_user_id'] = toUserId;
    data['meeting_id'] = meetingId;
    data['meeting_password'] = meetingPassword;
    data['meeting_status'] = meetingStatus;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}
