class AddMyDoctorRequestModel {
  int? patientId;
  String? doctorName;
  String? contactNumber;

  AddMyDoctorRequestModel(
      {this.patientId, this.contactNumber, this.doctorName});

  AddMyDoctorRequestModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    doctorName = json['doctor_name'];
    contactNumber = json['doctor_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['doctor_name'] = doctorName;
    data['doctor_mobile'] = contactNumber;

    return data;
  }
}
