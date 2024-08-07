class ChatStatusResponseModel {
  String status;
  Data data;
  String message;

  ChatStatusResponseModel({this.status, this.data, this.message});

  ChatStatusResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  bool isOnline;
  String lastSeen;

  Data({this.isOnline, this.lastSeen});

  Data.fromJson(Map<String, dynamic> json) {
    isOnline = json['is_online'];
    lastSeen = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_online'] = this.isOnline;
    data['last_seen'] = this.lastSeen;
    return data;
  }
}
