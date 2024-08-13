import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/aboutus_privacy_policy_model.dart';
import 'package:united_natives/model/add_patient_appointment_model.dart';
import 'package:united_natives/model/api_state_enum.dart';
import 'package:united_natives/model/appointment.dart';
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
import 'package:united_natives/pages/messages/messages_detail_page.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/sevices/patient_home_screen_service.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:united_natives/model/patient_prescription_model.dart' as d;
import 'package:http/http.dart' as http;

class PatientHomeScreenController extends GetxController {
  Rx<PatientHomePageModel> patientHomePageData = PatientHomePageModel().obs;
  Rx<VisitedDoctorUpcomingPastModel> visitedDoctorUpcomingPastData =
      VisitedDoctorUpcomingPastModel().obs;
  RxList<Appointment> pastAppointmentData = <Appointment>[].obs;

  String pastAppointmentData1 = '';

  Rx<ResearchDocumentModel> researchDocumentModelData =
      ResearchDocumentModel().obs;
  Rx<ResearchDocumentDetailsModel> researchDocumentDetailsModelData =
      ResearchDocumentDetailsModel().obs;
  Rx<GetSortedPatientChatListModel> getSortedPatientChatListModel =
      GetSortedPatientChatListModel().obs;
  Rx<GetAllPatientChatMessages> getAllPatientChatMessages =
      GetAllPatientChatMessages().obs;
  Rx<PatientPrescriptionsModel> patientPrescriptionsModelData =
      PatientPrescriptionsModel().obs;
  Rx<AddPatientAppointment> addPatientAppointmentData =
      AddPatientAppointment().obs;
  Rx<AppointmentBookedModel> appointmentBookedModelData =
      AppointmentBookedModel().obs;
  Rx<CancelAppointmentPatient> cancelAppointmentPatientData =
      CancelAppointmentPatient().obs;

  Rx<DeletePatientAccountResponseModel> deletePatientAccountData =
      DeletePatientAccountResponseModel().obs;
  Rx<AboutUsPrivacyPolicyModel> aboutUsPrivacyPolicyModel =
      AboutUsPrivacyPolicyModel().obs;
  Rx<PatientGetAppointmentRatingModel> getAppointmentRatingModel =
      PatientGetAppointmentRatingModel().obs;
  Rx<CreateNewMessage> createNewMessageModel = CreateNewMessage().obs;
  Rx<GetAllDoctor> getAllDoctor = GetAllDoctor().obs;

  Rx<DeleteChatUserResponseModel> deletePatientChatUserModel =
      DeleteChatUserResponseModel().obs;

  Rx<DeleteChatMessageResponseModel> deletePatientChatMessageModel =
      DeleteChatMessageResponseModel().obs;

  List<SortedPatientChat> newDataList = [];
  // List<Appointment> appointmentList = [];
  RxList<d.Data> preData = <d.Data>[].obs;

  RxString preData1 = "".obs;

  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool isLoadingDeleteChatMsg = false.obs;
  RxString fromType = "".obs;
  RxString fromId = "".obs;
  RxString toType = "".obs;
  RxString toId = "".obs;
  RxString chatKey = "".obs;
  RxString message = "".obs;
  RxString attachment = "".obs;
  RxString doctorName = "".obs;
  String doctorProfile = "";
  String doctorSocialProfile = "";
  RxString doctorLastName = "".obs;
  RxString doctorId = "".obs;
  RxString pationtAppoinmentid = "".obs;
  Timer? timer;

  final pastController = TextEditingController();
  final prescriptionController = TextEditingController();

  final UserController _userController = Get.find<UserController>();
  AddNewChatMessageController addNewChatMessageController =
      Get.put(AddNewChatMessageController());

  // void dispose() {
  //   appointmentList = [];
  //   super.dispose();
  // }

  ///*****getPatientHomePage Controller*****
  Future<PatientHomePageModel> getPatientHomePage() async {
    try {
      isLoading.value = true;
      patientHomePageData.value = await PatientHomeScreenService()
          .patientHomePageModel(userId: "${_userController.user.value.id}");

      isLoading.value = false;
      return patientHomePageData.value;
    } catch (e) {
      isLoading.value = false;
    }
    return patientHomePageData.value;
  }

  Future<String> getMeetingStatus(String channelsName, String doctorId) async {
    String url = Constants.baseUrl + Constants.doctorZoomMeetStatus;
    Map<String, dynamic> body = {
      "doctor_id": doctorId,
      "meeting_id": channelsName
    };

    Map<String, String> header = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };

    http.Response response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: header);

    if (response.statusCode == 200) {
      log('RESPONSE MEET STATUS CHECK ${response.body}');

      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      log('data==========>>>>>$data');

      if (data["data"] != null) {
        return data["data"]["meeting_status"];
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  ///*****getVisitedDoctors Controller*****
  Future<VisitedDoctorUpcomingPastModel> getVisitedDoctors() async {
    try {
      visitedDoctorUpcomingPastData.value.apiState = APIState.PROCESSING;
      visitedDoctorUpcomingPastData.value = await PatientHomeScreenService()
          .visitedDoctorUpcomingPastModel(
              patientId: "${_userController.user.value.id}");

      visitedDoctorUpcomingPastData.value.past?.sort(
        (a, b) {
          String dateA = "${b.appointmentDate} ${b.appointmentTime}";
          String dateB = "${a.appointmentDate} ${a.appointmentTime}";
          return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
        },
      );
      pastAppointmentData.value = visitedDoctorUpcomingPastData.value.past!;

      pastAppointmentData1 = jsonEncode(pastAppointmentData);
    } catch (isBlank) {
      visitedDoctorUpcomingPastData.value.apiState = APIState.ERROR;
      visitedDoctorUpcomingPastData.refresh();
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return visitedDoctorUpcomingPastData.value;
  }

  searchPastAppointment(String searchValue) {
    List<Appointment> temp = List<Appointment>.from(
        jsonDecode(pastAppointmentData1).map((x) => Appointment.fromJson(x)));
    if (searchValue.isNotEmpty) {
      pastAppointmentData.clear();
      for (var element in temp) {
        if ("${element.doctorFirstName?.toLowerCase()}${element.doctorLastName?.toLowerCase()}"
                .replaceAll(" ", "")
                .contains(searchValue.toLowerCase().replaceAll(" ", "")) ||
            element.doctorSpeciality!
                .toLowerCase()
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(searchValue.toLowerCase().replaceAll(" ", ""))) {
          pastAppointmentData.add(element);
        }
      }
    } else {
      pastAppointmentData.value = List<Appointment>.from(
          jsonDecode(pastAppointmentData1).map((x) => Appointment.fromJson(x)));
    }
  }

  ///*****getResearchDocument Controller*****

  Future<ResearchDocumentModel> getResearchDocument() async {
    try {
      // isLoading.value = true;
      researchDocumentModelData.value.apiState = APIState.PROCESSING;
      researchDocumentModelData.value = await PatientHomeScreenService()
          .researchDocumentModel(userId: "${_userController.user.value.id}");
    } catch (isBlank) {
      researchDocumentModelData.value.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    getSortedPatientChatListModel.refresh();
    return researchDocumentModelData.value;
  }

  ///****call Timer function for chat messages****

  void getAllChatMessages(String chatKey, String id) {
    if (timer != null) {
      timer?.cancel();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      addNewChatMessageController.allChatMessagePatient(
          chatKey: chatKey, id: id);
    });
  }

  ///****End Timer function for chat messages****

  Future endTimer() async {
    if (timer != null) {
      timer?.cancel();
    }
  }

  ///*****getResearchDocumentDetails Controller*****

  Future<ResearchDocumentDetailsModel> getResearchDocumentDetails(
      String documentId) async {
    try {
      researchDocumentDetailsModelData.value.apiState = APIState.PROCESSING;
      researchDocumentDetailsModelData.value = await PatientHomeScreenService()
          .researchDocumentDetailsModel(
              userId: "${_userController.user.value.id}",
              documentId: documentId);
    } catch (isBlank) {
      researchDocumentDetailsModelData.value.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    researchDocumentDetailsModelData.refresh();
    return researchDocumentDetailsModelData.value;
  }

  RxBool isChatListFirst = true.obs;

  ///***** GetSortedPatientChatList Controller *****
  Future<GetSortedPatientChatListModel> getSortedPatientChatList() async {
    try {
      getSortedPatientChatListModel.value.apiState = APIState.PROCESSING;
      getSortedPatientChatListModel.value = await PatientHomeScreenService()
          .getSortedPatientChatList(
              patientId: "${_userController.user.value.id}");

      isChatListFirst.value = false;
    } catch (isBlank) {
      getSortedPatientChatListModel.value.apiState = APIState.ERROR;
      getSortedPatientChatListModel.refresh();
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    newDataList = getSortedPatientChatListModel.value.data ?? [];
    return getSortedPatientChatListModel.value;
  }

  ///***** GetPastDocAppointmentDetail ********

  // Future getPastDocAppointment(String value) async {
  //   appointmentList = [];
  //   for (var element in visitedDoctorUpcomingPastData?.value?.past) {
  //     if (element.doctorFirstName.toLowerCase().contains(value.toLowerCase()) ||
  //         element.doctorLastName.toLowerCase().contains(value.toLowerCase()) ||
  //         element.doctorSpeciality
  //             .toLowerCase()
  //             .contains(value.toLowerCase())) {
  //       appointmentList.add(element);
  //       update();
  //     }
  //   }
  //   update();
  //   debugPrint("searchDataLength-----${appointmentList.length}");
  // }

  ///***** DELETE CHAT USER PATIENT *****
  Future<DeleteChatUserResponseModel> deleteChatUserPatient(
      {String? patientId, String? chatKey}) async {
    try {
      deletePatientChatUserModel.value.apiState = APIState.PROCESSING;
      deletePatientChatUserModel.value = await PatientHomeScreenService()
          .deletePatientChat(chatKey: '$chatKey', patientId: '$patientId');
    } catch (isBlank) {
      deletePatientChatUserModel.value.apiState = APIState.ERROR;

      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    return deletePatientChatUserModel.value;
  }

  ///***** DELETE CHAT MESSAGE *****
  Future<DeleteChatMessageResponseModel> deleteChatMessagePatient(
      {String? patientId, String? id}) async {
    try {
      Navigator.of(Get.overlayContext!).pop();
      isLoadingDeleteChatMsg.value = true;
      // deletePatientChatMessageModel.value.apiState = APIState.PROCESSING;
      deletePatientChatMessageModel.value = await PatientHomeScreenService()
          .deletePatientChatMessage(id: '$id', patientId: '$patientId');
      isLoadingDeleteChatMsg.value = false;
    } catch (isBlank) {
      // deletePatientChatMessageModel.value.apiState = APIState.ERROR;
      isLoadingDeleteChatMsg.value = false;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return deletePatientChatMessageModel.value;
  }

  ///***** DELETE CHAT USER DOCTOR *****
  Future<DeleteChatUserResponseModel> deleteChatUserDoctor(
      {String? doctorId, String? chatKey}) async {
    try {
      deletePatientChatUserModel.value.apiState = APIState.PROCESSING;
      deletePatientChatUserModel.value = await PatientHomeScreenService()
          .deleteDoctorChat(chatKey: '$chatKey', doctorId: '$doctorId');
    } catch (isBlank) {
      deletePatientChatUserModel.value.apiState = APIState.ERROR;

      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return deletePatientChatUserModel.value;
  }

  ///***** GetSortedPatientChatList Controller *****
  Future<GetAllDoctor> getAllDoctors() async {
    // aboutUsPrivacyPolicy();
    try {
      getAllDoctor.value.apiState = APIState.PROCESSING;
      getAllDoctor.value = await PatientHomeScreenService()
          .getAllDoctor(patientId: "${_userController.user.value.id}");
    } catch (isBlank) {
      getAllDoctor.value.apiState = APIState.ERROR;
      getAllDoctor.refresh();
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    return getAllDoctor.value;
  }

  ///***** GetAllPatientChatList Controller *****
  Future<GetAllPatientChatMessages> getAllPatientChatMessagesList(
      chatId) async {
    try {
      if (chatId?.isEmpty ?? true) {
        getAllPatientChatMessages.value.patientChatList?.clear();
        getAllPatientChatMessages.value.apiState =
            APIState.COMPLETE_WITH_NO_DATA;
        return getAllPatientChatMessages.value;
      }
      getAllPatientChatMessages.value.apiState = APIState.PROCESSING;
      getAllPatientChatMessages.value = await PatientHomeScreenService()
          .getAllMessageList(
              chatId: chatId, patientId: "${_userController.user.value.id}");
    } catch (error) {
      getAllPatientChatMessages.value.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    getAllPatientChatMessages.refresh();
    return getAllPatientChatMessages.value;
  }

  ///*****createNewMessagePatient Controller*****
  Future<CreateNewMessage> createNewMessagePatient(
      {String? fromType,
      fromId,
      toType,
      toId,
      message,
      chatKey,
      File? attachment}) async {
    try {
      isLoading.value = true;
      createNewMessageModel.value = await PatientHomeScreenService()
          .createNewMessage(
              chatKey: chatKey,
              fromType: fromType,
              fromId: fromId,
              message: message,
              attachment: attachment!,
              toId: toId,
              toType: toType);
      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    return createNewMessageModel.value;
  }

  ///*****Cancel Appointment Controller*****

  bool startLoader = false;

  Future<CancelAppointmentPatient> cancelAppointmentPatient(
      String userId, appointmentId) async {
    try {
      startLoader = true;
      update();

      cancelAppointmentPatientData.value = await PatientHomeScreenService()
          .cancelAppointmentPatient(
              userId: userId, appointmentId: appointmentId);

      startLoader = false;
      update();

      Utils.showSnackBar(cancelAppointmentPatientData.value.message ?? "",
          cancelAppointmentPatientData.value.status ?? "");
    } catch (isBlank) {
      startLoader = false;
      update();

      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return cancelAppointmentPatientData.value;
  }

  ///*****DELETE PATIENT ACCOUNT Controller*****

  Future<DeletePatientAccountResponseModel> deletePatientAccount(
      String id) async {
    try {
      isLoading1.value = true;

      deletePatientAccountData.value =
          await PatientHomeScreenService().deletePatient(id: id);
      isLoading1.value = false;
    } catch (isBlank) {
      isLoading1.value = false;

      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    return deletePatientAccountData.value;
  }

  ///*****getPatientPrescription Controller*****

  Future<PatientPrescriptionsModel> getPatientPrescriptions() async {
    try {
      preData.clear();
      patientPrescriptionsModelData.value.apiState = APIState.PROCESSING;
      patientPrescriptionsModelData.value =
          await PatientHomeScreenService().patientPrescriptionsModel(
        patientId: "${_userController.user.value.id}",
      );
      Set appointmentId = {};
      patientPrescriptionsModelData.value.data?.forEach((element) {
        appointmentId.add(element.appointmentId);
      });
      appointmentId.toList().forEach((element1) {
        final tempData = patientPrescriptionsModelData.value.data
            ?.where((element) => element.appointmentId == element1)
            .toList();
        preData.add(tempData!.first);
      });

      preData.sort(
        (a, b) {
          String dateA = "${b.appointmentDate} ${b.appointmentTime}";
          String dateB = "${a.appointmentDate} ${a.appointmentTime}";
          return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
        },
      );

      preData1.value = jsonEncode(preData);
    } catch (isBlank) {
      patientPrescriptionsModelData.value.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    patientPrescriptionsModelData.refresh();
    return patientPrescriptionsModelData.value;
  }

  searchPrescription(value) {
    List<d.Data> temp = List<d.Data>.from(
        jsonDecode(preData1.value).map((x) => d.Data.fromJson(x)));
    if (value.isNotEmpty) {
      preData.clear();
      for (var element in temp) {
        if (element.doctorName!
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(value.toLowerCase().replaceAll(" ", "")) ||
            element.doctorSpeciality!
                .toLowerCase()
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(value.toLowerCase().replaceAll(" ", ""))) {
          preData.add(element);
        }
      }
    } else {
      preData.value = List<d.Data>.from(
          jsonDecode(preData1.value).map((x) => d.Data.fromJson(x)));
    }
  }

  Future<AppointmentBookedModel?> addPatientAppointment({
    patientId,
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
    faxNumber,
  }) async {
    try {
      appointmentBookedModelData.value = await PatientHomeScreenService()
          .addPatientAppointment(
              patientId: patientId,
              doctorId: doctorId,
              purposeOfVisit: purposeOfVisit,
              appointmentDate: appointmentDate,
              appointmentTime: appointmentTime,
              appointmentFor: appointmentFor,
              mobile: mobile,
              email: email,
              patientMobile: patientMobile,
              city: city,
              state: state,
              companyName: companyName,
              providerName: providerName,
              fullName: fullName,
              faxNumber: faxNumber);

      pationtAppoinmentid(appointmentBookedModelData.value.data.toString());
      // Utils.showSnackBar(
      //      'Appointment',  "Appointment Book Successfully!");
      // ScaffoldMessenger.of(Get.overlayContext).showSnackBar(
      //   SnackBar(
      //     content: Text('Appointment Book Successfully!'),
      //   ),
      // );

      return appointmentBookedModelData.value;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar('Error Occurred', 'Please try again later');
      }
      return null;
    }

    // try {
    //   appointmentBookedModelData.value = await PatientHomeScreenService()
    //       .addPatientAppointment(
    //           patientId: patientId,
    //           doctorId: doctorId,
    //           purposeOfVisit: purposeOfVisit,
    //           appointmentDate: appointmentDate,
    //           appointmentTime: appointmentTime,
    //           appointmentFor: appointmentFor,
    //           mobile: mobile,
    //           email: email,
    //           patientMobile: patientMobile);
    //
    //   // Get.toNamed(Routes.paymentregister);
    //   Utils.showSnackBar(
    //        'Appointment Book Successfully!',
    //        "Appointment ID: ${appointmentBookedModelData.value.data}");
    //   return appointmentBookedModelData.value;
    // } catch (e) {
    //   if (e is AppException) {
    //     Utils.showSnackBar( 'Error Occurred',  e.message);
    //   } else {
    //     Utils.showSnackBar(
    //          'Error Occurred',  'Please try again later');
    //   }
    // }
    // try {
    //   AddPatientAppointment addPatientAppointmentData  = await PatientHomeScreenService()
    //       .addPatientAppointment(
    //           patientId: patientId,
    //           doctorId: doctorId,
    //           purposeOfVisit: purposeOfVisit,
    //           appointmentDate: appointmentDate,
    //           appointmentTime: appointmentTime,
    //           appointmentFor: appointmentFor,
    //           mobile: mobile,
    //           email: email,
    //           patientMobile: patientMobile);
    //
    //   if (addPatientAppointmentData != null) {
    //     // Get.toNamed(Routes.phoneAuthScreen)
    //     Utils.showSnackBar(
    //          'Appointment Set Successfully',  'Stay Tuned!');
    //   } else {
    //     Utils.showSnackBar(
    //          'Update Error',  'Please try again later');
    //   }
    //   return addPatientAppointmentData;
    //
    // } catch (e) {
    //   if (e is AppException) {
    //     Utils.showSnackBar( 'Update Error',  e.message);
    //   }
    // }
    // return addPatientAppointmentData.value;
  }

  ///*****getAppSettingsPagesContent Controller*****
  Future<AboutUsPrivacyPolicyModel> aboutUsPrivacyPolicy() async {
    try {
      aboutUsPrivacyPolicyModel.value =
          await PatientHomeScreenService().aboutUsPrivacyPolicy();
    } catch (isBlank) {
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }

    return aboutUsPrivacyPolicyModel.value;
  }

  // ///***** About_us - Privacy_Policy API *****
  // Future<AboutUsPrivacyPolicyModel> aboutUsPrivacyPolicy() async {
  //   AboutUsPrivacyPolicyModel aboutUsPrivacyPolicyModel = AboutUsPrivacyPolicyModel();
  //
  //   try {
  //     var result =
  //     await _networkAPICall.get(Constants.getAppSettingsPatient, header: Config.getHeaders());
  //
  //     if (result['status'] == 'Success') {
  //       aboutUsPrivacyPolicyModel = AboutUsPrivacyPolicyModel.fromJson(result);
  //     } else {
  //       aboutUsPrivacyPolicyModel = null;
  //     }
  //
  //     return aboutUsPrivacyPolicyModel;
  //   } catch (e, stackStrace) {
  //     throw AppException.exceptionHandler(e, stackStrace);
  //   }
  // }
  Future<bool> addAppointmentRatingCall({
    doctorId,
    patientId,
    appointmentId,
    rating,
  }) async {
    try {
      Map result = await PatientHomeScreenService().addAppointmentRating(
          appointmentId: appointmentId,
          doctorId: doctorId,
          patientId: patientId,
          rating: rating);
      if (result['status'] == "Success") {
        Utils.showSnackBar("Success", result['message'].toString());
        return true;
      } else {
        return false;
      }
    } catch (isBlank) {
      Utils.showSnackBar('Error Occurred', 'Please try again later');
      return false;
    }
  }

  Future<PatientGetAppointmentRatingModel> getAppointmentRatingCall(
    patientId,
    appointmentId,
  ) async {
    try {
      getAppointmentRatingModel.value =
          await PatientHomeScreenService().getAppointmentRating(
        appointmentId: appointmentId,
        patientId: patientId,
      );
      return getAppointmentRatingModel.value;
    } catch (isBlank) {
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return getAppointmentRatingModel.value;
  }

  Future<void> onPatientChatTap(int index, BuildContext context,
      SortedPatientChat sortedPatientChat) async {
    chatKey.value =
        getSortedPatientChatListModel.value.data?[index].chatKey ?? "";
    doctorName.value =
        getSortedPatientChatListModel.value.data?[index].doctorFirstName ?? "";
    doctorLastName.value =
        getSortedPatientChatListModel.value.data?[index].doctorLastName ?? "";
    doctorId.value =
        getSortedPatientChatListModel.value.data?[index].doctorId ?? "";
    toId.value =
        getSortedPatientChatListModel.value.data?[index].doctorId ?? "";

    doctorProfile =
        getSortedPatientChatListModel.value.data?[index].doctorProfilePic ?? '';
    doctorSocialProfile = getSortedPatientChatListModel
            .value.data?[index].doctorSocialProfilePic ??
        '';

    getAllPatientChatMessages.value.patientChatList?.clear();
    Doctor doctor = Doctor(
      chatKey: sortedPatientChat.chatKey,
      firstName: sortedPatientChat.doctorFirstName,
      lastName: sortedPatientChat.doctorLastName,
      socialProfilePic: sortedPatientChat.doctorSocialProfilePic,
      profilePic: sortedPatientChat.doctorProfilePic,
      id: sortedPatientChat.doctorId,
    );
    getAllPatientChatMessagesList(
        getSortedPatientChatListModel.value.data?[index].chatKey ?? "");

    log('sortedPatientChat---------->>>>>>>>${json.encode(sortedPatientChat)}');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MessagesDetailPage(
          sortedPatientChat: sortedPatientChat,
          doctor: doctor,
        ),
      ),
    );
  }

  Future<void> onTapDoctorDetail(BuildContext context,
      SortedPatientChat sortedPatientChat, Appointment doctors) async {
    chatKey.value = sortedPatientChat.chatKey ?? "";
    doctorName.value = sortedPatientChat.doctorFirstName ?? "";
    doctorLastName.value = sortedPatientChat.doctorLastName ?? "";
    doctorId.value = sortedPatientChat.doctorId ?? "";
    toId.value = sortedPatientChat.doctorId ?? "";

    doctorProfile = sortedPatientChat.doctorProfilePic ?? '';
    doctorSocialProfile = sortedPatientChat.doctorSocialProfilePic ?? '';

    getAllPatientChatMessages.value.patientChatList?.clear();

    getAllPatientChatMessagesList(sortedPatientChat.chatKey ?? "");
    Doctor doctor = Doctor(
      chatKey: sortedPatientChat.chatKey,
      firstName: doctors.doctorFirstName,
      lastName: doctors.doctorLastName,
      socialProfilePic: doctors.doctorSocialProfilePic,
      profilePic: doctors.doctorProfilePic,
      id: doctors.doctorId,
      speciality: doctors.doctorSpeciality,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MessagesDetailPage(
          sortedPatientChat: sortedPatientChat,
          doctor: doctor,
        ),
      ),
    );
  }

  Future<void> onDetailsTap(int index, BuildContext context,
      SortedPatientChat sortedPatientChat) async {
    chatKey.value =
        getSortedPatientChatListModel.value.data?[index].chatKey ?? "";
    doctorName.value =
        getSortedPatientChatListModel.value.data?[index].doctorFirstName ?? "";
    doctorLastName.value =
        getSortedPatientChatListModel.value.data?[index].doctorLastName ?? "";
    doctorId.value =
        getSortedPatientChatListModel.value.data?[index].doctorId ?? "";
    toId.value =
        getSortedPatientChatListModel.value.data?[index].doctorId ?? "";

    doctorProfile =
        getSortedPatientChatListModel.value.data?[index].doctorProfilePic ?? '';
    doctorSocialProfile = getSortedPatientChatListModel
            .value.data?[index].doctorSocialProfilePic ??
        '';

    getAllPatientChatMessages.value.patientChatList?.clear();

    getAllPatientChatMessagesList(
        getSortedPatientChatListModel.value.data?[index].chatKey ?? "");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MessagesDetailPage(
          sortedPatientChat: sortedPatientChat,
        ),
      ),
    );
  }

  Future<void> onDoctorTapFromDoctorList(
      BuildContext context, Doctor doctor) async {
    getAllPatientChatMessages.value.patientChatList?.clear();
    chatKey.value = doctor.chatKey ?? "";
    doctorName.value = doctor.firstName ?? "";
    doctorLastName.value = doctor.lastName ?? "";
    toId.value = doctor.id ?? "";
    doctorProfile = doctor.profilePic ?? "";

    await getAllPatientChatMessagesList(doctor.chatKey ?? '');
    if (!context.mounted) return;
    Navigator.of(context).pushNamed(Routes.chatDetail, arguments: doctor);
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getPatientHomePage();
        aboutUsPrivacyPolicy();
      },
    );
    super.onInit();
  }

  updateStatus({bool? isOnline}) async {
    Map<String, String> header = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
      "Content-Type": "application/json",
    };
    final response = await http.post(
      Uri.parse(
          '${Constants.baseUrl + Constants.chatStatus}${"${_userController.user.value.id}"}'),
      headers: header,
      body: {"is_online": isOnline, "last_seen": DateTime.now().toString()},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
