// To parse this JSON data, do
//
//     final doctorAppointmentsModel = doctorAppointmentsModelFromJson(jsonString);

import 'dart:convert';

import 'api_state_enum.dart';

DoctorAppointmentsModel doctorAppointmentsModelFromJson(String str) =>
    DoctorAppointmentsModel.fromJson(json.decode(str));

String doctorAppointmentsModelToJson(DoctorAppointmentsModel data) =>
    json.encode(data.toJson());

class DoctorAppointmentsModel {
  DoctorAppointmentsModel({
    this.status,
    this.upcoming,
    this.past,
    this.message,
  });

  String status;
  List<PatientAppoint> upcoming;
  List<PatientAppoint> past;
  String message;
  APIState apiState;

  DoctorAppointmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      if (json['data']['upcoming'] != null) {
        upcoming = <PatientAppoint>[];
        json['data']['upcoming'].forEach((v) {
          upcoming.add(new PatientAppoint.fromJson(v));
        });
      }
      if (json['data']['past'] != null) {
        past = <PatientAppoint>[];
        json['data']['past'].forEach((v) {
          past.add(new PatientAppoint.fromJson(v));
        });
      }
    }
    apiState = APIState.COMPLETE;
    message = json['message'];
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": {
          "upcoming": this.upcoming.map((v) => v.toJson()).toList(),
          "past": this.past.map((v) => v.toJson()).toList(),
        },
        "message": message,
      };
}

class Data {
  Data({
    this.upcoming,
    this.past,
  });

  List<PatientAppoint> upcoming;
  List<PatientAppoint> past;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        upcoming: List<PatientAppoint>.from(
            json["upcoming"].map((x) => PatientAppoint.fromJson(x))),
        past: List<PatientAppoint>.from(
            json["past"].map((x) => PatientAppoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "upcoming": List<PatientAppoint>.from(upcoming.map((x) => x.toJson())),
        "past": List<PatientAppoint>.from(past.map((x) => x.toJson())),
      };
}

class PatientAppoint {
  String id;
  String patientId;
  String doctorId;
  String purposeOfVisit;
  String appointmentDate;
  String appointmentId;
  String appointmentTime;
  String appointmentFor;
  String patientFullName;
  String userMobile;
  String patientMobile;
  String userEmail;
  String appointmentStatus;
  String adminReadStat;
  String createdDate;
  String modifiedDate;
  String patientFirstName;
  String patientLastName;
  String patientGender;
  String patientEmail;
  String patientSocialProfilePic;
  String patientProfilePic;
  String patientContactNumber;
  String patientBloodGroup;
  String patientMaritalStatus;
  String patientHeight;
  String patientWeight;
  String patientEmergencyContact;
  String patientCaseManager;
  String patientInsuranceEligibility;
  String patientTribalStatus;
  int prescriptionCount;
  MeetingData meetingData;

  PatientAppoint({
    this.id,
    this.patientId,
    this.doctorId,
    this.purposeOfVisit,
    this.appointmentDate,
    this.appointmentId,
    this.appointmentTime,
    this.appointmentFor,
    this.patientFullName,
    this.userMobile,
    this.meetingData,
    this.patientMobile,
    this.userEmail,
    this.appointmentStatus,
    this.adminReadStat,
    this.createdDate,
    this.modifiedDate,
    this.patientFirstName,
    this.patientLastName,
    this.patientGender,
    this.patientEmail,
    this.patientSocialProfilePic,
    this.patientProfilePic,
    this.patientContactNumber,
    this.patientBloodGroup,
    this.patientMaritalStatus,
    this.patientHeight,
    this.patientWeight,
    this.patientEmergencyContact,
    this.patientCaseManager,
    this.patientInsuranceEligibility,
    this.patientTribalStatus,
    this.prescriptionCount,
  });

  PatientAppoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    purposeOfVisit = json['purpose_of_visit'];
    appointmentDate = json['appointment_date'];
    appointmentId = json['appointment_id'].toString() ?? '';
    appointmentTime = json['appointment_time'];
    appointmentFor = json['appointment_for'];
    patientFullName = json['patient_full_name'];
    userMobile = json['user_mobile'];
    patientMobile = json['patient_mobile'];
    userEmail = json['user_email'];
    appointmentStatus = json['appointment_status'];
    adminReadStat = json['admin_read_stat'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    patientFirstName = json['patient_first_name'];
    patientLastName = json['patient_last_name'];
    patientGender = json['patient_gender'];
    patientEmail = json['patient_email'];
    patientSocialProfilePic = json['patient_social_profile_pic'];
    patientProfilePic = json['patient_profile_pic'];
    patientContactNumber = json['patient_contact_number'];
    patientBloodGroup = json['patient_blood_group'];
    patientMaritalStatus = json['patient_marital_status'];
    patientHeight = json['patient_height'];
    patientWeight = json['patient_weight'];
    patientEmergencyContact = json['patient_emergency_contact'];
    patientCaseManager = json['patient_case_manager'];
    patientInsuranceEligibility = json['patient_insurance_eligibility'];
    patientTribalStatus = json['patient_tribal_status'];
    prescriptionCount = json['prescription_count'] ?? 0;
    meetingData = json["meeting_data"] == null ||
            json["meeting_data"] == [] ||
            json["meeting_data"].isEmpty
        ? null
        : MeetingData.fromJson(json["meeting_data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['purpose_of_visit'] = this.purposeOfVisit;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_id'] = this.appointmentId;
    data['appointment_time'] = this.appointmentTime;
    data['appointment_for'] = this.appointmentFor;
    data['patient_full_name'] = this.patientFullName;
    data['user_mobile'] = this.userMobile;
    data['patient_mobile'] = this.patientMobile;
    data['user_email'] = this.userEmail;
    data['appointment_status'] = this.appointmentStatus;
    data['admin_read_stat'] = this.adminReadStat;
    data['created_date'] = this.createdDate;
    data['modified_date'] = this.modifiedDate;
    data['patient_first_name'] = this.patientFirstName;
    data['patient_last_name'] = this.patientLastName;
    data['patient_gender'] = this.patientGender;
    data['patient_email'] = this.patientEmail;
    data['patient_social_profile_pic'] = this.patientSocialProfilePic;
    data['patient_profile_pic'] = this.patientProfilePic;
    data['patient_contact_number'] = this.patientContactNumber;
    data['patient_blood_group'] = this.patientBloodGroup;
    data['patient_marital_status'] = this.patientMaritalStatus;
    data['patient_height'] = this.patientHeight;
    data['patient_weight'] = this.patientWeight;
    data['patient_emergency_contact'] = this.patientEmergencyContact;
    data['patient_case_manager'] = this.patientCaseManager;
    data['patient_insurance_eligibility'] = this.patientInsuranceEligibility;
    data['patient_tribal_status'] = this.patientTribalStatus;
    data['prescription_count'] = this.prescriptionCount;
    data['meeting_data'] = this.meetingData.toJson();
    return data;
  }
}

class MeetingData {
  String id;
  String password;

  MeetingData({
    this.id,
    this.password,
  });

  factory MeetingData.fromJson(Map<String, dynamic> json) => MeetingData(
        id: json["id"] ?? "",
        password: json["password"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
      };
}
