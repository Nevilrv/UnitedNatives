class Prescription {
  String id;
  String doctorId;
  String patientId;
  String appointmentId;
  String medicineName;
  String medicineRoutine;
  String additionalNotes;
  String treatmentDays;
  String pillsPerDay;
  String created;
  String modified;
  String purposeOfVisit;
  String appointmentDate;
  String appointmentTime;
  String appointmentPatientFullName;
  String patientFirstName;
  String patientLastName;

  Prescription(
      {this.id,
      this.doctorId,
      this.patientId,
      this.appointmentId,
      this.medicineName,
      this.medicineRoutine,
      this.additionalNotes,
      this.treatmentDays,
      this.pillsPerDay,
      this.created,
      this.modified,
      this.purposeOfVisit,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentPatientFullName,
      this.patientFirstName,
      this.patientLastName});

  Prescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    patientId = json['patient_id'];
    appointmentId = json['appointment_id'];
    medicineName = json['medicine_name'];
    medicineRoutine = json['medicine_routine'];
    additionalNotes = json['additional_notes'];
    treatmentDays = json['treatment_days'];
    pillsPerDay = json['pills_per_day'];
    created = json['created'];
    modified = json['modified'];
    purposeOfVisit = json['purpose_of_visit'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    appointmentPatientFullName = json['appointment_patient_full_name'];
    patientFirstName = json['patient_first_name'];
    patientLastName = json['patient_last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['patient_id'] = this.patientId;
    data['appointment_id'] = this.appointmentId;
    data['medicine_name'] = this.medicineName;
    data['medicine_routine'] = this.medicineRoutine;
    data['additional_notes'] = this.additionalNotes;
    data['treatment_days'] = this.treatmentDays;
    data['pills_per_day'] = this.pillsPerDay;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['purpose_of_visit'] = this.purposeOfVisit;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['appointment_patient_full_name'] = this.appointmentPatientFullName;
    data['patient_first_name'] = this.patientFirstName;
    data['patient_last_name'] = this.patientLastName;
    return data;
  }

  static List<Prescription> getPrescriptionList(List<dynamic> jsonList) {
    List<Prescription> tempList = [];
    jsonList?.forEach((element) {
      tempList.add(Prescription.fromJson(element));
    });
    return tempList;
  }
}
