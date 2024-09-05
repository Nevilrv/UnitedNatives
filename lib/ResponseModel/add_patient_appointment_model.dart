class AddPatientAppointment {
  String? patientId;
  String? doctorId;
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentFor;
  String? fullName;
  String? mobile;
  String? email;
  String? patientMobile;

  AddPatientAppointment(
      {this.patientId,
      this.doctorId,
      this.purposeOfVisit,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentFor,
      this.fullName,
      this.mobile,
      this.email,
      this.patientMobile});

  AddPatientAppointment.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    purposeOfVisit = json['purpose_of_visit'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    appointmentFor = json['appointment_for'];
    fullName = json['full_name'];
    mobile = json['mobile'];
    email = json['email'];
    patientMobile = json['patient_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['doctor_id'] = doctorId;
    data['purpose_of_visit'] = purposeOfVisit;
    data['appointment_date'] = appointmentDate;
    data['appointment_time'] = appointmentTime;
    data['appointment_for'] = appointmentFor;
    data['full_name'] = fullName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['patient_mobile'] = patientMobile;
    return data;
  }
}
