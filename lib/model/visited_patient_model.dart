import 'api_state_enum.dart';

class VisitedPatientModel {
  String status;
  List<VisitedPatient> visitedPatient;
  String message;
  APIState apiState;

  VisitedPatientModel({this.status, this.visitedPatient, this.message});

  VisitedPatientModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      visitedPatient = <VisitedPatient>[];
      json['data'].forEach((v) {
        visitedPatient.add(new VisitedPatient.fromJson(v));
      });
    }
    if (visitedPatient.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.visitedPatient != null) {
      data['data'] = this.visitedPatient.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class VisitedPatient {
  String id;
  String patientId;
  String doctorId;
  String purposeOfVisit;
  String appointmentDate;
  String appointmentTime;
  String appointmentFor;
  String patientFullName;
  String userMobile;
  String patientMobile;
  String userEmail;
  String appointmentStatus;
  String createdDate;
  String modifiedDate;
  String patientFirstName;
  String patientLastName;
  String patientGender;
  String patientEmail;
  String patientContactNumber;
  String patientBloodGroup;
  String patientMaritalStatus;
  String patientHeight;
  String patientWeight;
  String patientEmergencyContact;
  String patientCaseManager;
  String patientInsuranceEligibility;
  String patientTribalStatus;
  String patientProfilePic;
  String patientSocialPic;
  int prescriptionCount;
  String dob;
  String state;
  String city;
  String appointmentType;
  String appointmentNotes;
  String adminReadStat;
  String appointmentId;
  MeetingData meetingData;
  bool isRejoin;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['doctor_id'] = this.doctorId;
    data['purpose_of_visit'] = this.purposeOfVisit;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['appointment_for'] = this.appointmentFor;
    data['patient_full_name'] = this.patientFullName;
    data['user_mobile'] = this.userMobile;
    data['patient_mobile'] = this.patientMobile;
    data['user_email'] = this.userEmail;
    data['appointment_status'] = this.appointmentStatus;
    data['created_date'] = this.createdDate;
    data['modified_date'] = this.modifiedDate;
    data['patient_first_name'] = this.patientFirstName;
    data['patient_last_name'] = this.patientLastName;
    data['patient_gender'] = this.patientGender;
    data['patient_email'] = this.patientEmail;
    data['patient_contact_number'] = this.patientContactNumber;
    data['patient_blood_group'] = this.patientBloodGroup;
    data['patient_marital_status'] = this.patientMaritalStatus;
    data['patient_height'] = this.patientHeight;
    data['patient_weight'] = this.patientWeight;
    data['patient_emergency_contact'] = this.patientEmergencyContact;
    data['patient_case_manager'] = this.patientCaseManager;
    data['patient_insurance_eligibility'] = this.patientInsuranceEligibility;
    data['patient_tribal_status'] = this.patientTribalStatus;
    data['patient_profile_pic'] = this.patientProfilePic;
    data['prescription_count'] = this.prescriptionCount;
    data['patient_social_profile_pic'] = this.patientSocialPic;
    data['dob'] = this.dob;
    data['state'] = this.state;
    data['city'] = this.city;
    data['appointment_type'] = this.appointmentType;
    data['appointment_notes'] = this.appointmentNotes;
    data['admin_read_stat'] = this.adminReadStat;
    data['appointment_id'] = this.appointmentId;
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
