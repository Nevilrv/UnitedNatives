class AddNotesModel {
  int patientId;
  int doctorId;
  String notes;

  AddNotesModel({this.patientId, this.doctorId, this.notes});

  AddNotesModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['notes'] = this.notes;
    return data;
  }
}
