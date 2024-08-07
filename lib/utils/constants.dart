import 'package:flutter/material.dart';

class Constants {
  /// PRODUCTION //////////////////////////////////////////////////////////////////////////////////

  // static final String baseUrl = 'https://www.unhbackend.com/AppServices/';
  // static final String baseUrl1 = 'https://unhbackend.com/AppServices/';
  // static final String webUrl =
  //     'https://www.unhbackend.com/Website/aunthenticate-secure-mobile-login';

  /// OLD

  // static final String medicalCenterURL =
  //     'https://medicalcenter.sataware.dev/index.php/wp-json/';
  // static String domain = 'https://medicalcenter.sataware.dev';

  /// NEW

  // static final String medicalCenterURL =
  //     'https://unhbackend.com/wordpress/index.php/wp-json/';
  // static String domain = 'https://unhbackend.com/wordpress';

  /// DEVELOPMENT /////////////////////////////////////////////////////////////////////////////////

  static final String baseUrl = 'https://unhbackend.sataware.dev/AppServices/';
  static final String baseUrl1 = 'https://unhbackend.sataware.dev/AppServices/';
  static final String webUrl =
      'https://unhbackend.sataware.dev/Website/aunthenticate-secure-mobile-login';

  static final String medicalCenterURL =
      'https://unhbackend.sataware.dev/wordpress/index.php/wp-json/';
  static String domain = 'https://unhbackend.sataware.dev/wordpress';

  /// API ////////////////////////////////////////////////////////////////////////////////////////

  /// -------------------- Patient API -------------------- ///

  static final String patientHomePage = 'Patient/userHomepage';
  static final String patientSignUp = 'Patient/signup';
  static final String patientLogin = 'Patient/login';
  static final String deletePatientAccount = 'Patient/deletePatientAcoount';
  static final String patientUpdateProfile = 'Patient/updateProfile';
  static final String getVisitedDoctors = 'Patient/getVisitedDoctors';
  static final String viewResearchDocuments = 'Patient/viewResearchDocuments';
  static final String getSortedPatientChatList = 'Patient/getSortedChatList';
  static final String deleteChatPatient =
      'Patient/delete_all_chat_with_chat_key';
  static final String deleteChatMessagePatient = 'Patient/delete_chat';
  static final String deleteChatDoctor = 'Doctor/delete_all_chat_with_chat_key';
  static final String getAllDoctor = 'Patient/getAllDoctors';
  static final String getAllPatient = 'Doctor/getAllPatients';
  static final String makePayment = 'Patient/appointmentPayment';
  static final String getAllPatientChatList = 'Patient/getAllChatMessages';
  static final String viewResearchDocumentDetails =
      'Patient/viewResearchDocumentDetails';
  static final String getSpecialities = 'Patient/getSpecialities';
  static final String getAppSettingsPatient =
      'Patient/getAppSettingsPagesContent';
  static final String getDoctorBySpecialities =
      'Patient/getDoctorsBySpeciality';

  static final String getDoctorSpecialitiesFilter =
      'Patient/doctorBySpecialityFilter';

  static final String patientContactForm = 'Patient/contactForm';
  static final String patientPinReset = 'Patient/ih_patient_pin';

  /// Appointment
  static final String getPatientAppointment = 'Patient/getDoctorAvailability';
  static final String addPatientAppointment = 'Patient/addPatientAppointment';
  static final String addAppointmentRating = 'Patient/addAppointmentRating';
  static final String getAppointmentRating = 'Patient/getAppointmentRating';
  static final String getSpecificAppointmentDetails =
      'Patient/getSpecificAppointmentDetails';
  static final String cancelAppointmentPatient =
      'Patient/cancelPatientAppointment';
  static final String getPatientPrescriptions =
      'Patient/getPatientPrescriptions';

  /// Notes
  static final String patientNotes = 'Patient/notes';
  static final String getAllPatientNotes = 'Patient/getAllNotes';
  static final String updateDoctorByPatient =
      'Patient/update_doctors_detail_by_patient';
  static final String addDoctorByPatient =
      'Patient/add_doctors_detail_by_patient';
  static final String socialLogin = 'Patient/socialLogin';
  static final String getAllDoctorByLocation =
      'Patient/get_doctors_by_location';
  static final String patientRating = 'Patient/rating';
  static final String createNewMessage = 'Patient/createNewMessage';

  /// --------------------- Doctor API --------------------- ///

  static final String doctorHomePage = 'Doctor/userHomepage';
  static final String doctorSignUp = 'Doctor/signup';
  static final String doctorLogIn = 'Doctor/login';
  static final String doctorUpdateProfile = 'Doctor/updateProfile';
  static final String getVisitedPatient = 'Doctor/getVisitedPatients';
  static final String getDoctorPrescriptions = 'Doctor/getDoctorPrescriptions';
  static final String getAppSettingsDoctor =
      'Doctor/getAppSettingsPagesContent';

  /// Research Documents
  static final String getResearchDocuments = 'Doctor/viewResearchDocuments';
  static final String getResearchDocumentDetails =
      'Doctor/viewResearchDocumentDetails';

  /// Appointment
  static final String getDoctorAppointments = 'Doctor/getDoctorAppointments';
  static final String getDoctorNextAppointment = 'Doctor/getDoctorAppointments';
  static final String cancelAppointmentDoctor =
      'Doctor/cancelPatientAppointment';
  static final String startAppointmentDoctor = 'Doctor/startAppointment';
  static final String doctorCompleteAppointment =
      'Doctor/completePatientAppointment';
  static final String getAppointmentPrescriptions =
      'Doctor/getAppointmentPrescriptions';

  /// Doctor Availability
  static final String getDoctorAvailability = 'Doctor/updateDoctorAvailability';
  static final String multipleDoctorAvailability =
      'Doctor/updateDoctorAvailabilityByRange';
  static final String getDoctorAvailabilityDisplay =
      'Doctor/getDoctorAvailability';
  static final String addPrescription = 'Doctor/addPrescription';

  /// Meeting
  static final String doctorZoomMeeting = 'Doctor/zoom_meeting';
  static final String doctorZoomAction = 'Doctor/zoom_action';
  static final String doctorZoomMeetStatus = 'Doctor/getzoomaction';

  static final String doctorContactForm = 'Doctor/contactForm';
  static final String ihDocPin = 'Doctor/ih_doctor_pin';
  static final String doctorSocialLogin = 'Doctor/socialLogin';
  static final String doctorRating = 'Doctor/rating';

  /// CHAT

  static final String getAllChatMessagesDoctor = 'Doctor/getAllChatMessages';
  static final String getSortedChatListDoctor = 'Doctor/getSortedChatList';
  static final String deleteDoctorMsg = 'Doctor/delete_chat';
  static final String createNewMessageDoctor = 'Doctor/createNewMessage';

  /// --------------------- Common API --------------------- ///

  /// Password Recovery
  static final String forgotPassword = 'PasswordRecovery/intitiateResetRequest';
  static final String initiatePINReset = 'SecurityPINReset/initiatePINReset';

  /// PIN Recovery & Status
  static final String resetPIN = 'SecurityPINReset/initiatePINReset';
  static final String changePIN = 'SecurityPINReset/changeSecurityPIN';
  static final String statusPIN =
      'SecurityPINReset/getUserPINResetRequestStatus';

  /// Login Verification
  static final String loginVerification =
      'SecurityPINReset/userLoginVerification';
  static final String socialLoginVerificationGoogle =
      'SecurityPINReset/userSocialLoginVerification';

  /// Location
  static final String getAllCityByState = 'Location/get_cities_by_state_id';
  static final String getAllStates = 'Location/get_all_states';

  /// Resources
  static final String upcomingEvent = 'Resources/upcoming_event';
  static final String thanksSponser = 'Resources/thank_you_sponser';
  static final String allNewsLetter = 'Resources/all_news_letter';
  static final String healthRecommendation = 'Resources/health_recommendation';
  static final String guidelineOfWho = 'Resources/guideline_of_who';
  static final String allAnnouncement = 'Resources/all_announcement';
  static final String aboutIHApp = 'Resources/about_the_IH_app';
  static final String aboutTheApp = 'Resources/about_the_app';
  static final String aboutAmericanNatives = 'Resources/about_native_american';
  static final String getAllAdvertisement = 'sponser/get_all_advertisement';

  /// Chat
  static final String chatStatus = 'common/chatStatus/';

  /// NET API

  static final String getRoutineHealthReport =
      '${baseUrl1}Patient/getRoutineHealthReport';
  static final String addRoutineHealthReport =
      '${baseUrl1}Patient/addRoutineHealthReport';
  static final String deleteRoutineHealthReport =
      '${baseUrl1}Patient/deleteRoutineHealthReport';
  static final String updateRoutineHealthReport =
      '${baseUrl1}Patient/updateRoutineHealthReport';
  static final String forgotPassword1 = '${baseUrl1}Patient/forgotPassword';
}

const kColorBlue = Color(0xff2e83f8);
const kColorDarkBlue = Color(0xff1b3a5e);

const kInputTextStyle = TextStyle(
    fontSize: 20,
    color: Color(0xffbcbcbc),
    fontWeight: FontWeight.w300,
    fontFamily: 'NunitoSans');

const kColorPrimary = Color(0xff2e83f8);
const kColorPrimaryDark = Color(0xff1b3a5e);

const kTextStyleButton = TextStyle(
    color: kColorPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    fontFamily: 'NunitoSans');

const kTextStyleSubtitle1 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'NunitoSans');

const kTextStyleSubtitle2 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'NunitoSans');

const kTextStyleBody2 = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'NunitoSans');

const kTextStyleHeadline6 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'NunitoSans');

const hintStyle =
    TextStyle(fontSize: 20, color: Color(0xffbcbcbc), fontFamily: 'NunitoSans');
