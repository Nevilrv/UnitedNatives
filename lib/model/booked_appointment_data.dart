class AppointmentBookedModel {
  String status;
  int data;
  String message;

  AppointmentBookedModel({this.status, this.data, this.message});

  AppointmentBookedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['appointment_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['appointment_id'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
