class DeleteDoctorRequestModel {
  int id;
  int patientId;

  DeleteDoctorRequestModel({this.id, this.patientId});

  DeleteDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    return data;
  }
}
