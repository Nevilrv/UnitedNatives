class AddDirectAppointmentReqModel {
  String? doctorId;
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentFor;
  String? fullName;
  String? mobile;
  String? email;
  String? patientMobile;
  String? appointmentNotes;
  AddDirectAppointmentReqModel(
      {this.doctorId,
      this.email,
      this.fullName,
      this.appointmentDate,
      this.appointmentFor,
      this.appointmentNotes,
      this.appointmentTime,
      this.mobile,
      this.patientMobile,
      this.purposeOfVisit});
  Future<Map<String, dynamic>> toJson() async {
    return {
      "doctor_id": doctorId,
      "purpose_of_visit": purposeOfVisit,
      "appointment_date": appointmentDate,
      "appointment_time": appointmentTime,
      "appointment_for": appointmentFor,
      "full_name": fullName,
      "mobile": mobile,
      "email": email,
      "patient_mobile": patientMobile,
      "appointment_notes": appointmentNotes
    };
  }
}
