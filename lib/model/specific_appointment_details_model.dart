class SpecificAppointmentDetailsModel {
  String status;
  SpecificAppointmentDetailsData specificAppointmentDetailsData;
  String message;

  SpecificAppointmentDetailsModel({this.status, this.specificAppointmentDetailsData, this.message});

  SpecificAppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    specificAppointmentDetailsData = json['data'] != null ? new SpecificAppointmentDetailsData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.specificAppointmentDetailsData != null) {
      data['data'] = this.specificAppointmentDetailsData.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class SpecificAppointmentDetailsData {
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
  String doctorFirstName;
  String doctorLastName;
  String doctorGender;
  String doctorEmail;
  String doctorSpeciality;

  SpecificAppointmentDetailsData(
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
        this.doctorFirstName,
        this.doctorLastName,
        this.doctorGender,
        this.doctorEmail,
        this.doctorSpeciality});

  SpecificAppointmentDetailsData.fromJson(Map<String, dynamic> json) {
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
    doctorSpeciality = json['doctor_speciality'];
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
    data['doctor_first_name'] = this.doctorFirstName;
    data['doctor_last_name'] = this.doctorLastName;
    data['doctor_gender'] = this.doctorGender;
    data['doctor_email'] = this.doctorEmail;
    data['doctor_speciality'] = this.doctorSpeciality;
    return data;
  }
}
