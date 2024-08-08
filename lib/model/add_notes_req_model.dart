class AddNotesModel {
  int? patientId;
  int? doctorId;
  String? notes;

  AddNotesModel({this.patientId, this.doctorId, this.notes});

  AddNotesModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['doctor_id'] = doctorId;
    data['notes'] = notes;
    return data;
  }
}
