import 'package:doctor_appointment_booking/utils/constants.dart';

abstract class BaseService<T> {
  final String baseURL = '${Constants.baseUrl}';
  final String medicalCenterURL = '${Constants.medicalCenterURL}';
  final String addClassURL = 'Doctor/class';
  final String getClassListPatientURL = 'Patient/classes';
  final String getClassListDoctorURL = 'Doctor/classes';
  final String getClassDetailPatientURL = 'Patient/class';
  final String getClassDetailDoctorURL = 'Doctor/class';
  final String editClassURL = 'Doctor/updateclass';
  final String deleteClassURL = 'Doctor/class';
  final String bookWithdrawURL = 'Patient/class';
  final String doctorServicesURL = 'Doctor/services';
  final String patientServicesURL = 'Patient/services';
  final String requestListsURL = 'Patient/requestsCategories';
  final String addRequestURL = 'Patient/request';
  final String allRequestURL = 'Patient/request';
  final String getDirectDoctorURL = 'Patient/getDoctorsDirect';
  final String addDirectAppointmentURL = 'Patient/addDirectAppointment';
  final String roomsURL = 'Doctor/rooms';
  final String addRoomsURL = 'Doctor/rooms';
  final String deleteRoomsURL = 'Doctor/rooms';
  final String addMaintenanceRoomsURL = 'Doctor/rooms_action';
  final String patientLogOutURL = 'Patient/logout';
  final String doctorLogoutURL = 'Doctor/logout';
  final String chatStatusURL = 'common/chatStatus';
  final String newChatMessageURL = 'Doctor/createNewMessage';
  final String allChatMessageURL = 'Doctor/getAllChatMessages';
  final String allChatMessagePatientURL = 'Patient/getAllChatMessages';
  final String getSortedChatListDoctorURL = 'Doctor/getSortedChatList';
  final String getAllDoctorURL = 'Patient/getAllDoctors';
  final String getNotificationListURL = 'common/notifications/';
  final String deleteNotificationURL = 'common/notification/';
  final String deleteAllNotificationURL = 'common/';
  final String getPatientRateURL = 'Patient/rating/';
  final String setRatePatientURL = 'Patient/rating/';
  final String setPersonalMedicationNotesURL =
      'Patient/add_personal_medication_notes';
  final String getPersonalMedicationNotesURL =
      'Patient/get_personal_medication_notes';
  final String deletePersonalMedicationNotesURL =
      'Patient/delete_personal_medication_notes';
  final String updatePersonalMedicationNotesURL =
      'Patient/update_personal_medication_notes';
  final String setRatingForTheDoctorURL = 'Patient/set_rating_for_the_doctor';
  final String getStatesURL = 'Patient/get_states';
  final String getCityURL = 'Patient/get_city';
  final String getMyDoctorListURL = 'Patient/get_doctors_detail_by_patient';
  final String addDoctorURL = 'Patient/add_doctors_detail_by_patient';
  final String deleteMyDoctorNotesURL =
      'Patient/delete_notes_by_id_for_doctors_detail_by_patient';
  final String deleteMyDoctorURL = 'Patient/delete_doctors_detail_by_patient';
  final String updateMyDoctorURL = 'Patient/update_doctors_detail_by_patient';

  final String addVideoConferenceData = 'Patient/addMeetingDetails';
  final String getVideoConferenceData = 'common/getMeetingDetails/';
  final String getIntakeForm =
      'listar/v1/medical-centers-form-heading-list?medical_center_id=';
  final String getUnitedNativesMedicalCenterForm =
      'listar/v1/medical-centers-form?medical_center_id=';
  final String submitUnitedNativesForm = 'listar/v1/medical-centers-form-add';
}

/// 177 API
