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

  String? status;
  List<PatientAppoint>? upcoming;
  List<PatientAppoint>? past;
  String? message;
  APIState? apiState;

  DoctorAppointmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      if (json['data']['upcoming'] != null) {
        upcoming = <PatientAppoint>[];
        json['data']['upcoming'].forEach((v) {
          upcoming?.add(PatientAppoint.fromJson(v));
        });
      }
      if (json['data']['past'] != null) {
        past = <PatientAppoint>[];
        json['data']['past'].forEach((v) {
          past?.add(PatientAppoint.fromJson(v));
        });
      }
    }
    apiState = APIState.COMPLETE;
    message = json['message'];
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": {
          "upcoming": upcoming?.map((v) => v.toJson()).toList(),
          "past": past?.map((v) => v.toJson()).toList(),
        },
        "message": message,
      };
}

class Data {
  Data({
    this.upcoming,
    this.past,
  });

  List<PatientAppoint>? upcoming;
  List<PatientAppoint>? past;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        upcoming: List<PatientAppoint>.from(
            json["upcoming"].map((x) => PatientAppoint.fromJson(x))),
        past: List<PatientAppoint>.from(
            json["past"].map((x) => PatientAppoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "upcoming": List<PatientAppoint>.from(upcoming!.map((x) => x.toJson())),
        "past": List<PatientAppoint>.from(past!.map((x) => x.toJson())),
      };
}

class PatientAppoint {
  String? id;
  String? patientId;
  String? doctorId;
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentId;
  String? appointmentTime;
  String? appointmentFor;
  String? patientFullName;
  String? userMobile;
  String? patientMobile;
  String? userEmail;
  String? appointmentStatus;
  String? adminReadStat;
  String? createdDate;
  String? modifiedDate;
  String? patientFirstName;
  String? patientLastName;
  String? patientGender;
  String? patientEmail;
  String? patientSocialProfilePic;
  String? patientProfilePic;
  String? patientContactNumber;
  String? patientBloodGroup;
  String? patientMaritalStatus;
  String? patientHeight;
  String? patientWeight;
  String? patientEmergencyContact;
  String? patientCaseManager;
  String? patientInsuranceEligibility;
  String? patientTribalStatus;
  int? prescriptionCount;
  MeetingData? meetingData;

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
    appointmentId = json['appointment_id'].toString();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['doctor_id'] = doctorId;
    data['purpose_of_visit'] = purposeOfVisit;
    data['appointment_date'] = appointmentDate;
    data['appointment_id'] = appointmentId;
    data['appointment_time'] = appointmentTime;
    data['appointment_for'] = appointmentFor;
    data['patient_full_name'] = patientFullName;
    data['user_mobile'] = userMobile;
    data['patient_mobile'] = patientMobile;
    data['user_email'] = userEmail;
    data['appointment_status'] = appointmentStatus;
    data['admin_read_stat'] = adminReadStat;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['patient_first_name'] = patientFirstName;
    data['patient_last_name'] = patientLastName;
    data['patient_gender'] = patientGender;
    data['patient_email'] = patientEmail;
    data['patient_social_profile_pic'] = patientSocialProfilePic;
    data['patient_profile_pic'] = patientProfilePic;
    data['patient_contact_number'] = patientContactNumber;
    data['patient_blood_group'] = patientBloodGroup;
    data['patient_marital_status'] = patientMaritalStatus;
    data['patient_height'] = patientHeight;
    data['patient_weight'] = patientWeight;
    data['patient_emergency_contact'] = patientEmergencyContact;
    data['patient_case_manager'] = patientCaseManager;
    data['patient_insurance_eligibility'] = patientInsuranceEligibility;
    data['patient_tribal_status'] = patientTribalStatus;
    data['prescription_count'] = prescriptionCount;
    data['meeting_data'] = meetingData?.toJson();
    return data;
  }
}

class MeetingData {
  String? id;
  String? password;

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
