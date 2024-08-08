class ChatStatusResponseModel {
  String? status;
  Data? data;
  String? message;

  ChatStatusResponseModel({this.status, this.data, this.message});

  ChatStatusResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  bool? isOnline;
  String? lastSeen;

  Data({this.isOnline, this.lastSeen});

  Data.fromJson(Map<String, dynamic> json) {
    isOnline = json['is_online'];
    lastSeen = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_online'] = isOnline;
    data['last_seen'] = lastSeen;
    return data;
  }
}
