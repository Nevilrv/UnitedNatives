import 'api_state_enum.dart';

class PatientPrescriptionsModel {
  String? status;
  List<Data>? data;
  String? message;
  APIState? apiState;

  PatientPrescriptionsModel({this.status, this.data, this.message});

  PatientPrescriptionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    if (data!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
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
  String? doctorId;
  String? patientId;
  String? appointmentId;
  String? medicineName;
  String? medicineRoutine;
  String? additionalNotes;
  String? treatmentDays;
  String? pillsPerDay;
  String? created;
  String? modified;
  String? doctorName;
  String? doctorProfilePic;
  String? doctorSpeciality;
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentFor;
  String? patientFullName;
  String? userMobile;
  String? patientMobile;
  String? userEmail;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['patient_id'] = patientId;
    data['appointment_id'] = appointmentId;
    data['medicine_name'] = medicineName;
    data['medicine_routine'] = medicineRoutine;
    data['additional_notes'] = additionalNotes;
    data['treatment_days'] = treatmentDays;
    data['pills_per_day'] = pillsPerDay;
    data['created'] = created;
    data['modified'] = modified;
    data['doctor_name'] = doctorName;
    data['doctor_profile_pic'] = doctorProfilePic;
    data['doctor_speciality'] = doctorSpeciality;
    data['purpose_of_visit'] = purposeOfVisit;
    data['appointment_date'] = appointmentDate;
    data['appointment_time'] = appointmentTime;
    data['appointment_for'] = appointmentFor;
    data['patient_full_name'] = patientFullName;
    data['user_mobile'] = userMobile;
    data['patient_mobile'] = patientMobile;
    data['user_email'] = userEmail;
    return data;
  }
}
