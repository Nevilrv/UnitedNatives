class UpdateDoctorRequestModel {
  int? id;
  int? patientId;
  String? doctorName;
  String? contactNumber;

  UpdateDoctorRequestModel(
      {this.patientId, this.contactNumber, this.doctorName, this.id});

  UpdateDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    doctorName = json['doctor_name'];
    contactNumber = json['doctor_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['doctor_name'] = doctorName;
    data['doctor_mobile'] = contactNumber;

    return data;
  }
}
