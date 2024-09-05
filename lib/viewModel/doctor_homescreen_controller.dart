import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/ResponseModel/aboutus_privacy_policy_doctor_model.dart';
import 'package:united_natives/ResponseModel/add_prescription_model.dart';
import 'package:united_natives/ResponseModel/api_state_enum.dart';
import 'package:united_natives/ResponseModel/cancle_appointment_doctor.dart';
import 'package:united_natives/ResponseModel/delete_chat_messages_response_model.dart';
import 'package:united_natives/ResponseModel/doctor_availability_display_model.dart';
import 'package:united_natives/ResponseModel/doctor_availability_model.dart';
import 'package:united_natives/ResponseModel/doctor_get_doctor_Appointments_model.dart';
import 'package:united_natives/ResponseModel/doctor_homepage_model.dart';
import 'package:united_natives/ResponseModel/doctor_multiple_availability_model.dart';
import 'package:united_natives/ResponseModel/doctor_next_appointment_model.dart';
import 'package:united_natives/ResponseModel/doctor_prescription_model.dart';
import 'package:united_natives/ResponseModel/doctor_research_document_details_model.dart';
import 'package:united_natives/ResponseModel/doctor_research_document_model.dart';
import 'package:united_natives/ResponseModel/get_all_chat_messeage_doctor.dart';
import 'package:united_natives/ResponseModel/get_all_patient_response_model.dart';
import 'package:united_natives/ResponseModel/get_new_message_doctor_model.dart';
import 'package:united_natives/ResponseModel/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/ResponseModel/patient_detail_model.dart';
import 'package:united_natives/ResponseModel/start_appointment_doctor.dart';
import 'package:united_natives/ResponseModel/visited_patient_model.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/sevices/doctor_home_screen_service.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';

class DoctorHomeScreenController extends GetxController {
  VisitedPatientModel visitedPatientModelData = VisitedPatientModel();
  PatientDetailsResponseModel patientDetailsResponseModel =
      PatientDetailsResponseModel();

  DoctorPrescriptionModel doctorPrescriptionsModelData =
      DoctorPrescriptionModel();

  PatientAppoint patientAppoint = PatientAppoint();

  Rx<DoctorResearchDocumentModel> doctorResearchDocumentModelData =
      DoctorResearchDocumentModel().obs;
  Rx<DoctorHomePageModel> doctorHomePageModelData = DoctorHomePageModel().obs;
  Rx<DoctorResearchDocumentDetailsModel>
      doctorResearchDocumentDetailsModelData =
      DoctorResearchDocumentDetailsModel().obs;
  DoctorAppointmentsModel doctorAppointmentsModelData =
      DoctorAppointmentsModel();

  String pastAppointmentData1 = '';

  List<PatientAppoint> pastAppointmentData = [];

  List<DoctorPrescription> doctorPrescription = [];
  List<DoctorPrescription> searchDoctorPrescription = [];
  String doctorPrescription1 = '';

  Rx<DoctorNextAppointmentModel> doctorNextAppointmentModelData =
      DoctorNextAppointmentModel().obs;

  Rx<DoctorAvailability> doctorAvailabilityData = DoctorAvailability().obs;
  Rx<DoctorMultipleAvailability> multiPleDoctorAvailability =
      DoctorMultipleAvailability().obs;
  Rx<DoctorAvailabilityForDisplayOnlyModel>
      doctorAvailabilityForDisplayOnlyModelData =
      DoctorAvailabilityForDisplayOnlyModel().obs;
  Rx<AddPrescriptionModel> addPrescriptionData = AddPrescriptionModel().obs;
  Rx<CancelAppointmentDoctor> cancelAppointmentDoctorData =
      CancelAppointmentDoctor().obs;
  Rx<StartAppointmentDoctor> startAppointmentDoctorData =
      StartAppointmentDoctor().obs;
  Rx<AboutUsPrivacyPolicyDoctorModel> aboutUsPrivacyPolicyDoctorModel =
      AboutUsPrivacyPolicyDoctorModel().obs;
  Rx<GetAllChatMessagesDoctor> getAllChatMessagesDoctorModel =
      GetAllChatMessagesDoctor().obs;
  Rx<GetSortedChatListDoctor> getSortedChatListDoctorModel =
      GetSortedChatListDoctor().obs;
  AddNewChatMessageController addNewChatMessageController =
      Get.put(AddNewChatMessageController());

  DeleteChatMessageResponseModel deleteChatMessageResponseModel =
      Get.put(DeleteChatMessageResponseModel());

  Rx<CreateNewMessage> createNewMessageDoctorModel = CreateNewMessage().obs;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  GetAllPatient getAllPatient = GetAllPatient();
  List<ShortedDoctorChat> newDataList = [];
  List<Patient> patient = [];

  RxString fromType = "".obs;
  RxString fromId = "".obs;
  RxString toType = "".obs;
  RxString toId = "".obs;
  RxString message = "".obs;
  RxString attachment = "".obs;
  String doctorProfile = "";

  RxString doctorLastName = "".obs;
  RxString doctorName = "".obs;
  RxString chatKey = "".obs;
  Timer? timer;

  Rx<ShortedDoctorChat> doctorChat = ShortedDoctorChat().obs;
  Rx<Patient> patientChat = Patient().obs;

  final UserController _userController = Get.find<UserController>();

  final pastController = TextEditingController();
  final prescriptionController = TextEditingController();

  Future<GetAllChatMessagesDoctor> getAllChatMessagesDoctor(
      {bool isAll = false, String? chatKey}) async {
    try {
      getAllChatMessagesDoctorModel.value.apiState = APIState.PROCESSING;
      getAllChatMessagesDoctorModel.value = await DoctorHomeScreenService()
          .getAllChatMessagesDoctor(
              chatKey: isAll == true
                  ? (chatKey ?? "")
                  : "${doctorChat.value.chatKey}",
              id: "${_userController.user.value.id}");
    } catch (isBlank) {
      isLoading.value = false;
      getAllChatMessagesDoctorModel.value.apiState = APIState.ERROR;
      getAllChatMessagesDoctorModel.refresh();
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    return getAllChatMessagesDoctorModel.value;
  }

  Future<void> onPatientTapFromDoctorList(
      BuildContext context, Patient doctor) async {
    chatKey.value = doctor.chatKey ?? "";
    doctorName.value = doctor.firstName ?? "";
    doctorLastName.value = doctor.lastName ?? "";
    toId.value = doctor.id ?? "";
    doctorProfile = "${doctor.profilePic}";
    getAllChatMessagesDoctorModel.value.doctorChatList?.clear();

    getAllChatMessagesDoctor();

    Navigator.of(context).pushNamed(Routes.chatDetail, arguments: doctor);
  }

  ///*****getAllChatMessagesDoctor Controller*****
  Future<GetSortedChatListDoctor> getSortedChatListDoctor() async {
    try {
      isLoading.value = true;
      getSortedChatListDoctorModel.value.apiState = APIState.PROCESSING;
      getSortedChatListDoctorModel.value = await DoctorHomeScreenService()
          .getSortedChatListDoctor(
              doctorId: "${_userController.user.value.id}");
      isLoading.value = false;
    } catch (isBlank) {
      getSortedChatListDoctorModel.value.apiState = APIState.ERROR;
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    newDataList = getSortedChatListDoctorModel.value.doctorChatList ?? [];
    return getSortedChatListDoctorModel.value;
  }

  ///*****DELETE DOCTOR CHAT MESSAGE*****
  Future<DeleteChatMessageResponseModel> deleteDoctorMessage(String id) async {
    try {
      isLoading1.value = true;
      Navigator.of(Get.overlayContext!).pop();
      deleteChatMessageResponseModel = await DoctorHomeScreenService()
          .deleteChatMsg(doctorId: "${_userController.user.value.id}", id: id);
      isLoading1.value = false;
    } catch (isBlank) {
      isLoading1.value = false;
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    return deleteChatMessageResponseModel;
  }

  ///****call Timer function for chat messages****
  bool isLoadingOne = false;
  void getAllChatMessages({String? chatKey, String? id}) {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      await addNewChatMessageController
          .allChatMessage(chatKey: chatKey, id: id)
          .then((value) {
        isLoadingOne = false;
        update();
      });
    });
  }

  void getAllChatMessagesPatient({String? chatKey, String? id}) {
    if (chatKey != '') {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        await addNewChatMessageController.allChatMessage(
            chatKey: chatKey, id: id);
      });
    }
  }

  ///****End Timer function for chat messages****
  bool isClick = false;
  Future<bool> endTimer() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timer?.cancel();
    });
    return true;
  }

  ///*****createNewMessageDoctor Controller*****
  Future<CreateNewMessage> createNewMessageDoctor(
      {String? fromType,
      fromId,
      toType,
      toId,
      message,
      chatKey,
      File? attachment}) async {
    try {
      isLoading.value = true;
      createNewMessageDoctorModel.value =
          await DoctorHomeScreenService().createNewMessageDoctor(
        chatKey: chatKey,
        fromType: fromType!,
        fromId: fromId,
        message: message,
        attachment: attachment ?? File(""),
        toId: toId,
        toType: toType,
      );
      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    return createNewMessageDoctorModel.value;
  }

  ///*****getPatientHomePage Controller*****
  Future<DoctorHomePageModel> getDoctorHomePage() async {
    try {
      isLoading.value = true;
      doctorHomePageModelData.value = await DoctorHomeScreenService()
          .doctorHomePage(userId: "${_userController.user.value.id}");

      doctorHomePageModelData.value.data?.upcomingAppointments?.removeWhere(
          (element) =>
              element.appointmentStatus == "3" ||
              element.appointmentStatus == "2");

      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar(
        "Error occurred",
        doctorHomePageModelData.value.message ?? "Please try again later",
      );
    }
    return doctorHomePageModelData.value;
  }

  int itemCount = 0;
  bool filterLoading = false;

  Future<void> filterData() async {
    filterLoading = true;
    itemCount = 0;

    update();
    await getDoctorAvailabilityDisplay("${_userController.user.value.id}",
        DateFormat("yyyy-MM-dd").format(DateTime.now()));

    PostedDateAvailabilityClass? iterable =
        doctorAvailabilityForDisplayOnlyModelData
            .value.data?.postedDateAvailability;

    DateTime? date = iterable?.availDate;

    if (date == null) {
      filterLoading = false;
      update();
      return;
    }

    PostedDateAvailabilityClass? availability = iterable;

    availability?.availData?.forEach(
      (element) {
        String startTime =
            "${element.startTime!.toLocal().hour > 12 ? element.startTime!.toLocal().hour - 12 : element.startTime?.toLocal().hour}:${element.startTime?.toLocal().minute == 0 ? "00" : element.startTime?.toLocal().minute}";
        String endTime =
            "${element.endTime!.toLocal().hour > 12 ? element.endTime!.toLocal().hour - 12 : element.endTime!.toLocal().hour}:${element.endTime!.toLocal().minute == 0 ? "00" : element.endTime!.toLocal().minute} ${element.endTime!.toLocal().hour >= 12 ? "PM" : "AM"}";
        if (element.avail == "1") {
          if (startTime == "8:00" && endTime == "9:00 AM") {
            itemCount++;
          }
          if (startTime == "9:00" && endTime == "10:00 AM") {
            itemCount++;
          }
          if (startTime == "10:00" && endTime == "11:00 AM") {
            itemCount++;
          }
          if (startTime == "11:00" && endTime == "12:00 PM") {
            itemCount++;
          }
          if (startTime == "12:00" && endTime == "1:00 PM") {
            itemCount++;
          }
          if (startTime == "1:00" && endTime == "2:00 PM") {
            itemCount++;
          }
          if (startTime == "2:00" && endTime == "3:00 PM") {
            itemCount++;
          }
          if (startTime == "3:00" && endTime == "4:00 PM") {
            itemCount++;
          }
          if (startTime == "4:00" && endTime == "5:00 PM") {
            itemCount++;
          }
          if (startTime == "5:00" && endTime == "6:00 PM") {
            itemCount++;
          }
          if (startTime == "6:00" && endTime == "7:00 PM") {
            itemCount++;
          }
          if (startTime == "7:00" && endTime == "8:00 PM") {
            itemCount++;
          }
          if (startTime == "8:00" && endTime == "9:00 PM") {
            itemCount++;
          }
        }
      },
    );

    filterLoading = false;
    update();
  }

  ///*****Display Doctor Availability Controller*****
  Future<DoctorAvailabilityForDisplayOnlyModel> getDoctorAvailabilityDisplay(
      String doctorId, availabilityDate) async {
    try {
      isLoading.value = true;
      doctorAvailabilityForDisplayOnlyModelData.value =
          await DoctorHomeScreenService().doctorAvailabilityDisplay(
              doctorId: doctorId, availabilityDate: availabilityDate);
      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      // Utils.showSnackBar(
      //     title: 'Doctor Availability',message: '');
    }
    return doctorAvailabilityForDisplayOnlyModelData.value;
  }

  ///*****Add Prescription Controller*****
  Future<AddPrescriptionModel> addPrescription(
      String doctorId,
      patientId,
      appointmentId,
      medicineName,
      whenToTake,
      additionalNotes,
      daysOfTreat,
      pillsPerDay) async {
    try {
      isLoading.value = true;
      addPrescriptionData.value = await DoctorHomeScreenService()
          .addPrescription(
              doctorId: doctorId,
              patientId: patientId,
              appointmentId: appointmentId,
              medicineName: medicineName,
              whenToTake: whenToTake,
              additionalNotes: additionalNotes,
              daysOfTreat: daysOfTreat,
              pillsPerDay: pillsPerDay);
      isLoading.value = false;
      Utils.showSnackBar(
        addPrescriptionData.value.status ?? "",
        addPrescriptionData.value.message ?? "",
      );
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar("Error Occured",
          addPrescriptionData.value.message ?? "Please try again later");
    }

    return addPrescriptionData.value;
  }

  ///*****Cancel Appointment Controller*****
  bool startLoader = false;
  Future<CancelAppointmentDoctor> cancelAppointmentPatient(
      String userId, appointmentId) async {
    try {
      startLoader = true;
      update();

      cancelAppointmentDoctorData.value = await DoctorHomeScreenService()
          .cancelAppointmentDoctor(
              userId: userId, appointmentId: appointmentId);
      await getDoctorAppointmentsModel();
      startLoader = false;
      update();
      Utils.showSnackBar('${cancelAppointmentDoctorData.value.message}',
          '${cancelAppointmentDoctorData.value.status}');
    } catch (isBlank) {
      startLoader = false;
      update();

      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return cancelAppointmentDoctorData.value;
  }

  ///*****Start Appointment Controller*****

  Future<StartAppointmentDoctor> startAppointmentPatient(
      String doctorId, appointmentId) async {
    try {
      startAppointmentDoctorData.value = await DoctorHomeScreenService()
          .startAppointmentDoctor(
              doctorId: doctorId, appointmentId: appointmentId);
    } catch (isBlank) {
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return startAppointmentDoctorData.value;
  }

  ///*****getVisitedPatient Controller*****
  Future<VisitedPatientModel> getVisitedPatient({String? patientId}) async {
    try {
      visitedPatientModelData.apiState = APIState.PROCESSING;

      visitedPatientModelData = await DoctorHomeScreenService()
          .getVisitedPatient(
              doctorId: "${_userController.user.value.id}",
              patientId: "$patientId");
    } catch (isBlank) {
      visitedPatientModelData.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return visitedPatientModelData;
  }

  ///*****getPatientDetails Controller*****
  Future<PatientDetailsResponseModel> getPatientDetails() async {
    try {
      patientDetailsResponseModel.apiState = APIState.PROCESSING;

      patientDetailsResponseModel = await DoctorHomeScreenService()
          .getPatientDetails(doctorId: "${_userController.user.value.id}");
    } catch (isBlank) {
      patientDetailsResponseModel.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return patientDetailsResponseModel;
  }

  ///*****getPatientPrescription Controller*****

  Future<DoctorPrescriptionModel> getDoctorPrescriptions(
      {String patientId = '', String appointmentId = ''}) async {
    try {
      doctorPrescriptionsModelData.apiState = APIState.PROCESSING;
      doctorPrescription = [];
      searchDoctorPrescription = [];
      doctorPrescription1 = '';
      doctorPrescriptionsModelData = await DoctorHomeScreenService()
          .doctorPrescriptionsModel(
              doctorId: "${_userController.user.value.id}",
              patientId: patientId,
              appointmentId: appointmentId);

      if (doctorPrescriptionsModelData.apiState == APIState.COMPLETE) {
        if (doctorPrescriptionsModelData.doctorPrescription!.isNotEmpty) {
          Set appointmentId = {};
          doctorPrescriptionsModelData.doctorPrescription?.forEach((element) {
            appointmentId.add(element.appointmentId);
          });
          appointmentId.toList().forEach((element1) {
            final tempData = doctorPrescriptionsModelData.doctorPrescription
                ?.where((element) => element.appointmentId == element1)
                .toList();
            doctorPrescription.add(tempData!.first);
          });

          doctorPrescription.sort(
            (a, b) {
              String dateA = "${b.appointmentDate} ${b.appointmentTime}";
              String dateB = "${a.appointmentDate} ${a.appointmentTime}";
              return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
            },
          );
          doctorPrescription1 = jsonEncode(doctorPrescription);
        }
      }

      if (doctorPrescriptionsModelData.doctorPrescription!.isEmpty) {
        doctorPrescriptionsModelData.apiState = APIState.COMPLETE_WITH_NO_DATA;
      }
    } catch (isBlank) {
      doctorPrescriptionsModelData.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return doctorPrescriptionsModelData;
  }

  searchPrescription(String value) {
    List<DoctorPrescription> temp = List<DoctorPrescription>.from(
        jsonDecode(doctorPrescription1)
            .map((x) => DoctorPrescription.fromJson(x)));
    if (value.isNotEmpty) {
      doctorPrescription.clear();
      for (var element in temp) {
        if ("${element.patientFirstName?.toLowerCase()}${element.patientLastName?.toLowerCase()}"
                .replaceAll(" ", "")
                .contains(value.toLowerCase().replaceAll(" ", "")) ||
            element.purposeOfVisit!
                .toLowerCase()
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(value.toLowerCase().replaceAll(" ", ""))) {
          doctorPrescription.add(element);
        }
      }
    } else {
      doctorPrescription = List<DoctorPrescription>.from(
          jsonDecode(doctorPrescription1)
              .map((x) => DoctorPrescription.fromJson(x)));
    }
    update();
  }

  ///***** GetPatientList Controller *****
  Future<GetAllPatient> getAllPatients() async {
    try {
      getAllPatient.apiState = APIState.PROCESSING;
      getAllPatient = await DoctorHomeScreenService()
          .getAllPatient(doctorId: "${_userController.user.value.id}");
    } catch (isBlank) {
      getAllPatient.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return getAllPatient;
  }

  ///*****getResearchDoctors Controller*****

  Future<DoctorResearchDocumentModel> getDoctorResearchDocument() async {
    try {
      doctorResearchDocumentModelData.value.apiState = APIState.PROCESSING;
      doctorResearchDocumentModelData.value = await DoctorHomeScreenService()
          .doctorResearchDocumentModel(
              userId: "${_userController.user.value.id}");
    } catch (isBlank) {
      doctorResearchDocumentModelData.value.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    doctorResearchDocumentModelData.refresh();
    return doctorResearchDocumentModelData.value;
  }

  ///*****getResearchDocumentDetails Controller*****

  Future<DoctorResearchDocumentDetailsModel> getDoctorResearchDocumentDetails(
      String documentId) async {
    try {
      doctorResearchDocumentDetailsModelData.value.apiState =
          APIState.PROCESSING;
      doctorResearchDocumentDetailsModelData.value =
          await DoctorHomeScreenService().doctorResearchDocumentDetailsModel(
              userId: "${_userController.user.value.id}",
              documentId: documentId);
    } catch (isBlank) {
      doctorResearchDocumentDetailsModelData.value.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    doctorResearchDocumentDetailsModelData.refresh();
    return doctorResearchDocumentDetailsModelData.value;
  }

  ///*****getDoctorNextAppointment Controller*****

  Future<DoctorNextAppointmentModel> getDoctorNextAppointment(
      String doctorId) async {
    try {
      isLoading.value = true;
      doctorNextAppointmentModelData.value =
          await DoctorHomeScreenService().doctorNextAppointmentModel(
        doctorId: "${_userController.user.value.id}",
      );
      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return doctorNextAppointmentModelData.value;
  }

  ///*****getDoctorAppointments Controller*****

  Future<DoctorAppointmentsModel> getDoctorAppointmentsModel() async {
    try {
      doctorAppointmentsModelData.apiState = APIState.PROCESSING;
      doctorAppointmentsModelData = await DoctorHomeScreenService()
          .doctorAppoinmentsModel(doctorId: "${_userController.user.value.id}");

      doctorAppointmentsModelData.past?.sort(
        (a, b) {
          String dateA = "${b.appointmentDate} ${b.appointmentTime}";
          String dateB = "${a.appointmentDate} ${a.appointmentTime}";
          return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
        },
      );

      pastAppointmentData = doctorAppointmentsModelData.past!;

      pastAppointmentData1 = jsonEncode(pastAppointmentData);
    } catch (isBlank) {
      doctorAppointmentsModelData.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return doctorAppointmentsModelData;
  }

  searchPastAppointment(String searchValue) {
    List<PatientAppoint> temp = List<PatientAppoint>.from(
        jsonDecode(pastAppointmentData1)
            .map((x) => PatientAppoint.fromJson(x)));
    if (searchValue.isNotEmpty) {
      pastAppointmentData.clear();
      for (var element in temp) {
        if ("${element.patientFirstName?.toLowerCase()}${element.patientLastName?.toLowerCase()}"
                .replaceAll(" ", "")
                .contains(searchValue.toLowerCase().replaceAll(" ", "")) ||
            element.purposeOfVisit!
                .toLowerCase()
                .toLowerCase()
                .replaceAll(" ", "")
                .contains(searchValue.toLowerCase().replaceAll(" ", ""))) {
          pastAppointmentData.add(element);
        }
      }
    } else {
      pastAppointmentData = List<PatientAppoint>.from(
          jsonDecode(pastAppointmentData1)
              .map((x) => PatientAppoint.fromJson(x)));
    }
    update();
  }

  ///*****getDoctorAppointments Controller*****

  Future<DoctorAppointmentsModel> getDoctorAppointmentsDOCID(
      String doctorId) async {
    try {
      doctorAppointmentsModelData.apiState = APIState.PROCESSING;
      doctorAppointmentsModelData = await DoctorHomeScreenService()
          .doctorAppoinmentsModel(doctorId: doctorId);
    } catch (isBlank) {
      doctorAppointmentsModelData.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return doctorAppointmentsModelData;
  }

  ///*****getAppSettingsPagesContent Controller*****
  Future<AboutUsPrivacyPolicyDoctorModel> aboutUsPrivacyPolicy() async {
    try {
      aboutUsPrivacyPolicyDoctorModel.value =
          await DoctorHomeScreenService().aboutUsPrivacyPolicy();
    } catch (isBlank) {
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    update();
    return aboutUsPrivacyPolicyDoctorModel.value;
  }

  Future<DoctorAvailability> getDoctorAvailability(
    String userId,
    dateTime,
    List<Map<String, dynamic>> availData,
  ) async {
    try {
      doctorAvailabilityData.value =
          await DoctorHomeScreenService().doctorAvailability(
        userId: userId,
        dateTime: dateTime,
        availData: availData,
      );
      Utils.showSnackBar(
          'Update Successfully', 'Availability Updated Successfully');
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Update Error', e.message);
      }
    }
    return doctorAvailabilityData.value;
  }

  Future<DoctorMultipleAvailability> multipleDoctorAvailability(
    String userId,
    startTime,
    endTime,
    List<Map<String, dynamic>> availData,
  ) async {
    try {
      multiPleDoctorAvailability.value = await DoctorHomeScreenService()
          .doctorMultipleAvailability(
              userId: userId,
              startTime: startTime,
              endTime: endTime,
              availData: availData);

      Utils.showSnackBar(
          'Update Successfully', 'Availability Updated Successfully');
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Update Error', e.message);
      }
    }
    return multiPleDoctorAvailability.value;
  }

  @override
  void onInit() async {
    await aboutUsPrivacyPolicy();
    super.onInit();
  }

  Future<void> callDoctorHomeScreenApi() async {
    await getDoctorHomePage();
  }
}
