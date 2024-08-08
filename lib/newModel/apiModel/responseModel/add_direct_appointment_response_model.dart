class AddDirectAppointmentResponseModel {
  String? status;
  int? data;
  String? message;

  AddDirectAppointmentResponseModel({this.status, this.data, this.message});

  AddDirectAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data;
    data['message'] = message;
    return data;
  }
}
