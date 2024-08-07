class AddPatientAppointment {
  String patientId;
  String doctorId;
  String purposeOfVisit;
  String appointmentDate;
  String appointmentTime;
  String appointmentFor;
  String fullName;
  String mobile;
  String email;
  String patientMobile;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['purpose_of_visit'] = this.purposeOfVisit;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['appointment_for'] = this.appointmentFor;
    data['full_name'] = this.fullName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['patient_mobile'] = this.patientMobile;
    return data;
  }
}
