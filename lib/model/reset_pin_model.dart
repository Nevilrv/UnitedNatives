class ResetPIN {
  String status;
  int requestId;
  String message;

  ResetPIN({this.status, this.requestId, this.message});

  ResetPIN.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    requestId = json['request_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['request_id'] = this.requestId;
    data['message'] = this.message;
    return data;
  }
}
