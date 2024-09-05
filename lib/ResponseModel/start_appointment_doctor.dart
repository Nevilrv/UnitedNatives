class StartAppointmentDoctor {
  String? status;
  String? message;

  StartAppointmentDoctor({this.status, this.message});

  StartAppointmentDoctor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
