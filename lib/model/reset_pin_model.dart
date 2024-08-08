class ResetPIN {
  String? status;
  int? requestId;
  String? message;

  ResetPIN({this.status, this.requestId, this.message});

  ResetPIN.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['request_id'] = requestId;
    data['message'] = message;
    return data;
  }
}
