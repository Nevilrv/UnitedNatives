class PatientHomePageModel {
  String? status;
  Data? data;
  String? message;

  PatientHomePageModel({this.status, this.data, this.message});

  PatientHomePageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  List<UpcomingAppointments>? upcomingAppointments;
  List<PastAppointments>? pastAppointments;
  List<Prescriptions>? prescriptions = [];
  List<ResearchDocs>? researchDocs;

  Data(
      {this.upcomingAppointments,
      this.pastAppointments,
      this.prescriptions,
      this.researchDocs});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['upcoming_appointments'] != null) {
      upcomingAppointments = <UpcomingAppointments>[];
      json['upcoming_appointments'].forEach((v) {
        upcomingAppointments?.add(UpcomingAppointments.fromJson(v));
      });
    }
    if (json['past_appointments'] != null) {
      pastAppointments = <PastAppointments>[];
      json['past_appointments'].forEach((v) {
        pastAppointments?.add(PastAppointments.fromJson(v));
      });
    }
    if (json['prescriptions'] != null) {
      prescriptions = <Prescriptions>[];
      json['prescriptions'].forEach((v) {
        prescriptions?.add(Prescriptions.fromJson(v));
      });
    }
    if (json['researchDocs'] != null) {
      researchDocs = <ResearchDocs>[];
      json['researchDocs'].forEach((v) {
        researchDocs?.add(ResearchDocs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (upcomingAppointments != null) {
      data['upcoming_appointments'] =
          upcomingAppointments?.map((v) => v.toJson()).toList();
    }
    if (pastAppointments != null) {
      data['past_appointments'] =
          pastAppointments?.map((v) => v.toJson()).toList();
    }
    if (prescriptions != null) {
      data['prescriptions'] = prescriptions?.map((v) => v.toJson()).toList();
    }
    if (researchDocs != null) {
      data['researchDocs'] = researchDocs?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PastAppointments {
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
  String? doctorFirstName;
  String? doctorLastName;
  String? doctorGender;
  String? doctorEmail;
  String? doctorSocialProfilePic;
  String? doctorProfilePic;
  String? doctorSpeciality;
  String? doctorMobileNumber;
  var doctorRating;
  int? prescriptionCount;

  PastAppointments({
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
    this.doctorFirstName,
    this.doctorLastName,
    this.doctorGender,
    this.doctorEmail,
    this.doctorSocialProfilePic,
    this.doctorProfilePic,
    this.doctorSpeciality,
    this.doctorMobileNumber,
    this.doctorRating,
    this.prescriptionCount,
  });

  PastAppointments.fromJson(Map<String, dynamic> json) {
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
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    doctorGender = json['doctor_gender'];
    doctorEmail = json['doctor_email'];
    doctorSocialProfilePic = json['doctor_social_profile_pic'];
    doctorProfilePic = json['doctor_profile_pic'];
    doctorSpeciality = json['doctor_speciality'];
    doctorMobileNumber = json['doctor_contact_number'];
    doctorRating = json['doctor_rating'];
    prescriptionCount = json['prescription_count'];
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
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_last_name'] = doctorLastName;
    data['doctor_gender'] = doctorGender;
    data['doctor_email'] = doctorEmail;
    data['doctor_social_profile_pic'] = doctorSocialProfilePic;
    data['doctor_profile_pic'] = doctorProfilePic;
    data['doctor_speciality'] = doctorSpeciality;
    data['doctor_contact_number'] = doctorMobileNumber;
    data['doctor_rating'] = doctorRating;
    data['prescription_count'] = prescriptionCount;

    return data;
  }
}

class UpcomingAppointments {
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
  String? doctorFirstName;
  String? doctorLastName;
  String? doctorGender;
  String? doctorEmail;
  String? doctorSocialProfilePic;
  String? doctorProfilePic;
  String? doctorSpeciality;
  int? prescriptionCount;
  MeetingData? meetingData;
  String? status;

  UpcomingAppointments({
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
    this.doctorFirstName,
    this.doctorLastName,
    this.doctorGender,
    this.doctorEmail,
    this.doctorSocialProfilePic,
    this.doctorProfilePic,
    this.doctorSpeciality,
    this.prescriptionCount,
    this.meetingData,
    this.status,
  });

  UpcomingAppointments.fromJson(Map<String, dynamic> json) {
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
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    doctorGender = json['doctor_gender'];
    doctorEmail = json['doctor_email'];
    doctorSocialProfilePic = json['doctor_social_profile_pic'];
    doctorProfilePic = json['doctor_profile_pic'];
    doctorSpeciality = json['doctor_speciality'];
    prescriptionCount = json['prescription_count'];
    status = json['status'] ?? "";
    meetingData = json["meeting_data"] == null
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
    data['status'] = status;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_last_name'] = doctorLastName;
    data['doctor_gender'] = doctorGender;
    data['doctor_email'] = doctorEmail;
    data['doctor_social_profile_pic'] = doctorSocialProfilePic;
    data['doctor_profile_pic'] = doctorProfilePic;
    data['doctor_speciality'] = doctorSpeciality;
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

class Prescriptions {
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
  String? doctorSpeciality;
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentFor;
  String? patientFullName;
  String? userMobile;
  String? patientMobile;
  String? userEmail;

  Prescriptions(
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
      this.doctorSpeciality,
      this.purposeOfVisit,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentFor,
      this.patientFullName,
      this.userMobile,
      this.patientMobile,
      this.userEmail});

  Prescriptions.fromJson(Map<String, dynamic> json) {
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

class ResearchDocs {
  String? id;
  String? doctorId;
  String? researchAuthor;
  String? researchTitle;
  String? researchDescription;
  String? researchDocument;
  String? researchDocumentUrl;
  String? researchImage;
  String? researchVideo;
  String? researchVideoUrl;
  String? status;
  String? created;
  String? modified;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['research_author'] = researchAuthor;
    data['research_title'] = researchTitle;
    data['research_description'] = researchDescription;
    data['research_document'] = researchDocument;
    data['research_document_url'] = researchDocumentUrl;
    data['research_image'] = researchImage;
    data['research_video'] = researchVideo;
    data['research_video_url'] = researchVideoUrl;
    data['status'] = status;
    data['created'] = created;
    data['modified'] = modified;
    return data;
  }
}
