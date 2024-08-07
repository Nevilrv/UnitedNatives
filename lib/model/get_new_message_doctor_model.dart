class CreateNewMessage {
  String status;
  String fileError;
  String chatKey;
  String message;

  CreateNewMessage({this.status, this.fileError, this.chatKey, this.message});

  CreateNewMessage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    fileError = json['fileError'];
    chatKey = json['chatKey'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['fileError'] = this.fileError;
    data['chatKey'] = this.chatKey;
    data['message'] = this.message;
    return data;
  }
}

