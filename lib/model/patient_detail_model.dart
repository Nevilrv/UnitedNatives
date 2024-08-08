import 'dart:convert';

import 'package:united_natives/model/api_state_enum.dart';

PatientDetailsResponseModel patientDetailsResponseModelFromJson(String str) =>
    PatientDetailsResponseModel.fromJson(json.decode(str));

String patientDetailsResponseModelToJson(PatientDetailsResponseModel data) =>
    json.encode(data.toJson());

class PatientDetailsResponseModel {
  String? status;
  List<PatientData>? patientData;
  String? message;
  APIState? apiState;

  PatientDetailsResponseModel({
    this.status,
    this.patientData,
    this.message,
  });

  // factory PatientDetailsResponseModel.fromJson(Map<String, dynamic> json) => PatientDetailsResponseModel(
  //   status: json["status"],
  //   data: List<PatientData>.from(json["data"].map((x) => PatientData.fromJson(x))),
  //   message: json["message"],
  // );
  //
  // Map<String, dynamic> toJson() => {
  //   "status": status,
  //   "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //   "message": message,
  // };

  PatientDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      patientData = <PatientData>[];
      json['data'].forEach((v) {
        patientData?.add(PatientData.fromJson(v));
      });
    }
    if (patientData!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (patientData != null) {
      data['data'] = patientData?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class PatientData {
  String? id;
  String? patientId;
  String? doctorId;
  String? appointmentType;
  String? purposeOfVisit;
  DateTime? appointmentDate;
  String? appointmentTime;
  String? appointmentFor;
  String? patientFullName;
  String? userMobile;
  String? patientMobile;
  String? userEmail;
  String? appointmentNotes;
  String? appointmentStatus;
  String? adminReadStat;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? city;
  String? state;
  String? companyName;
  String? providerName;
  String? faxNumber;
  String? patientFirstName;
  String? patientLastName;
  String? patientGender;
  String? patientEmail;
  String? patientContactNumber;
  String? patientProfilePic;
  dynamic patientSocialProfilePic;
  String? patientBloodGroup;
  String? patientMaritalStatus;
  String? patientHeight;
  String? patientWeight;
  String? patientEmergencyContact;
  String? patientCaseManager;
  String? patientInsuranceEligibility;
  String? patientTribalStatus;
  DateTime? dob;
  String? appointmentId;

  PatientData({
    this.id,
    this.patientId,
    this.doctorId,
    this.appointmentType,
    this.purposeOfVisit,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentFor,
    this.patientFullName,
    this.userMobile,
    this.patientMobile,
    this.userEmail,
    this.appointmentNotes,
    this.appointmentStatus,
    this.adminReadStat,
    this.createdDate,
    this.modifiedDate,
    this.city,
    this.state,
    this.companyName,
    this.providerName,
    this.faxNumber,
    this.patientFirstName,
    this.patientLastName,
    this.patientGender,
    this.patientEmail,
    this.patientContactNumber,
    this.patientProfilePic,
    this.patientSocialProfilePic,
    this.patientBloodGroup,
    this.patientMaritalStatus,
    this.patientHeight,
    this.patientWeight,
    this.patientEmergencyContact,
    this.patientCaseManager,
    this.patientInsuranceEligibility,
    this.patientTribalStatus,
    this.dob,
    this.appointmentId,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) => PatientData(
        id: json["id"],
        patientId: json["patient_id"],
        doctorId: json["doctor_id"],
        appointmentType: json["appointment_type"],
        purposeOfVisit: json["purpose_of_visit"],
        appointmentDate: DateTime.parse(json["appointment_date"]),
        appointmentTime: json["appointment_time"],
        appointmentFor: json["appointment_for"],
        patientFullName: json["patient_full_name"],
        userMobile: json["user_mobile"],
        patientMobile: json["patient_mobile"],
        userEmail: json["user_email"],
        appointmentNotes: json["appointment_notes"],
        appointmentStatus: json["appointment_status"],
        adminReadStat: json["admin_read_stat"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: DateTime.parse(json["modified_date"]),
        city: json["city"],
        state: json["state"],
        companyName: json["company_name"],
        providerName: json["provider_name"],
        faxNumber: json["fax_number"],
        patientFirstName: json["patient_first_name"],
        patientLastName: json["patient_last_name"],
        patientGender: json["patient_gender"],
        patientEmail: json["patient_email"],
        patientContactNumber: json["patient_contact_number"],
        patientProfilePic: json["patient_profile_pic"],
        patientSocialProfilePic: json["patient_social_profile_pic"],
        patientBloodGroup: json["patient_blood_group"],
        patientMaritalStatus: json["patient_marital_status"],
        patientHeight: json["patient_height"],
        patientWeight: json["patient_weight"],
        patientEmergencyContact: json["patient_emergency_contact"],
        patientCaseManager: json["patient_case_manager"],
        patientInsuranceEligibility: json["patient_insurance_eligibility"],
        patientTribalStatus: json["patient_tribal_status"],
        dob: DateTime.parse(json["dob"]),
        appointmentId: json["appointment_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "doctor_id": doctorId,
        "appointment_type": appointmentType,
        "purpose_of_visit": purposeOfVisit,
        "appointment_date":
            "${appointmentDate?.year.toString().padLeft(4, '0')}-${appointmentDate?.month.toString().padLeft(2, '0')}-${appointmentDate?.day.toString().padLeft(2, '0')}",
        "appointment_time": appointmentTime,
        "appointment_for": appointmentFor,
        "patient_full_name": patientFullName,
        "user_mobile": userMobile,
        "patient_mobile": patientMobile,
        "user_email": userEmail,
        "appointment_notes": appointmentNotes,
        "appointment_status": appointmentStatus,
        "admin_read_stat": adminReadStat,
        "created_date": createdDate?.toIso8601String(),
        "modified_date": modifiedDate?.toIso8601String(),
        "city": city,
        "state": state,
        "company_name": companyName,
        "provider_name": providerName,
        "fax_number": faxNumber,
        "patient_first_name": patientFirstName,
        "patient_last_name": patientLastName,
        "patient_gender": patientGender,
        "patient_email": patientEmail,
        "patient_contact_number": patientContactNumber,
        "patient_profile_pic": patientProfilePic,
        "patient_social_profile_pic": patientSocialProfilePic,
        "patient_blood_group": patientBloodGroup,
        "patient_marital_status": patientMaritalStatus,
        "patient_height": patientHeight,
        "patient_weight": patientWeight,
        "patient_emergency_contact": patientEmergencyContact,
        "patient_case_manager": patientCaseManager,
        "patient_insurance_eligibility": patientInsuranceEligibility,
        "patient_tribal_status": patientTribalStatus,
        "dob":
            "${dob?.year.toString().padLeft(4, '0')}-${dob?.month.toString().padLeft(2, '0')}-${dob?.day.toString().padLeft(2, '0')}",
        "appointment_id": appointmentId,
      };
}
