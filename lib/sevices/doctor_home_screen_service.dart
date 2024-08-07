import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:united_natives/model/aboutus_privacy_policy_doctor_model.dart';
import 'package:united_natives/model/add_prescription_model.dart';
import 'package:united_natives/model/cancle_appointment_doctor.dart';
import 'package:united_natives/model/delete_chat_messages_response_model.dart';
import 'package:united_natives/model/doctor_availability_display_model.dart';
import 'package:united_natives/model/doctor_availability_model.dart';
import 'package:united_natives/model/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/model/doctor_homepage_model.dart';
import 'package:united_natives/model/doctor_multiple_availability_model.dart';
import 'package:united_natives/model/doctor_next_appointment_model.dart';
import 'package:united_natives/model/doctor_prescription_model.dart';
import 'package:united_natives/model/doctor_research_document_details_model.dart';
import 'package:united_natives/model/doctor_research_document_model.dart';
import 'package:united_natives/model/get_all_chat_messeage_doctor.dart';
import 'package:united_natives/model/get_all_patient_response_model.dart';
import 'package:united_natives/model/get_new_message_doctor_model.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/model/patient_detail_model.dart';
import 'package:united_natives/model/start_appointment_doctor.dart';
import 'package:united_natives/model/visited_patient_model.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/network_util.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';

class DoctorHomeScreenService {
  static final DoctorHomeScreenService _authService =
      DoctorHomeScreenService._init();

  factory DoctorHomeScreenService() {
    return _authService;
  }

  DoctorHomeScreenService._init();

  final NetworkAPICall _networkAPICall = NetworkAPICall();

  static const BANNER_TOKEN = '43b2fe6fb2cd47eb049520a9f5d94905';

  // Map<String, String> headers = {
  //   "Authorization": 'Bearer ${Config.getHeaders()}',
  //   "Content-Type": 'application/json',
  // };

  ///***** DoctorHome Page API *****

  Future<DoctorHomePageModel> doctorHomePage(
      {required String userId, bearerToken}) async {
    DoctorHomePageModel doctorHomePageModelData = DoctorHomePageModel();
    var body = jsonEncode({"user_id": userId});
    try {
      var result = await _networkAPICall.post(Constants.doctorHomePage, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorHomePageModelData = DoctorHomePageModel.fromJson(result);
      } else {
        // doctorHomePageModelData = null;
      }

      // await AppPreference().saveCustomerData(customerData);
      return doctorHomePageModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Doctor Availability Display API *****
  Future<DoctorAvailabilityForDisplayOnlyModel> doctorAvailabilityDisplay(
      {required String doctorId, availabilityDate}) async {
    DoctorAvailabilityForDisplayOnlyModel
        doctorAvailabilityForDisplayOnlyModelData =
        DoctorAvailabilityForDisplayOnlyModel();
    var body = jsonEncode(
        {"doctor_id": doctorId, "availability_date": availabilityDate});
    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorAvailabilityDisplay, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorAvailabilityForDisplayOnlyModelData =
            DoctorAvailabilityForDisplayOnlyModel.fromJson(result);
      } else {
        // doctorHomePageModelData = null;
      }

      // await AppPreference().saveCustomerData(customerData);
      return doctorAvailabilityForDisplayOnlyModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future<AddPrescriptionModel> addPrescription(
      {required String doctorId,
      patientId,
      appointmentId,
      medicineName,
      whenToTake,
      additionalNotes,
      daysOfTreat,
      pillsPerDay}) async {
    AddPrescriptionModel addPrescriptionData = AddPrescriptionModel();
    var body = jsonEncode({
      "doctor_id": doctorId,
      "patient_id": patientId,
      "appointment_id": appointmentId,
      "medicine_name": medicineName,
      "when_to_take": whenToTake,
      "additional_notes": additionalNotes,
      "days_of_treatment": daysOfTreat,
      "pills_per_day": pillsPerDay
    });
    try {
      var result = await _networkAPICall.post(Constants.addPrescription, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        addPrescriptionData = AddPrescriptionModel.fromJson(result);
      } else {
        // doctorHomePageModelData = null;
      }

      // await AppPreference().saveCustomerData(customerData);
      return addPrescriptionData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  // ///***** visited Patient API *****

  Future<VisitedPatientModel> getVisitedPatient(
      {String doctorId = '', String patientId = ''}) async {
    VisitedPatientModel visitedPatientModelData = VisitedPatientModel();
    var body = jsonEncode({"doctor_id": doctorId, "patient_id": patientId});
    try {
      var result = await _networkAPICall.post('Doctor/getVisitedPatients', body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        visitedPatientModelData = VisitedPatientModel.fromJson(result);
      } else {
        visitedPatientModelData = VisitedPatientModel();
      }

      return visitedPatientModelData;
    } catch (e, stackTrace) {
      throw AppException.exceptionHandler(e, stackTrace);
    }
  }

  Future<PatientDetailsResponseModel> getPatientDetails(
      {required String doctorId}) async {
    PatientDetailsResponseModel patientDetailsResponseModel =
        PatientDetailsResponseModel();
    var body = jsonEncode({"doctor_id": doctorId});
    try {
      var result = await _networkAPICall.post('Doctor/getlPatientDetail', body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        patientDetailsResponseModel =
            PatientDetailsResponseModel.fromJson(result);
      } else {
        patientDetailsResponseModel = PatientDetailsResponseModel();
      }

      return patientDetailsResponseModel;
    } catch (e, stackTrace) {
      throw AppException.exceptionHandler(e, stackTrace);
    }
  }

  ///***** PatientPrescription API *****

  Future<DoctorPrescriptionModel> doctorPrescriptionsModel(
      {required String doctorId,
      String patientId = '',
      String appointmentId = ''}) async {
    DoctorPrescriptionModel doctorPrescriptionsModelData =
        DoctorPrescriptionModel();
    var body = jsonEncode(({
      "doctor_id": doctorId,
      "patient_id": patientId,
      "appointment_id": appointmentId
    }));

    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorPrescriptions, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorPrescriptionsModelData = DoctorPrescriptionModel.fromJson(result);
      } else {
        doctorPrescriptionsModelData = DoctorPrescriptionModel();
      }
      return doctorPrescriptionsModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** GetAllPatient API *****

  Future<GetAllPatient> getAllPatient({required String doctorId}) async {
    GetAllPatient getAllPatient = GetAllPatient();
    var body = jsonEncode(({"doctor_id": doctorId}));

    try {
      var result = await _networkAPICall.post(Constants.getAllPatient, body,
          header: Config.getHeaders());

      getAllPatient = GetAllPatient.fromJson(result);
      return getAllPatient;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Research Document API *****

  Future<DoctorResearchDocumentModel> doctorResearchDocumentModel(
      {required String userId}) async {
    DoctorResearchDocumentModel doctorResearchDocumentModelData =
        DoctorResearchDocumentModel();
    var body = jsonEncode(({"user_id": userId}));

    try {
      var result = await _networkAPICall.post(
          Constants.getResearchDocuments, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorResearchDocumentModelData =
            DoctorResearchDocumentModel.fromJson(result);
      } else {
        doctorResearchDocumentModelData = DoctorResearchDocumentModel();
      }
      return doctorResearchDocumentModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Appointment Cancel API *****

  Future<CancelAppointmentDoctor> cancelAppointmentDoctor(
      {required String userId, appointmentId}) async {
    var body =
        jsonEncode(({"user_id": userId, "appointment_id": appointmentId}));
    log('body==========>>>>>$body');
    try {
      var result = await _networkAPICall.post(
          Constants.cancelAppointmentDoctor, body,
          header: Config.getHeaders());
      CancelAppointmentDoctor cancelAppointmentDoctorData =
          CancelAppointmentDoctor();
      cancelAppointmentDoctorData = CancelAppointmentDoctor.fromJson(result);
      return cancelAppointmentDoctorData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Appointment Start API *****

  Future<StartAppointmentDoctor> startAppointmentDoctor(
      {required String doctorId, appointmentId}) async {
    var body =
        jsonEncode(({"doctor_id": doctorId, "appointment_id": appointmentId}));

    try {
      var result = await _networkAPICall.post(
        Constants.startAppointmentDoctor,
        body,
        header: Config.getHeaders(),
      );
      StartAppointmentDoctor startAppointmentDoctorData =
          StartAppointmentDoctor();
      startAppointmentDoctorData = StartAppointmentDoctor.fromJson(result);
      return startAppointmentDoctorData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Reseach Document Details API *****

  Future<DoctorResearchDocumentDetailsModel> doctorResearchDocumentDetailsModel(
      {required String userId, documentId}) async {
    DoctorResearchDocumentDetailsModel researchDocumentDetailsModelData =
        DoctorResearchDocumentDetailsModel();
    var body = jsonEncode(({"user_id": userId, "document_id": documentId}));

    try {
      var result = await _networkAPICall.post(
          Constants.getResearchDocumentDetails, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        researchDocumentDetailsModelData =
            DoctorResearchDocumentDetailsModel.fromJson(result);
      } else {
        researchDocumentDetailsModelData = DoctorResearchDocumentDetailsModel();
      }
      return researchDocumentDetailsModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Next Appointment API *****

  Future<DoctorNextAppointmentModel> doctorNextAppointmentModel(
      {required String doctorId}) async {
    DoctorNextAppointmentModel doctorNextAppointmentModelData =
        DoctorNextAppointmentModel();
    var body = jsonEncode(({
      "user_id": doctorId,
    }));

    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorNextAppointment, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorNextAppointmentModelData =
            DoctorNextAppointmentModel.fromJson(result);
      } else {
        doctorNextAppointmentModelData = DoctorNextAppointmentModel();
      }
      return doctorNextAppointmentModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Doctor Appoinments API *****

  Future<DoctorAppointmentsModel> doctorAppoinmentsModel(
      {required String doctorId}) async {
    var body = jsonEncode(({"doctor_id": doctorId}));

    try {
      DoctorAppointmentsModel doctorAppointmentsModeldata =
          DoctorAppointmentsModel();
      var result = await _networkAPICall.post(
          Constants.getDoctorAppointments, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        doctorAppointmentsModeldata = DoctorAppointmentsModel.fromJson(result);
        log("======????????>>>>>$result");
        log("======????????>>>>>${doctorAppointmentsModeldata.status}");
      } else {
        doctorAppointmentsModeldata = DoctorAppointmentsModel();
      }
      return doctorAppointmentsModeldata;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  // ///***** Doctor Availability API *****
  //
  // Future<DoctorAvailabilityModel> doctorAvailabilityModel(
  //     {String userId, dateTime, s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23}) async {
  //   var body = jsonEncode(({
  //     "user_id" : userId,
  //     "availability_date" : dateTime,
  //     "0" : s0,
  //     "1" : s1,
  //     "2" : s2,
  //     "3" : s3,
  //     "4" : s4,
  //     "5" : s5,
  //     "6" : s6,
  //     "7" : s7,
  //     "8" : s8,
  //     "9" : s9,
  //     "10" : s10,
  //     "11" : s11,
  //     "12" : s12,
  //     "13" : s13,
  //     "14" : s14,
  //     "15" : s15,
  //     "16" : s16,
  //     "17" : s17,
  //     "18" : s18,
  //     "19" : s19,
  //     "20" : s20,
  //     "21" : s21,
  //     "22" : s22,
  //     "23" : s23,
  //   }));

  //   try {
  //     DoctorAvailabilityModel doctorAvailabilityModeldata =
  //     DoctorAvailabilityModel();
  //     var result = await _networkAPICall
  //         .post(Constants.getDoctorAppointments, body, header: headers);
  //
  //     if (result['status'] == 'Success') {
  //       print("yessssss=>>>>>>>>");
  //       doctorAvailabilityModeldata =
  //           DoctorAvailabilityModel.fromJson(result);
  //       print("======????????>>>>>$result");
  //     } else {
  //       doctorAvailabilityModeldata = null;
  //     }
  //     return doctorAvailabilityModeldata;
  //   } catch (e, stackStrace) {
  //     throw AppException.exceptionHandler(e, stackStrace);
  //   }
  // }
  ///***** About_us - Privacy_Policy API *****
  Future<AboutUsPrivacyPolicyDoctorModel> aboutUsPrivacyPolicy() async {
    AboutUsPrivacyPolicyDoctorModel aboutUsPrivacyPolicyDoctorModel =
        AboutUsPrivacyPolicyDoctorModel();

    try {
      var result = await _networkAPICall.get(Constants.getAppSettingsDoctor,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        aboutUsPrivacyPolicyDoctorModel =
            AboutUsPrivacyPolicyDoctorModel.fromJson(result);
      } else {
        aboutUsPrivacyPolicyDoctorModel = AboutUsPrivacyPolicyDoctorModel();
      }

      return aboutUsPrivacyPolicyDoctorModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Get All Chat Messages API *****
  Future<GetAllChatMessagesDoctor> getAllChatMessagesDoctor(
      {required String chatKey, required String id}) async {
    GetAllChatMessagesDoctor getAllChatMessagesDoctorModel =
        GetAllChatMessagesDoctor();
    var body = jsonEncode(
      ({"chat_key": chatKey, "doctor_id": id}),
    );

    try {
      var result = await _networkAPICall.post(
          Constants.getAllChatMessagesDoctor, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        getAllChatMessagesDoctorModel =
            GetAllChatMessagesDoctor.fromJson(result);
      } else {
        getAllChatMessagesDoctorModel = GetAllChatMessagesDoctor();
      }

      return getAllChatMessagesDoctorModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Get Sorted Chat List API *****
  Future<GetSortedChatListDoctor> getSortedChatListDoctor(
      {required String doctorId}) async {
    GetSortedChatListDoctor getSortedChatListDoctorModel =
        GetSortedChatListDoctor();
    var body = jsonEncode(({"doctor_id": doctorId}));
    try {
      var result = await _networkAPICall.post(
          Constants.getSortedChatListDoctor, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        getSortedChatListDoctorModel = GetSortedChatListDoctor.fromJson(result);
      } else {
        getSortedChatListDoctorModel = GetSortedChatListDoctor();
      }

      return getSortedChatListDoctorModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** DELETE CHAT M<MESSAGE List API *****
  Future<DeleteChatMessageResponseModel> deleteChatMsg(
      {required String doctorId, required String id}) async {
    DeleteChatMessageResponseModel deleteChatMessageResponseModel =
        DeleteChatMessageResponseModel();
    var body = jsonEncode(({"doctor_id": doctorId, "chat_id": id}));

    try {
      var result = await _networkAPICall.delete(Constants.deleteDoctorMsg, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        deleteChatMessageResponseModel =
            DeleteChatMessageResponseModel.fromJson(result);
      } else {
        deleteChatMessageResponseModel = DeleteChatMessageResponseModel();
      }

      return deleteChatMessageResponseModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Get New Message Doctor API *****
  Future<CreateNewMessage> createNewMessageDoctor(
      {required String fromType,
      fromId,
      toType,
      toId,
      message,
      chatKey,
      required File attachment}) async {
    CreateNewMessage createNewMessageDoctorModel = CreateNewMessage();
    var body = {
      'from_type': fromType,
      'from_id': "$fromId",
      'to_type': "$toType",
      'to_id': "$toId",
      'chat_key': "$chatKey",
      'message': "$message",
      'attachment': "$attachment",
    };
    try {
      var result = await _networkAPICall.multipartRequestPost(
          Constants.createNewMessageDoctor, body,
          image1: attachment,
          image1Key: 'attachment',
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        createNewMessageDoctorModel = CreateNewMessage.fromJson(result);
      } else {
        createNewMessageDoctorModel = CreateNewMessage();
      }

      return createNewMessageDoctorModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  DoctorAvailability doctorAvailabilityData = DoctorAvailability();

  Future<DoctorAvailability> doctorAvailability({
    required String userId,
    required DateTime dateTime,
    required List<Map<String, dynamic>> availData,
    /*s0,
      s1,
      s2,
      s3,
      s4,
      s5,
      s6,
      s7,
      s8,
      s9,
      s10,
      s11,
      s12,
      s13*/
  }) async {
    DateTime date = dateTime.toUtc();
    log('date==========>>>>>$date');
    var body = jsonEncode(({
      "user_id": userId,
      "availability_date": DateFormat("yyyy-MM-dd").format(dateTime),
      "availability_data": availData
      // "0": "0",
      // "1": "0",
      // "2": "0",
      // "3": "0",
      // "4": "0",
      // "5": "0",
      // "6": "0",
      // "7": "0",
      // "8": '$s0',
      // "9": '$s1',
      // "10": '$s2',
      // "11": '$s3',
      // "12": '$s4',
      // "13": '$s5',
      // "14": '$s6',
      // "15": '$s7',
      // "16": '$s8',
      // "17": '$s9',
      // "18": '$s10',
      // "19": '$s11',
      // "20": '$s12',
      // "21": '$s13',
      // "22": "0",
      // "23": "0",
    }));
    log('body=====body=====>>>>>$body');

    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorAvailability, body,
          header: Config.getHeaders());
      /*  if (result['status'] == 'Success') {
          doctorAvailabilityData = DoctorAvailability.fromJson(result['data']);
          print("Success");
        } else {
          doctorAvailabilityData = null;
          print("Failed");
        }
*/
      // await AppPreference().saveCustomerData(customerData);

      return doctorAvailabilityData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  DoctorMultipleAvailability doctorMultipleAvailabilityData =
      DoctorMultipleAvailability();

  Future<DoctorMultipleAvailability> doctorMultipleAvailability({
    required String userId,
    startTime,
    endTime,
    required List<Map<String, dynamic>> availData,
    /*s0,
      s1,
      s2,
      s3,
      s4,
      s5,
      s6,
      s7,
      s8,
      s9,
      s10,
      s11,
      s12,
      s13*/
  }) async {
    DateTime date = startTime.toUtc();
    DateTime date1 = endTime.toUtc();
    log('date==========>>>>>$date');
    log('date1==========>>>>>$date1');
    var body = jsonEncode(({
      "user_id": userId,
      "availability_date_from": DateFormat("yyyy-MM-dd").format(startTime),
      "availability_date_to": DateFormat("yyyy-MM-dd").format(endTime),
      "availability_data": availData
      // "0": "0",
      // "1": "0",
      // "2": "0",
      // "3": "0",
      // "4": "0",
      // "5": "0",
      // "6": "0",
      // "7": "0",
      // "8": '$s0',
      // "9": '$s1',
      // "10": '$s2',
      // "11": '$s3',
      // "12": '$s4',
      // "13": '$s5',
      // "14": '$s6',
      // "15": '$s7',
      // "16": '$s8',
      // "17": '$s9',
      // "18": '$s10',
      // "19": '$s11',
      // "20": '$s12',
      // "21": '$s13',
      // "22": "0",
      // "23": "0",
    }));

    try {
      var result = await _networkAPICall.post(
          Constants.multipleDoctorAvailability, body,
          header: Config.getHeaders());
      return doctorMultipleAvailabilityData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }
}
