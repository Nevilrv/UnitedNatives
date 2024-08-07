class RoomeDetailResponseModel {
  String status;
  List<Data> data;
  String message;

  RoomeDetailResponseModel({this.status, this.data, this.message});

  RoomeDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String id;
  String name;
  String staffInChargeName;
  int status;
  Null patientId;
  String patientName;
  String patientProfilepicture;
  String patientAdmissiondate;
  String patientReason;
  String patientAdmissiontime;
  String statusDisplay;

  Data(
      {this.id,
      this.name,
      this.staffInChargeName,
      this.status,
      this.patientId,
      this.patientName,
      this.patientProfilepicture,
      this.patientAdmissiondate,
      this.patientReason,
      this.patientAdmissiontime,
      this.statusDisplay});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    staffInChargeName = json['staff_incharge_name'];
    status = json['status'];
    patientId = json['patient_id'];
    patientName = json['patient_name'];
    patientProfilepicture = json['patient_profilepicture'];
    patientAdmissiondate = json['patient_admissiondate'];
    patientReason = json['patient_reason'];
    patientAdmissiontime = json['patient_admissiontime'];
    statusDisplay = json['status_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['staff_incharge_name'] = this.staffInChargeName;
    data['status'] = this.status;
    data['patient_id'] = this.patientId;
    data['patient_name'] = this.patientName;
    data['patient_profilepicture'] = this.patientProfilepicture;
    data['patient_admissiondate'] = this.patientAdmissiondate;
    data['patient_reason'] = this.patientReason;
    data['patient_admissiontime'] = this.patientAdmissiontime;
    data['status_display'] = this.statusDisplay;
    return data;
  }
}
