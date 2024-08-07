class AddNewChatResponseModel {
  String status;
  String fileError;
  String message;

  AddNewChatResponseModel({this.status, this.fileError, this.message});

  AddNewChatResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    fileError = json['fileError'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['fileError'] = this.fileError;
    data['message'] = this.message;
    return data;
  }
}
