class StoreMeetingCredantialResponseModel {
  String status;
  String message;
  Data data;

  StoreMeetingCredantialResponseModel({this.status, this.message, this.data});

  StoreMeetingCredantialResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String id;
  String fromUserId;
  String toUserId;
  String meetingId;
  String meetingPassword;
  String meetingStatus;
  String created;
  String modified;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['meeting_id'] = this.meetingId;
    data['meeting_password'] = this.meetingPassword;
    data['meeting_status'] = this.meetingStatus;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}
