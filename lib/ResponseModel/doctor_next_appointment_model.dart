class DoctorNextAppointmentModel {
  String? status;
  DoctorNextAppointment? doctorNextAppointment;
  String? message;

  DoctorNextAppointmentModel(
      {this.status, this.doctorNextAppointment, this.message});

  DoctorNextAppointmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    doctorNextAppointment = json['data'] != null
        ? DoctorNextAppointment.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (doctorNextAppointment != null) {
      data['data'] = doctorNextAppointment?.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class DoctorNextAppointment {
  List<DoctorNextAppointment>? upcoming;
  List<Past>? past;

  DoctorNextAppointment({this.upcoming, this.past});

  DoctorNextAppointment.fromJson(Map<String, dynamic> json) {
    if (json['upcoming'] != null) {
      upcoming = <DoctorNextAppointment>[];
      json['upcoming'].forEach((v) {
        upcoming?.add(DoctorNextAppointment.fromJson(v));
      });
    }
    if (json['past'] != null) {
      past = <Past>[];
      json['past'].forEach((v) {
        past?.add(Past.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (upcoming != null) {
      data['upcoming'] = upcoming?.map((v) => v.toJson()).toList();
    }
    if (past != null) {
      data['past'] = past?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Past {
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

  Past(
      {this.id,
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
      this.patientEmail,
      this.patientContactNumber,
      this.patientBloodGroup,
      this.patientMaritalStatus,
      this.patientHeight,
      this.patientWeight,
      this.patientEmergencyContact,
      this.patientCaseManager,
      this.patientInsuranceEligibility,
      this.patientTribalStatus});

  Past.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
