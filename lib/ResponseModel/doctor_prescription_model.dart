import 'api_state_enum.dart';

class DoctorPrescriptionModel {
  String? status;
  List<DoctorPrescription>? doctorPrescription;
  String? message;
  APIState? apiState;

  DoctorPrescriptionModel({this.status, this.doctorPrescription, this.message});

  DoctorPrescriptionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      doctorPrescription = <DoctorPrescription>[];
      json['data'].forEach((v) {
        doctorPrescription?.add(DoctorPrescription.fromJson(v));
      });
    }
    if (doctorPrescription!.isEmpty) {
      apiState = APIState.COMPLETE_WITH_NO_DATA;
    } else {
      apiState = APIState.COMPLETE;
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (doctorPrescription != null) {
      data['data'] = doctorPrescription?.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class DoctorPrescription {
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
  String? purposeOfVisit;
  String? appointmentDate;
  String? appointmentTime;
  String? appointmentPatientFullName;
  String? patientFirstName;
  String? patientLastName;
  String? pationtImage;

  DoctorPrescription(
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
      this.purposeOfVisit,
      this.appointmentDate,
      this.appointmentTime,
      this.appointmentPatientFullName,
      this.patientFirstName,
      this.patientLastName,
      this.pationtImage});

  DoctorPrescription.fromJson(Map<String, dynamic> json) {
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
    purposeOfVisit = json['purpose_of_visit'];
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    appointmentPatientFullName = json['appointment_patient_full_name'];
    patientFirstName = json['patient_first_name'];
    patientLastName = json['patient_last_name'];
    pationtImage = json['patient_profile_pic'];
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
    data['purpose_of_visit'] = purposeOfVisit;
    data['appointment_date'] = appointmentDate;
    data['appointment_time'] = appointmentTime;
    data['appointment_patient_full_name'] = appointmentPatientFullName;
    data['patient_first_name'] = patientFirstName;
    data['patient_last_name'] = patientLastName;
    data['patient_profile_pic'] = pationtImage;
    return data;
  }
}
