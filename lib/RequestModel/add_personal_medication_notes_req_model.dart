class AddPersonalMedicationNotesRequestModel {
  int? patientId;
  String? title;
  String? notes;
  String? dateTime;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['title'] = title;
    data['notes'] = notes;
    data['datetime'] = dateTime;
    return data;
  }
}
