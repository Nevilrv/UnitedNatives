class UpdateDoctorRequestModel {
  int id;
  int patientId;
  String doctorName;
  String contactNumber;

  UpdateDoctorRequestModel(
      {this.patientId, this.contactNumber, this.doctorName, this.id});

  UpdateDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    doctorName = json['doctor_name'];
    contactNumber = json['doctor_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['doctor_name'] = this.doctorName;
    data['doctor_mobile'] = this.contactNumber;

    return data;
  }
}
