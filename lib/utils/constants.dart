import 'package:flutter/material.dart';

class Constants {
  /// PRODUCTION //////////////////////////////////////////////////////////////////////////////////

  // static const String baseUrl = 'https://www.unhbackend.com/AppServices/';
  // static const String baseUrl1 = 'https://unhbackend.com/AppServices/';
  // static const String webUrl =
  //     'https://www.unhbackend.com/Website/aunthenticate-secure-mobile-login';
  // static const String medicalCenterURL =
  //     'https://unhbackend.com/wordpress/index.php/wp-json/';
  // static String domain = 'https://unhbackend.com/wordpress';

  /// OLD

  // static final String medicalCenterURL =
  //     'https://medicalcenter.sataware.dev/index.php/wp-json/';
  // static String domain = 'https://medicalcenter.sataware.dev';

  /// DEVELOPMENT /////////////////////////////////////////////////////////////////////////////////

  static const String baseUrl = 'https://unhbackend.sataware.dev/AppServices/';
  static const String baseUrl1 = 'https://unhbackend.sataware.dev/AppServices/';
  static const String webUrl =
      'https://unhbackend.sataware.dev/Website/aunthenticate-secure-mobile-login';

  static const String medicalCenterURL =
      'https://unhbackend.sataware.dev/wordpress/index.php/wp-json/';
  static String domain = 'https://unhbackend.sataware.dev/wordpress';

  /// API ////////////////////////////////////////////////////////////////////////////////////////

  /// -------------------- Patient API -------------------- ///

  static const String patientHomePage = 'Patient/userHomepage';
  static const String patientSignUp = 'Patient/signup';
  static const String patientLogin = 'Patient/login';
  static const String deletePatientAccount = 'Patient/deletePatientAcoount';
  static const String patientUpdateProfile = 'Patient/updateProfile';
  static const String getVisitedDoctors = 'Patient/getVisitedDoctors';
  static const String viewResearchDocuments = 'Patient/viewResearchDocuments';
  static const String getSortedPatientChatList = 'Patient/getSortedChatList';
  static const String deleteChatPatient =
      'Patient/delete_all_chat_with_chat_key';
  static const String deleteChatMessagePatient = 'Patient/delete_chat';
  static const String deleteChatDoctor = 'Doctor/delete_all_chat_with_chat_key';
  static const String getAllDoctor = 'Patient/getAllDoctors';
  static const String getAllPatient = 'Doctor/getAllPatients';
  static const String makePayment = 'Patient/appointmentPayment';
  static const String getAllPatientChatList = 'Patient/getAllChatMessages';
  static const String viewResearchDocumentDetails =
      'Patient/viewResearchDocumentDetails';
  static const String getSpecialities = 'Patient/getSpecialities';
  static const String getAppSettingsPatient =
      'Patient/getAppSettingsPagesContent';
  static const String getDoctorBySpecialities =
      'Patient/getDoctorsBySpeciality';

  static const String getDoctorSpecialitiesFilter =
      'Patient/doctorBySpecialityFilter';

  static const String patientContactForm = 'Patient/contactForm';
  static const String patientPinReset = 'Patient/ih_patient_pin';

  /// Appointment
  static const String getPatientAppointment = 'Patient/getDoctorAvailability';
  static const String addPatientAppointment = 'Patient/addPatientAppointment';
  static const String addAppointmentRating = 'Patient/addAppointmentRating';
  static const String getAppointmentRating = 'Patient/getAppointmentRating';
  static const String getSpecificAppointmentDetails =
      'Patient/getSpecificAppointmentDetails';
  static const String cancelAppointmentPatient =
      'Patient/cancelPatientAppointment';
  static const String getPatientPrescriptions =
      'Patient/getPatientPrescriptions';

  /// Notes
  static const String patientNotes = 'Patient/notes';
  static const String getAllPatientNotes = 'Patient/getAllNotes';
  static const String updateDoctorByPatient =
      'Patient/update_doctors_detail_by_patient';
  static const String addDoctorByPatient =
      'Patient/add_doctors_detail_by_patient';
  static const String socialLogin = 'Patient/socialLogin';
  static const String getAllDoctorByLocation =
      'Patient/get_doctors_by_location';
  static const String patientRating = 'Patient/rating';
  static const String createNewMessage = 'Patient/createNewMessage';

  /// --------------------- Doctor API --------------------- ///

  static const String doctorHomePage = 'Doctor/userHomepage';
  static const String doctorSignUp = 'Doctor/signup';
  static const String doctorLogIn = 'Doctor/login';
  static const String doctorUpdateProfile = 'Doctor/updateProfile';
  static const String getVisitedPatient = 'Doctor/getVisitedPatients';
  static const String getDoctorPrescriptions = 'Doctor/getDoctorPrescriptions';
  static const String getAppSettingsDoctor =
      'Doctor/getAppSettingsPagesContent';

  /// Research Documents
  static const String getResearchDocuments = 'Doctor/viewResearchDocuments';
  static const String getResearchDocumentDetails =
      'Doctor/viewResearchDocumentDetails';

  /// Appointment
  static const String getDoctorAppointments = 'Doctor/getDoctorAppointments';
  static const String getDoctorNextAppointment = 'Doctor/getDoctorAppointments';
  static const String cancelAppointmentDoctor =
      'Doctor/cancelPatientAppointment';
  static const String startAppointmentDoctor = 'Doctor/startAppointment';
  static const String doctorCompleteAppointment =
      'Doctor/completePatientAppointment';
  static const String getAppointmentPrescriptions =
      'Doctor/getAppointmentPrescriptions';

  /// Doctor Availability
  static const String getDoctorAvailability = 'Doctor/updateDoctorAvailability';
  static const String multipleDoctorAvailability =
      'Doctor/updateDoctorAvailabilityByRange';
  static const String getDoctorAvailabilityDisplay =
      'Doctor/getDoctorAvailability';
  static const String addPrescription = 'Doctor/addPrescription';

  /// Meeting
  static const String doctorZoomMeeting = 'Doctor/zoom_meeting';
  static const String doctorZoomAction = 'Doctor/zoom_action';
  static const String doctorZoomMeetStatus = 'Doctor/getzoomaction';

  static const String doctorContactForm = 'Doctor/contactForm';
  static const String ihDocPin = 'Doctor/ih_doctor_pin';
  static const String doctorSocialLogin = 'Doctor/socialLogin';
  static const String doctorRating = 'Doctor/rating';

  /// CHAT

  static const String getAllChatMessagesDoctor = 'Doctor/getAllChatMessages';
  static const String getSortedChatListDoctor = 'Doctor/getSortedChatList';
  static const String deleteDoctorMsg = 'Doctor/delete_chat';
  static const String createNewMessageDoctor = 'Doctor/createNewMessage';

  /// --------------------- Common API --------------------- ///

  /// Password Recovery
  static const String forgotPassword = 'PasswordRecovery/intitiateResetRequest';
  static const String initiatePINReset = 'SecurityPINReset/initiatePINReset';

  /// PIN Recovery & Status
  static const String resetPIN = 'SecurityPINReset/initiatePINReset';
  static const String changePIN = 'SecurityPINReset/changeSecurityPIN';
  static const String statusPIN =
      'SecurityPINReset/getUserPINResetRequestStatus';

  /// Login Verification
  static const String loginVerification =
      'SecurityPINReset/userLoginVerification';
  static const String socialLoginVerificationGoogle =
      'SecurityPINReset/userSocialLoginVerification';

  /// ADD SPECIALITY

  static const String addSpeciality = 'Patient/addSpeciality';

  /// Location
  static const String getAllCityByState = 'Location/get_cities_by_state_id';
  static const String getAllStates = 'Location/get_all_states';

  /// Resources
  static const String upcomingEvent = 'Resources/upcoming_event';
  static const String thanksSponser = 'Resources/thank_you_sponser';
  static const String allNewsLetter = 'Resources/all_news_letter';
  static const String healthRecommendation = 'Resources/health_recommendation';
  static const String guidelineOfWho = 'Resources/guideline_of_who';
  static const String allAnnouncement = 'Resources/all_announcement';
  static const String aboutIHApp = 'Resources/about_the_IH_app';
  static const String aboutTheApp = 'Resources/about_the_app';
  static const String aboutAmericanNatives = 'Resources/about_native_american';
  static const String getAllAdvertisement = 'sponser/get_all_advertisement';

  /// Chat
  static const String chatStatus = 'common/chatStatus/';

  /// NET API

  static const String getRoutineHealthReport =
      '${baseUrl1}Patient/getRoutineHealthReport';
  static const String addRoutineHealthReport =
      '${baseUrl1}Patient/addRoutineHealthReport';
  static const String deleteRoutineHealthReport =
      '${baseUrl1}Patient/deleteRoutineHealthReport';
  static const String updateRoutineHealthReport =
      '${baseUrl1}Patient/updateRoutineHealthReport';
  static const String forgotPassword1 = '${baseUrl1}Patient/forgotPassword';
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
  fontSize: 18,
  fontWeight: FontWeight.w400,
  fontFamily: 'NunitoSans',
);

const kTextStyleSubtitle2 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  fontFamily: 'NunitoSans',
);

const kTextStyleBody2 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontFamily: 'NunitoSans',
);

const kTextStyleHeadline6 = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  fontFamily: 'NunitoSans',
);

const hintStyle = TextStyle(
  fontSize: 20,
  color: Color(0xffbcbcbc),
  fontFamily: 'NunitoSans',
);
