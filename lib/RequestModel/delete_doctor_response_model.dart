class DeleteDoctorRequestModel {
  int? id;
  int? patientId;

  DeleteDoctorRequestModel({this.id, this.patientId});

  DeleteDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    return data;
  }
}
