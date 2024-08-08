class MyDoctorListRequestModel {
  int? patientId;
  String? doctorName;

  MyDoctorListRequestModel({this.patientId, this.doctorName});

  MyDoctorListRequestModel.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    patientId = json['doctor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patient_id'] = patientId;
    data['doctor_name'] = doctorName;
    return data;
  }
}
