import 'api_state_enum.dart';

class VisitedPatientModel {
  String? status;
  List<VisitedPatient>? visitedPatient;
  String? message;
  APIState? apiState;

  VisitedPatientModel({this.status, this.visitedPatient, this.message});

  VisitedPatientModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      visitedPatient = <VisitedPatient>[];
      json['data'].forEach((v) {
        visitedPatient?.add(VisitedPatient.fromJson(v));
      });
    }
    if (visitedPatient!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (visitedPatient != null) {
      data['data'] = visitedPatient?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class VisitedPatient {
  String? id;
  String? patientId;
  String? doctorId;
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentFor;
  String? patientFullName;
  String? userMobile;
  String? patientMobile;
  String? userEmail;
  String? appointmentStatus;
  String? createdDate;
  String? modifiedDate;
  String? patientFirstName;
  String? patientLastName;
  String? patientGender;
  String? patientEmail;
  String? patientContactNumber;
  String? patientBloodGroup;
  String? patientMaritalStatus;
  String? patientHeight;
  String? patientWeight;
  String? patientEmergencyContact;
  String? patientCaseManager;
  String? patientInsuranceEligibility;
  String? patientTribalStatus;
  String? patientProfilePic;
  String? patientSocialPic;
  int? prescriptionCount;
  String? dob;
  String? state;
  String? city;
  String? appointmentType;
  String? appointmentNotes;
  String? adminReadStat;
  String? appointmentId;
  MeetingData? meetingData;
  bool? isRejoin;

  VisitedPatient({
    this.id,
    this.patientId,
    this.doctorId,
    this.purposeOfVisit,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentFor,
    this.patientFullName,
    this.userMobile,
    this.patientMobile,
    this.userEmail,
    this.appointmentStatus,
    this.createdDate,
    this.modifiedDate,
    this.patientFirstName,
    this.patientLastName,
    this.patientGender,
    this.isRejoin,
    this.patientEmail,
    this.patientContactNumber,
    this.patientBloodGroup,
    this.patientMaritalStatus,
    this.patientHeight,
    this.patientWeight,
    this.patientEmergencyContact,
    this.patientCaseManager,
    this.patientInsuranceEligibility,
    this.patientTribalStatus,
    this.patientProfilePic,
    this.prescriptionCount,
    this.patientSocialPic,
    this.dob,
    this.state,
    this.meetingData,
    this.city,
    this.appointmentType,
    this.appointmentNotes,
    this.adminReadStat,
    this.appointmentId,
  });

  VisitedPatient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    doctorId = json['doctor_id'];
    purposeOfVisit = json['purpose_of_visit'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    appointmentFor = json['appointment_for'];
    patientFullName = json['patient_full_name'];
    userMobile = json['user_mobile'];
    patientMobile = json['patient_mobile'];
    userEmail = json['user_email'];
    appointmentStatus = json['appointment_status'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    patientFirstName = json['patient_first_name'];
    patientLastName = json['patient_last_name'];
    patientGender = json['patient_gender'];
    patientEmail = json['patient_email'];
    patientContactNumber = json['patient_contact_number'];
    patientBloodGroup = json['patient_blood_group'];
    patientMaritalStatus = json['patient_marital_status'];
    patientHeight = json['patient_height'];
    patientWeight = json['patient_weight'];
    patientEmergencyContact = json['patient_emergency_contact'];
    patientCaseManager = json['patient_case_manager'];
    patientInsuranceEligibility = json['patient_insurance_eligibility'];
    patientTribalStatus = json['patient_tribal_status'];
    patientProfilePic = json['patient_profile_pic'];
    prescriptionCount = json['prescription_count'];
    patientSocialPic = json['patient_social_profile_pic'];
    isRejoin = json['isRejoin'] ?? false;
    dob = json['dob'];
    state = json['state'] ?? '';
    city = json['city'] ?? '';
    appointmentType = json['appointment_type'];
    appointmentNotes = json['appointment_notes'];
    adminReadStat = json['admin_read_stat'];
    appointmentId = json['appointment_id'];
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
    data['appointment_time'] = appointmentTime;
    data['appointment_for'] = appointmentFor;
    data['patient_full_name'] = patientFullName;
    data['user_mobile'] = userMobile;
    data['patient_mobile'] = patientMobile;
    data['user_email'] = userEmail;
    data['appointment_status'] = appointmentStatus;
    data['created_date'] = createdDate;
    data['modified_date'] = modifiedDate;
    data['patient_first_name'] = patientFirstName;
    data['patient_last_name'] = patientLastName;
    data['patient_gender'] = patientGender;
    data['patient_email'] = patientEmail;
    data['patient_contact_number'] = patientContactNumber;
    data['patient_blood_group'] = patientBloodGroup;
    data['patient_marital_status'] = patientMaritalStatus;
    data['patient_height'] = patientHeight;
    data['patient_weight'] = patientWeight;
    data['patient_emergency_contact'] = patientEmergencyContact;
    data['patient_case_manager'] = patientCaseManager;
    data['patient_insurance_eligibility'] = patientInsuranceEligibility;
    data['patient_tribal_status'] = patientTribalStatus;
    data['patient_profile_pic'] = patientProfilePic;
    data['prescription_count'] = prescriptionCount;
    data['patient_social_profile_pic'] = patientSocialPic;
    data['dob'] = dob;
    data['state'] = state;
    data['city'] = city;
    data['appointment_type'] = appointmentType;
    data['appointment_notes'] = appointmentNotes;
    data['admin_read_stat'] = adminReadStat;
    data['appointment_id'] = appointmentId;
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
