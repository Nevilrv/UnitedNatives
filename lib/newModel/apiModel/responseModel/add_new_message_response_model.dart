class AddNewChatResponseModel {
  String? status;
  String? fileError;
  String? message;

  AddNewChatResponseModel({this.status, this.fileError, this.message});

  AddNewChatResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    fileError = json['fileError'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['fileError'] = fileError;
    data['message'] = message;
    return data;
  }
}
