import 'api_state_enum.dart';

class PatientPrescriptionsModel {
  String status;
  List<Data> data;
  String message;
  APIState apiState;

  PatientPrescriptionsModel({this.status, this.data, this.message});

  PatientPrescriptionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    if (data.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
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
  String doctorId;
  String patientId;
  String appointmentId;
  String medicineName;
  String medicineRoutine;
  String additionalNotes;
  String treatmentDays;
  String pillsPerDay;
  String created;
  String modified;
  String doctorName;
  String doctorProfilePic;
  String doctorSpeciality;
  String purposeOfVisit;
  String appointmentDate;
  String appointmentTime;
  String appointmentFor;
  String patientFullName;
  String userMobile;
  String patientMobile;
  String userEmail;

  Data(
      {this.id,
      this.doctorId,
      this.patientId,
      this.appointmentId,
      this.medicineName,
      this.medicineRoutine,
      this.additionalNotes,
      this.treatmentDays,
      this.pillsPerDay,
      this.created,
      this.modified,
      this.doctorName,
      this.doctorProfilePic,
      this.doctorSpeciality,
      this.purposeOfVisit,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentFor,
      this.patientFullName,
      this.userMobile,
      this.patientMobile,
      this.userEmail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    patientId = json['patient_id'];
    appointmentId = json['appointment_id'];
    medicineName = json['medicine_name'];
    medicineRoutine = json['medicine_routine'];
    additionalNotes = json['additional_notes'];
    treatmentDays = json['treatment_days'];
    pillsPerDay = json['pills_per_day'];
    created = json['created'];
    modified = json['modified'];
    doctorName = json['doctor_name'];
    doctorProfilePic = json['doctor_profile_pic'];
    doctorSpeciality = json['doctor_speciality'];
    purposeOfVisit = json['purpose_of_visit'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    appointmentFor = json['appointment_for'];
    patientFullName = json['patient_full_name'];
    userMobile = json['user_mobile'];
    patientMobile = json['patient_mobile'];
    userEmail = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['patient_id'] = this.patientId;
    data['appointment_id'] = this.appointmentId;
    data['medicine_name'] = this.medicineName;
    data['medicine_routine'] = this.medicineRoutine;
    data['additional_notes'] = this.additionalNotes;
    data['treatment_days'] = this.treatmentDays;
    data['pills_per_day'] = this.pillsPerDay;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['doctor_name'] = this.doctorName;
    data['doctor_profile_pic'] = this.doctorProfilePic;
    data['doctor_speciality'] = this.doctorSpeciality;
    data['purpose_of_visit'] = this.purposeOfVisit;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['appointment_for'] = this.appointmentFor;
    data['patient_full_name'] = this.patientFullName;
    data['user_mobile'] = this.userMobile;
    data['patient_mobile'] = this.patientMobile;
    data['user_email'] = this.userEmail;
    return data;
  }
}
