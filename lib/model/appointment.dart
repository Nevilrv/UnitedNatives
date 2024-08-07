class Appointment {
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
  String doctorSocialProfilePic;
  String doctorProfilePic;
  String doctorSpeciality;
  String doctorSpecialityID;
  String doctorMobileNumber;
  double doctorRating;
  double ratingByPatient;
  int prescriptionCount;
  String vcStartTime;
  String vcEndTime;
  String vcDuration;

  Appointment(
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
      this.doctorSocialProfilePic,
      this.doctorProfilePic,
      this.doctorSpeciality,
      this.doctorSpecialityID,
      this.doctorMobileNumber,
      this.doctorRating,
      this.ratingByPatient,
      this.prescriptionCount,
      this.vcDuration,
      this.vcEndTime,
      this.vcStartTime});

  Appointment.fromJson(Map<String, dynamic> json) {
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
    doctorSpecialityID = json['speciality_id'];
    vcEndTime = json['vc_end_time'];
    vcDuration = json['vc_duration'];
    vcStartTime = json['vc_start_time'];
    doctorMobileNumber = json['doctor_contact_number'];
    doctorRating = double.parse(json['doctor_rating'] == null ||
            json['doctor_rating'].toString().isEmpty
        ? '0.0'
        : json['doctor_rating'].toString());
    ratingByPatient = double.parse(json['rating_by_patient'] == null ||
            json['rating_by_patient'].toString().isEmpty
        ? '0.0'
        : json['rating_by_patient'].toString());
    prescriptionCount = json['prescription_count'] ?? 0;
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
    data['vc_end_time'] = this.vcEndTime;
    data['vc_duration'] = this.vcDuration;
    data['vc_start_time'] = this.vcStartTime;
    data['doctor_email'] = this.doctorEmail;
    data['doctor_social_profile_pic'] = this.doctorSocialProfilePic;
    data['doctor_profile_pic'] = this.doctorProfilePic;
    data['doctor_speciality'] = this.doctorSpeciality;
    data['speciality_id'] = this.doctorSpecialityID;
    data['doctor_contact_number'] = this.doctorMobileNumber;
    data['doctor_rating'] = this.doctorRating;
    data['rating_by_patient'] = this.ratingByPatient;
    data['prescription_count'] = this.prescriptionCount;
    return data;
  }
}
