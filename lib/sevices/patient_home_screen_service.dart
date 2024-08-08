import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/instance_manager.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/aboutus_privacy_policy_model.dart';
import 'package:united_natives/model/booked_appointment_data.dart';
import 'package:united_natives/model/cancle_appointment_patient.dart';
import 'package:united_natives/model/delete_chat_messages_response_model.dart';
import 'package:united_natives/model/delete_patiend_side_chatuser_response.dart';
import 'package:united_natives/model/delete_patient_account_model.dart';
import 'package:united_natives/model/getSorted_patient_chatList_model.dart';
import 'package:united_natives/model/get_all_doctor.dart';
import 'package:united_natives/model/get_all_patient_messagelist_model.dart';
import 'package:united_natives/model/get_new_message_doctor_model.dart';
import 'package:united_natives/model/patient_get_appointment_rating.dart';
import 'package:united_natives/model/patient_homepage_model.dart';
import 'package:united_natives/model/patient_prescription_model.dart';
import 'package:united_natives/model/research_document_details_model.dart';
import 'package:united_natives/model/research_document_model.dart';
import 'package:united_natives/model/visited_doctor_upcoming_past_model.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/network_util.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';

class PatientHomeScreenService {
  static final PatientHomeScreenService _authService =
      PatientHomeScreenService._init();

  factory PatientHomeScreenService() {
    return _authService;
  }

  PatientHomeScreenService._init();

  final NetworkAPICall _networkAPICall = NetworkAPICall();

  static const bannerToken = '43b2fe6fb2cd47eb049520a9f5d94905';
  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  // Map<String, String> headers = {
  //   "Authorization": 'Bearer ${Config.getHeaders()}',
  //   "Content-Type": 'application/json',
  // };

  ///***** patientHome Page API *****

  Future<PatientHomePageModel> patientHomePageModel(
      {required String userId, bearerToken}) async {
    PatientHomePageModel patientHomePageModelData = PatientHomePageModel();
    var body = jsonEncode({"user_id": userId});
    log('body==========>>>>>$body');
    try {
      var header = Config.getHeaders();

      var result = await _networkAPICall.post(Constants.patientHomePage, body,
          header: header);

      if (result['status'] == 'Success') {
        patientHomePageModelData = PatientHomePageModel.fromJson(result);
      } else {
        patientHomePageModelData = PatientHomePageModel();
      }

      return patientHomePageModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** visited Doctor API *****

  Future<VisitedDoctorUpcomingPastModel> visitedDoctorUpcomingPastModel(
      {required String patientId, bearerToken}) async {
    VisitedDoctorUpcomingPastModel visitedDoctorUpcomingPastModelData =
        VisitedDoctorUpcomingPastModel();
    var body = jsonEncode({"patient_id": patientId});
    try {
      var result = await _networkAPICall.post(Constants.getVisitedDoctors, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        visitedDoctorUpcomingPastModelData =
            VisitedDoctorUpcomingPastModel.fromJson(result);
      } else {
        visitedDoctorUpcomingPastModelData = VisitedDoctorUpcomingPastModel();
      }
      return visitedDoctorUpcomingPastModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Reseach Document API *****

  Future<ResearchDocumentModel> researchDocumentModel(
      {required String userId}) async {
    ResearchDocumentModel researchDocumentModelData = ResearchDocumentModel();
    var body = jsonEncode(({"user_id": userId}));

    try {
      var result = await _networkAPICall.post(
          Constants.viewResearchDocuments, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        researchDocumentModelData = ResearchDocumentModel.fromJson(result);
      } else {
        researchDocumentModelData = ResearchDocumentModel();
      }
      return researchDocumentModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Reseach Document Details API *****

  Future<ResearchDocumentDetailsModel> researchDocumentDetailsModel(
      {required String userId, documentId}) async {
    ResearchDocumentDetailsModel researchDocumentDetailsModelData =
        ResearchDocumentDetailsModel();
    var body = jsonEncode(({"user_id": userId, "document_id": documentId}));

    try {
      var result = await _networkAPICall.post(
          Constants.viewResearchDocumentDetails, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        researchDocumentDetailsModelData =
            ResearchDocumentDetailsModel.fromJson(result);
      } else {
        researchDocumentDetailsModelData = ResearchDocumentDetailsModel();
      }
      return researchDocumentDetailsModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** createNewMessage API *****

  Future createNewMessage(
      {fromType,
      fromId,
      toType,
      toId,
      chatKey,
      message,
      required File attachment}) async {
    CreateNewMessage createNewMessageDoctorModel = CreateNewMessage();
    var body = <String, String>{
      "from_type": fromType,
      "from_id": fromId,
      "to_type": toType,
      "to_id": toId,
      "chat_key": chatKey,
      "message": message,
    };

    try {
      var result = await _networkAPICall.multipartRequestPost(
          Constants.createNewMessage, body,
          image1: attachment,
          image1Key: 'attachment',
          header: Config.getHeaders());
      createNewMessageDoctorModel = CreateNewMessage.fromJson(result);
      return createNewMessageDoctorModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** GetSortedPatientChatList API *****

  Future<GetSortedPatientChatListModel> getSortedPatientChatList(
      {required String patientId}) async {
    GetSortedPatientChatListModel getSortedPatientChatListModel =
        GetSortedPatientChatListModel();
    var body = jsonEncode(({"patient_id": patientId}));

    try {
      var result = await _networkAPICall.post(
          Constants.getSortedPatientChatList, body,
          header: Config.getHeaders());

      getSortedPatientChatListModel =
          GetSortedPatientChatListModel.fromJson(result);
      return getSortedPatientChatListModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** DELETE PATIENT CHAT API *****

  Future<DeleteChatUserResponseModel> deletePatientChat(
      {required String patientId, required String chatKey}) async {
    DeleteChatUserResponseModel deleteChatUserResponseModel =
        DeleteChatUserResponseModel();
    var body = jsonEncode(
      ({
        "patient_id": patientId,
        "chat_key": chatKey,
      }),
    );

    try {
      var result = await _networkAPICall.delete(
          Constants.deleteChatPatient, body,
          header: Config.getHeaders());

      deleteChatUserResponseModel =
          DeleteChatUserResponseModel.fromJson(result);
      return deleteChatUserResponseModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** DELETE PATIENT CHAT MESSAGE *****

  Future<DeleteChatMessageResponseModel> deletePatientChatMessage(
      {required String patientId, required String id}) async {
    DeleteChatMessageResponseModel deleteChatMessageResponseModel =
        DeleteChatMessageResponseModel();
    var body = jsonEncode(
      ({
        "patient_id": patientId,
        "chat_id": id,
      }),
    );

    try {
      var result = await _networkAPICall.delete(
          Constants.deleteChatMessagePatient, body,
          header: Config.getHeaders());

      deleteChatMessageResponseModel =
          DeleteChatMessageResponseModel.fromJson(result);
      return deleteChatMessageResponseModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** DELETE DOCTOR CHAT API *****

  Future<DeleteChatUserResponseModel> deleteDoctorChat(
      {required String doctorId, required String chatKey}) async {
    DeleteChatUserResponseModel deleteChatUserResponseModel =
        DeleteChatUserResponseModel();
    var body = jsonEncode(
      ({
        "doctor_id": doctorId,
        "chat_key": chatKey,
      }),
    );

    try {
      var result = await _networkAPICall.delete(
          Constants.deleteChatDoctor, body,
          header: Config.getHeaders());
      deleteChatUserResponseModel =
          DeleteChatUserResponseModel.fromJson(result);
      return deleteChatUserResponseModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///Pationt  Paypal API

  Future getPaypalPayment(
      {userId,
      appointmentId,
      payAmount,
      payType,
      paypalPayerId,
      paypalToken,
      paypalpaymentId}) async {
    var body = jsonEncode({
      "user_id": userId,
      "appointment_id": appointmentId,
      "pay_amount": payAmount,
      "pay_type": payType,
      "paypal_payer_id": paypalPayerId,
      "paypal_token": paypalToken,
      "paypal_payment_id": paypalpaymentId
    });

    var result = await _networkAPICall.post(Constants.makePayment, body,
        header: Config.getHeaders());

    log('result==========>>>>>$result');
  }

  ///***** GetAllDoctors API *****

  Future<GetAllDoctor> getAllDoctor({required String patientId}) async {
    GetAllDoctor getAllDoctor = GetAllDoctor();
    var body = jsonEncode(({"user_id": patientId}));

    try {
      var result = await _networkAPICall.post(Constants.getAllDoctor, body,
          header: Config.getHeaders());

      getAllDoctor = GetAllDoctor.fromJson(result);
      return getAllDoctor;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** GetAllPatientChatList API *****
  Future<GetAllPatientChatMessages> getAllMessageList(
      {required String chatId, required String patientId}) async {
    var body = jsonEncode(
      ({"chat_key": chatId, "patient_id": patientId}),
    );

    try {
      var result = await _networkAPICall.post(
          Constants.getAllPatientChatList, body,
          header: Config.getHeaders());
      return GetAllPatientChatMessages.fromJson(result);
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** Appointment Cancel API *****
  Future<CancelAppointmentPatient> cancelAppointmentPatient(
      {required String userId, appointmentId}) async {
    var body =
        jsonEncode(({"user_id": userId, "appointment_id": appointmentId}));

    try {
      var result = await _networkAPICall.post(
          Constants.cancelAppointmentPatient, body,
          header: Config.getHeaders());
      CancelAppointmentPatient cancelAppointmentPatientData =
          CancelAppointmentPatient();
      cancelAppointmentPatientData = CancelAppointmentPatient.fromJson(result);
      return cancelAppointmentPatientData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** DELETE PATIENT ACCOUNT API *****
  Future<DeletePatientAccountResponseModel> deletePatient(
      {required String id}) async {
    var body = json.encode({
      "user_id": id,
      "device_token": Prefs.getString(Prefs.FcmToken.toString())
    });

    try {
      var result = await _networkAPICall.delete(
          Constants.deletePatientAccount, body,
          header: Config.getHeaders());
      DeletePatientAccountResponseModel deletePatientAccountResponseModel =
          DeletePatientAccountResponseModel();
      deletePatientAccountResponseModel =
          DeletePatientAccountResponseModel.fromJson(result);
      return deletePatientAccountResponseModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** About_us - Privacy_Policy API *****
  Future<AboutUsPrivacyPolicyModel> aboutUsPrivacyPolicy() async {
    AboutUsPrivacyPolicyModel aboutUsPrivacyPolicyModel =
        AboutUsPrivacyPolicyModel();

    try {
      var result = await _networkAPICall.get(Constants.getAppSettingsPatient,
          header: Config.getHeaders());
      aboutUsPrivacyPolicyModel = AboutUsPrivacyPolicyModel.fromJson(result);

      return aboutUsPrivacyPolicyModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  // ///***** PatientPrescription API *****

  Future<PatientPrescriptionsModel> patientPrescriptionsModel(
      {required String patientId}) async {
    PatientPrescriptionsModel patientPrescriptionsModelData =
        PatientPrescriptionsModel();
    var body = jsonEncode(({"patient_id": patientId}));

    try {
      var result = await _networkAPICall.post(
          Constants.getPatientPrescriptions, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        patientPrescriptionsModelData =
            PatientPrescriptionsModel.fromJson(result);
      } else {
        patientPrescriptionsModelData = PatientPrescriptionsModel();
      }
      return patientPrescriptionsModelData;
    } catch (e, stackTrace) {
      throw AppException.exceptionHandler(e, stackTrace);
    }
  }

  Future<AppointmentBookedModel> addPatientAppointment(
      {required String patientId,
      doctorId,
      purposeOfVisit,
      appointmentDate,
      appointmentTime,
      appointmentFor,
      fullName,
      mobile,
      email,
      patientMobile,
      city,
      state,
      companyName,
      providerName,
      faxNumber}) async {
    // print("print2===>$dateTime");
    var body = jsonEncode(({
      "patient_id": patientId,
      "doctor_id": doctorId,
      "purpose_of_visit": purposeOfVisit,
      "appointment_date": appointmentDate,
      "appointment_time": appointmentTime,
      "appointment_for": appointmentFor,
      "full_name": fullName,
      "mobile": mobile,
      "email": email,
      "patient_mobile": patientMobile,
      "city": city,
      "state": state,
      "company_name": companyName,
      "provider_name": providerName,
      "fax_number": faxNumber
    }));

    log('body==========>>>>>$body');
    AppointmentBookedModel appointmentBookedModelData =
        AppointmentBookedModel();
    // print("print69===>$dateTime");
    try {
      // print("print3===>$dateTime");

      var result = await _networkAPICall.post(
          Constants.addPatientAppointment, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        appointmentBookedModelData = AppointmentBookedModel.fromJson(result);
      } else {
        appointmentBookedModelData = AppointmentBookedModel();
      }
      return appointmentBookedModelData;
    } catch (e, stackStrace) {
      // print("print4===>$dateTime");
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future addAppointmentRating({
    doctorId,
    patientId,
    appointmentId,
    rating,
  }) async {
    var body = jsonEncode(({
      "patient_id": "$patientId",
      "doctor_id": "$doctorId",
      "appointment_id": "$appointmentId",
      "rating": "$rating"
    }));

    try {
      var result = await _networkAPICall.post(
          Constants.addAppointmentRating, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        return result;
      } else {
        return null;
      }
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future<PatientGetAppointmentRatingModel> getAppointmentRating({
    patientId,
    appointmentId,
  }) async {
    var body = jsonEncode(({
      "patient_id": "$patientId",
      "appointment_id": "$appointmentId",
    }));
    PatientGetAppointmentRatingModel patientGetAppointmentRatingModel =
        PatientGetAppointmentRatingModel();
    try {
      var result = await _networkAPICall.post(
          Constants.getAppointmentRating, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        patientGetAppointmentRatingModel =
            PatientGetAppointmentRatingModel.fromJson(result);
      } else {
        patientGetAppointmentRatingModel = PatientGetAppointmentRatingModel();
      }
      return patientGetAppointmentRatingModel;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }
}
