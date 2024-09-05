class GetAllPersonalMedicationNotesRequestModel {
  int? patientId;

  GetAllPersonalMedicationNotesRequestModel({this.patientId});

  GetAllPersonalMedicationNotesRequestModel.fromJson(
      Map<String, dynamic> json) {
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    return data;
  }
}
