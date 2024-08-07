class AddPersonalMedicationNotesRequestModel {
  int patientId;
  String title;
  String notes;
  String dateTime;

  AddPersonalMedicationNotesRequestModel({
    this.patientId,
    this.title,
    this.notes,
    this.dateTime,
  });

  AddPersonalMedicationNotesRequestModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    title = json['title'];
    notes = json['notes'];
    dateTime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['title'] = this.title;
    data['notes'] = this.notes;
    data['datetime'] = this.dateTime;
    return data;
  }
}
