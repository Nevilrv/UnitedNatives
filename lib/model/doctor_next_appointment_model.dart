class DoctorNextAppointmentModel {
  String status;
  DoctorNextAppointment doctorNextAppointment;
  String message;

  DoctorNextAppointmentModel(
      {this.status, this.doctorNextAppointment, this.message});

  DoctorNextAppointmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    doctorNextAppointment = json['data'] != null
        ? new DoctorNextAppointment.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.doctorNextAppointment != null) {
      data['data'] = this.doctorNextAppointment.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class DoctorNextAppointment {
  List<DoctorNextAppointment> upcoming;
  List<Past> past;

  DoctorNextAppointment({this.upcoming, this.past});

  DoctorNextAppointment.fromJson(Map<String, dynamic> json) {
    if (json['upcoming'] != null) {
      upcoming = <DoctorNextAppointment>[];
      json['upcoming'].forEach((v) {
        upcoming.add(new DoctorNextAppointment.fromJson(v));
      });
    }
    if (json['past'] != null) {
      past = <Past>[];
      json['past'].forEach((v) {
        past.add(new Past.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.upcoming != null) {
      data['upcoming'] = this.upcoming.map((v) => v.toJson()).toList();
    }
    if (this.past != null) {
      data['past'] = this.past.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Past {
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
    return data;
  }
}
