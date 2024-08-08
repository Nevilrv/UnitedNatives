class RoomDetailResponseModel {
  String? status;
  List<Data>? data;
  String? message;

  RoomDetailResponseModel({this.status, this.data, this.message});

  RoomDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? staffInChargeName;
  int? status;
  String? patientId;
  String? patientName;
  String? patientProfilepicture;
  String? patientAdmissiondate;
  String? patientReason;
  String? patientAdmissiontime;
  String? statusDisplay;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['staff_incharge_name'] = staffInChargeName;
    data['status'] = status;
    data['patient_id'] = patientId;
    data['patient_name'] = patientName;
    data['patient_profilepicture'] = patientProfilepicture;
    data['patient_admissiondate'] = patientAdmissiondate;
    data['patient_reason'] = patientReason;
    data['patient_admissiontime'] = patientAdmissiontime;
    data['status_display'] = statusDisplay;
    return data;
  }
}
