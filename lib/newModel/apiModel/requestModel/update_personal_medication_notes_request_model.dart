class UpdatePersonalMedicationNotesRequestModel {
  String notesId;
  String patientId;
  String title;
  String notes;
  String dateTime;

  UpdatePersonalMedicationNotesRequestModel(
      {this.notesId, this.patientId, this.title, this.notes, this.dateTime});

  UpdatePersonalMedicationNotesRequestModel.fromJson(
      Map<String, dynamic> json) {
    notesId = json['notes_id'];
    patientId = json['patient_id'];
    title = json['title'];
    notes = json['notes'];
    dateTime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes_id'] = this.notesId;
    data['patient_id'] = this.patientId;
    data['title'] = this.title;
    data['notes'] = this.notes;
    data['datetime'] = this.dateTime;
    return data;
  }
}
