class DeletePersonalMedicationNotesRequestModel {
  String notesId;
  String patientId;

  DeletePersonalMedicationNotesRequestModel({this.notesId, this.patientId});

  DeletePersonalMedicationNotesRequestModel.fromJson(
      Map<String, dynamic> json) {
    notesId = json['notes_id'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notes_id'] = this.notesId;
    data['patient_id'] = this.patientId;
    return data;
  }
}
