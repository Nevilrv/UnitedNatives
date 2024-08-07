import 'package:doctor_appointment_booking/model/prescription.dart';
import 'package:doctor_appointment_booking/model/visited_patient_model.dart';

class DoctorHomePageModel {
  String status;
  Data data;
  String message;

  DoctorHomePageModel({this.status, this.data, this.message});

  DoctorHomePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<VisitedPatient> upcomingAppointments;
  List<VisitedPatient> pastAppointments;
  List<Prescription> prescriptions;
  List<ResearchDocs> researchDocs;

  Data(
      {this.upcomingAppointments,
      this.pastAppointments,
      this.prescriptions,
      this.researchDocs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['upcoming_appointments'] != null) {
      upcomingAppointments = <VisitedPatient>[];
      json['upcoming_appointments'].forEach((v) {
        upcomingAppointments.add(VisitedPatient.fromJson(v));
      });
    }
    if (json['past_appointments'] != null) {
      pastAppointments = <VisitedPatient>[];
      json['past_appointments'].forEach((v) {
        pastAppointments.add(VisitedPatient.fromJson(v));
      });
    }
    if (json['prescriptions'] != null) {
      prescriptions = <Prescription>[];
      json['prescriptions'].forEach((v) {
        prescriptions.add(new Prescription.fromJson(v));
      });
    }
    if (json['researchDocs'] != null) {
      researchDocs = <ResearchDocs>[];
      json['researchDocs'].forEach((v) {
        researchDocs.add(new ResearchDocs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upcomingAppointments != null) {
      data['upcoming_appointments'] =
          this.upcomingAppointments.map((v) => v.toJson()).toList();
    }
    if (this.pastAppointments != null) {
      data['past_appointments'] =
          this.pastAppointments.map((v) => v.toJson()).toList();
    }
    if (this.prescriptions != null) {
      data['prescriptions'] =
          this.prescriptions.map((v) => v.toJson()).toList();
    }
    if (this.researchDocs != null) {
      data['researchDocs'] = this.researchDocs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
//
// class UpcomingAppointmentsDoctor {
//   String id;
//   String patientId;
//   String doctorId;
//   String purposeOfVisit;
//   String appointmentDate;
//   String appointmentTime;
//   String appointmentFor;
//   String patientFullName;
//   String userMobile;
//   String patientMobile;
//   String userEmail;
//   String appointmentStatus;
//   String createdDate;
//   String modifiedDate;
//   String patientFirstName;
//   String patientLastName;
//   String patientGender;
//   String patientEmail;
//   String patientContactNumber;
//   String patientBloodGroup;
//   String patientMaritalStatus;
//   String patientHeight;
//   String patientWeight;
//   String patientEmergencyContact;
//   String patientCaseManager;
//   String patientInsuranceEligibility;
//   String patientTribalStatus;
//   String patientProfilePic;
//   int prescriptionCount;
//
//   UpcomingAppointmentsDoctor({
//     this.id,
//     this.patientId,
//     this.doctorId,
//     this.purposeOfVisit,
//     this.appointmentDate,
//     this.appointmentTime,
//     this.appointmentFor,
//     this.patientFullName,
//     this.userMobile,
//     this.patientMobile,
//     this.userEmail,
//     this.appointmentStatus,
//     this.createdDate,
//     this.modifiedDate,
//     this.patientFirstName,
//     this.patientLastName,
//     this.patientGender,
//     this.patientEmail,
//     this.patientContactNumber,
//     this.patientBloodGroup,
//     this.patientMaritalStatus,
//     this.patientHeight,
//     this.patientWeight,
//     this.patientEmergencyContact,
//     this.patientCaseManager,
//     this.patientInsuranceEligibility,
//     this.patientTribalStatus,
//     this.patientProfilePic,
//     this.prescriptionCount
//   });
//
//   UpcomingAppointmentsDoctor.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     patientId = json['patient_id'];
//     doctorId = json['doctor_id'];
//     purposeOfVisit = json['purpose_of_visit'];
//     appointmentDate = json['appointment_date'];
//     appointmentTime = json['appointment_time'];
//     appointmentFor = json['appointment_for'];
//     patientFullName = json['patient_full_name'];
//     userMobile = json['user_mobile'];
//     patientMobile = json['patient_mobile'];
//     userEmail = json['user_email'];
//     appointmentStatus = json['appointment_status'];
//     createdDate = json['created_date'];
//     modifiedDate = json['modified_date'];
//     patientFirstName = json['patient_first_name'];
//     patientLastName = json['patient_last_name'];
//     patientGender = json['patient_gender'];
//     patientEmail = json['patient_email'];
//     patientContactNumber = json['patient_contact_number'];
//     patientBloodGroup = json['patient_blood_group'];
//     patientMaritalStatus = json['patient_marital_status'];
//     patientHeight = json['patient_height'];
//     patientWeight = json['patient_weight'];
//     patientEmergencyContact = json['patient_emergency_contact'];
//     patientCaseManager = json['patient_case_manager'];
//     patientInsuranceEligibility = json['patient_insurance_eligibility'];
//     patientTribalStatus = json['patient_tribal_status'];
//     patientProfilePic = json['patient_profile_pic'];
//     prescriptionCount = json['prescription_count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['patient_id'] = this.patientId;
//     data['doctor_id'] = this.doctorId;
//     data['purpose_of_visit'] = this.purposeOfVisit;
//     data['appointment_date'] = this.appointmentDate;
//     data['appointment_time'] = this.appointmentTime;
//     data['appointment_for'] = this.appointmentFor;
//     data['patient_full_name'] = this.patientFullName;
//     data['user_mobile'] = this.userMobile;
//     data['patient_mobile'] = this.patientMobile;
//     data['user_email'] = this.userEmail;
//     data['appointment_status'] = this.appointmentStatus;
//     data['created_date'] = this.createdDate;
//     data['modified_date'] = this.modifiedDate;
//     data['patient_first_name'] = this.patientFirstName;
//     data['patient_last_name'] = this.patientLastName;
//     data['patient_gender'] = this.patientGender;
//     data['patient_email'] = this.patientEmail;
//     data['patient_contact_number'] = this.patientContactNumber;
//     data['patient_blood_group'] = this.patientBloodGroup;
//     data['patient_marital_status'] = this.patientMaritalStatus;
//     data['patient_height'] = this.patientHeight;
//     data['patient_weight'] = this.patientWeight;
//     data['patient_emergency_contact'] = this.patientEmergencyContact;
//     data['patient_case_manager'] = this.patientCaseManager;
//     data['patient_insurance_eligibility'] = this.patientInsuranceEligibility;
//     data['patient_tribal_status'] = this.patientTribalStatus;
//     data['patient_profile_pic'] = this.patientProfilePic;
//     data['prescription_count'] = this.prescriptionCount;
//     return data;
//   }
// }
//
// class PastAppointmentsDoctor {
//   String id;
//   String patientId;
//   String doctorId;
//   String purposeOfVisit;
//   String appointmentDate;
//   String appointmentTime;
//   String appointmentFor;
//   String patientFullName;
//   String userMobile;
//   String patientMobile;
//   String userEmail;
//   String appointmentStatus;
//   String createdDate;
//   String modifiedDate;
//   String patientFirstName;
//   String patientLastName;
//   String patientGender;
//   String patientEmail;
//   String patientContactNumber;
//   String patientBloodGroup;
//   String patientMaritalStatus;
//   String patientHeight;
//   String patientWeight;
//   String patientEmergencyContact;
//   String patientCaseManager;
//   String patientInsuranceEligibility;
//   String patientTribalStatus;
//   String patientProfilePic;
//
//   PastAppointmentsDoctor({
//     this.id,
//     this.patientId,
//     this.doctorId,
//     this.purposeOfVisit,
//     this.appointmentDate,
//     this.appointmentTime,
//     this.appointmentFor,
//     this.patientFullName,
//     this.userMobile,
//     this.patientMobile,
//     this.userEmail,
//     this.appointmentStatus,
//     this.createdDate,
//     this.modifiedDate,
//     this.patientFirstName,
//     this.patientLastName,
//     this.patientGender,
//     this.patientEmail,
//     this.patientContactNumber,
//     this.patientBloodGroup,
//     this.patientMaritalStatus,
//     this.patientHeight,
//     this.patientWeight,
//     this.patientEmergencyContact,
//     this.patientCaseManager,
//     this.patientInsuranceEligibility,
//     this.patientTribalStatus,
//     this.patientProfilePic,
//   });
//
//   PastAppointmentsDoctor.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     patientId = json['patient_id'];
//     doctorId = json['doctor_id'];
//     purposeOfVisit = json['purpose_of_visit'];
//     appointmentDate = json['appointment_date'];
//     appointmentTime = json['appointment_time'];
//     appointmentFor = json['appointment_for'];
//     patientFullName = json['patient_full_name'];
//     userMobile = json['user_mobile'];
//     patientMobile = json['patient_mobile'];
//     userEmail = json['user_email'];
//     appointmentStatus = json['appointment_status'];
//     createdDate = json['created_date'];
//     modifiedDate = json['modified_date'];
//     patientFirstName = json['patient_first_name'];
//     patientLastName = json['patient_last_name'];
//     patientGender = json['patient_gender'];
//     patientEmail = json['patient_email'];
//     patientContactNumber = json['patient_contact_number'];
//     patientBloodGroup = json['patient_blood_group'];
//     patientMaritalStatus = json['patient_marital_status'];
//     patientHeight = json['patient_height'];
//     patientWeight = json['patient_weight'];
//     patientEmergencyContact = json['patient_emergency_contact'];
//     patientCaseManager = json['patient_case_manager'];
//     patientInsuranceEligibility = json['patient_insurance_eligibility'];
//     patientTribalStatus = json['patient_tribal_status'];
//     patientProfilePic = json['patient_profile_pic'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['patient_id'] = this.patientId;
//     data['doctor_id'] = this.doctorId;
//     data['purpose_of_visit'] = this.purposeOfVisit;
//     data['appointment_date'] = this.appointmentDate;
//     data['appointment_time'] = this.appointmentTime;
//     data['appointment_for'] = this.appointmentFor;
//     data['patient_full_name'] = this.patientFullName;
//     data['user_mobile'] = this.userMobile;
//     data['patient_mobile'] = this.patientMobile;
//     data['user_email'] = this.userEmail;
//     data['appointment_status'] = this.appointmentStatus;
//     data['created_date'] = this.createdDate;
//     data['modified_date'] = this.modifiedDate;
//     data['patient_first_name'] = this.patientFirstName;
//     data['patient_last_name'] = this.patientLastName;
//     data['patient_gender'] = this.patientGender;
//     data['patient_email'] = this.patientEmail;
//     data['patient_contact_number'] = this.patientContactNumber;
//     data['patient_blood_group'] = this.patientBloodGroup;
//     data['patient_marital_status'] = this.patientMaritalStatus;
//     data['patient_height'] = this.patientHeight;
//     data['patient_weight'] = this.patientWeight;
//     data['patient_emergency_contact'] = this.patientEmergencyContact;
//     data['patient_case_manager'] = this.patientCaseManager;
//     data['patient_insurance_eligibility'] = this.patientInsuranceEligibility;
//     data['patient_tribal_status'] = this.patientTribalStatus;
//     data['patient_profile_pic'] = this.patientProfilePic;
//     return data;
//   }
// }

class ResearchDocs {
  String id;
  String doctorId;
  String researchAuthor;
  String researchTitle;
  String researchDescription;
  String researchDocument;
  String researchDocumentUrl;
  String researchImage;
  String researchVideo;
  String researchVideoUrl;
  String status;
  String created;
  String modified;

  ResearchDocs(
      {this.id,
      this.doctorId,
      this.researchAuthor,
      this.researchTitle,
      this.researchDescription,
      this.researchDocument,
      this.researchDocumentUrl,
      this.researchImage,
      this.researchVideo,
      this.researchVideoUrl,
      this.status,
      this.created,
      this.modified});

  ResearchDocs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    researchAuthor = json['research_author'];
    researchTitle = json['research_title'];
    researchDescription = json['research_description'];
    researchDocument = json['research_document'];
    researchDocumentUrl = json['research_document_url'];
    researchImage = json['research_image'];
    researchVideo = json['research_video'];
    researchVideoUrl = json['research_video_url'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['research_author'] = this.researchAuthor;
    data['research_title'] = this.researchTitle;
    data['research_description'] = this.researchDescription;
    data['research_document'] = this.researchDocument;
    data['research_document_url'] = this.researchDocumentUrl;
    data['research_image'] = this.researchImage;
    data['research_video'] = this.researchVideo;
    data['research_video_url'] = this.researchVideoUrl;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}
