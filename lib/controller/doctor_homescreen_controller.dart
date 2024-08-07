import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/model/aboutus_privacy_policy_doctor_model.dart';
import 'package:doctor_appointment_booking/model/add_prescription_model.dart';
import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/model/cancle_appointment_doctor.dart';
import 'package:doctor_appointment_booking/model/delete_chat_messages_response_model.dart';
import 'package:doctor_appointment_booking/model/doctor_availability_display_model.dart';
import 'package:doctor_appointment_booking/model/doctor_availability_model.dart';
import 'package:doctor_appointment_booking/model/doctor_get_doctor_Appointments_model.dart';
import 'package:doctor_appointment_booking/model/doctor_homepage_model.dart';
import 'package:doctor_appointment_booking/model/doctor_multiple_availability_model.dart';
import 'package:doctor_appointment_booking/model/doctor_next_appointment_model.dart';
import 'package:doctor_appointment_booking/model/doctor_prescription_model.dart';
import 'package:doctor_appointment_booking/model/doctor_research_document_details_model.dart';
import 'package:doctor_appointment_booking/model/doctor_research_document_model.dart';
import 'package:doctor_appointment_booking/model/get_all_chat_messeage_doctor.dart';
import 'package:doctor_appointment_booking/model/get_all_patient_response_model.dart';
import 'package:doctor_appointment_booking/model/get_new_message_doctor_model.dart';
import 'package:doctor_appointment_booking/model/get_sorted_chat_list_doctor_model.dart';
import 'package:doctor_appointment_booking/model/patient_detail_model.dart';
import 'package:doctor_appointment_booking/model/start_appointment_doctor.dart';
import 'package:doctor_appointment_booking/model/visited_patient_model.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/sevices/doctor_home_screen_service.dart';
import 'package:doctor_appointment_booking/utils/exception.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/add_new_chat_message_view_model.dart';
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
  // List<PatientAppoint> pastAppointmentData = [];
  List<ShortedDoctorChat> newDataList = [];
  List<Patient> patient = [];

  // RxString chatKey = "".obs;
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
  Timer timer;

  // RxString patientName = "".obs;
  // RxString patientLastName = "".obs;

  Rx<ShortedDoctorChat> doctorChat = ShortedDoctorChat().obs;
  Rx<Patient> patientChat = Patient().obs;

  UserController _userController = Get.find<UserController>();

  ///*****getAllChatMessagesDoctor Controller*****
  // Future<GetAllChatMessagesDoctor> getAllChatMessagesDoctor(chatKey) async {
  //   try {
  //     isLoading.value = true;
  //     getAllChatMessagesDoctorModel.value = await DoctorHomeScreenService()
  //         .getAllChatMessagesDoctor(chatKey: chatKey);
  //     isLoading.value = false;
  //   } catch (isBlank) {
  //     isLoading.value = false;
  //     Utils.showSnackBar(
  //         title: 'Error Occurred', message: 'Something went wrong');
  //   }
  //   return getAllChatMessagesDoctorModel.value;
  // }

  final pastController = TextEditingController();
  final prescriptionController = TextEditingController();

  Future<GetAllChatMessagesDoctor> getAllChatMessagesDoctor(
      {bool isAll = false, String chatKey}) async {
    try {
      print('de');
      getAllChatMessagesDoctorModel.value.apiState = APIState.PROCESSING;
      getAllChatMessagesDoctorModel.value = await DoctorHomeScreenService()
          .getAllChatMessagesDoctor(
              chatKey: isAll == true ? chatKey : doctorChat.value.chatKey,
              id: _userController.user.value.id);
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
    chatKey.value = doctor?.chatKey ?? "";
    doctorName.value = doctor?.firstName ?? "";
    doctorLastName.value = doctor?.lastName ?? "";
    toId.value = doctor?.id ?? "";
    doctorProfile = doctor.profilePic;
    getAllChatMessagesDoctorModel.value?.doctorChatList?.clear();

    getAllChatMessagesDoctor();

    Navigator.of(context).pushNamed(Routes.chatDetail, arguments: doctor);
  }

  ///*****getAllChatMessagesDoctor Controller*****
  Future<GetSortedChatListDoctor> getSortedChatListDoctor() async {
    try {
      isLoading.value = true;
      getSortedChatListDoctorModel.value.apiState = APIState.PROCESSING;
      getSortedChatListDoctorModel.value = await DoctorHomeScreenService()
          .getSortedChatListDoctor(doctorId: _userController.user.value.id);
      isLoading.value = false;
    } catch (isBlank) {
      getSortedChatListDoctorModel.value.apiState = APIState.ERROR;
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    newDataList = getSortedChatListDoctorModel?.value?.doctorChatList ?? [];
    return getSortedChatListDoctorModel.value;
  }

  ///*****DELETE DOCTOR CHAT MESSAGE*****
  Future<DeleteChatMessageResponseModel> deleteDoctorMessage(String id) async {
    try {
      isLoading1.value = true;
      Navigator.of(Get.overlayContext).pop();
      deleteChatMessageResponseModel = await DoctorHomeScreenService()
          .deleteChatMsg(doctorId: _userController.user.value.id, id: id);
      isLoading1.value = false;
    } catch (isBlank) {
      isLoading1.value = false;
      Utils.showSnackBar('Error Occurred', 'Something went wrong');
    }
    return deleteChatMessageResponseModel;
  }

  ///****call Timer function for chat messages****
  bool isLoadingOne = false;
  void getAllChatMessages({String chatKey, String id}) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      await addNewChatMessageController
          .allChatMessage(chatKey: chatKey, id: id)
          .then((value) {
        // if (isLoadingOne == true) {
        isLoadingOne = false;
        update();
        // }
      });
    });

    // timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
    //   getAllChatMessagesDoctor();
    // });
  }

  void getAllChatMessagesPatient({String chatKey, String id}) {
    if (chatKey != '') {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
        await addNewChatMessageController.allChatMessage(
            chatKey: chatKey, id: id);
        // getAllChatMessagesDoctor(isAll: true, chatKey: chatKey);
      });
    }
  }

  ///****End Timer function for chat messages****
  bool isClick = false;
  Future<bool> endTimer() async {
    // if (isClick == true) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      timer.cancel();
    });
    return true;
    // }
  }

  ///******** PatientPastAppointment ********
  // Future<PatientAppoint> getPastPatientAppointment(String value) {
  //   pastAppointmentData = [];
  //
  //   for (var element in doctorAppointmentsModelData.past) {
  //     if (element.patientFirstName
  //             .toLowerCase()
  //             .contains(value.toLowerCase()) ||
  //         element.patientLastName.toLowerCase().contains(value.toLowerCase()) ||
  //         element.patientFullName.toLowerCase().contains(value.toLowerCase()) ||
  //         element.purposeOfVisit.toLowerCase().contains(value.toLowerCase())) {
  //       pastAppointmentData.add(element);
  //       update();
  //     }
  //   }
  //   debugPrint("/////-------${pastAppointmentData.length}");
  // }

  ///*****createNewMessageDoctor Controller*****
  Future<CreateNewMessage> createNewMessageDoctor(
      {String fromType,
      fromId,
      toType,
      toId,
      message,
      chatKey,
      File attachment}) async {
    try {
      isLoading.value = true;
      createNewMessageDoctorModel.value = await DoctorHomeScreenService()
          .createNewMessageDoctor(
              chatKey: chatKey,
              fromType: fromType,
              fromId: fromId,
              message: message,
              attachment: attachment,
              toId: toId,
              toType: toType);
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
          .doctorHomePage(userId: _userController.user.value.id);

      doctorHomePageModelData.value.data.upcomingAppointments.removeWhere(
          (element) =>
              element.appointmentStatus == "3" ||
              element.appointmentStatus == "2");

      // doctorHomePageModelData.value.data.upcomingAppointments
      //     .forEach((element) async {
      //   var body = {
      //     "doctor_id": element.doctorId,
      //     "meeting_id": element.meetingData.id
      //   };
      //
      //   try {
      //     http.Response call = await http.post(
      //         Uri.parse(
      //             "${Constants.baseUrl}${Constants.doctorZoomMeetStatus}"),
      //         body: body,
      //         headers: Config.getHeaders());
      //
      //     var result = jsonDecode(call.body);
      //
      //     if (result['status'] == 'Success') {
      //       if (result['data']["meeting_status"] == "rejoin") {
      //         element.isRejoin = true;
      //       }
      //     } else {
      //       element.isRejoin = false;
      //     }
      //   } catch (e, stackStrace) {
      //     throw AppException.exceptionHandler(e, stackStrace);
      //   }
      // });

      print(
          "Doctor Home Page:--->>>>>${doctorHomePageModelData.value.data.pastAppointments}");
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
    await getDoctorAvailabilityDisplay(_userController.user.value.id,
        '${DateFormat("yyyy-MM-dd").format(DateTime.now())}');

    PostedDateAvailabilityClass iterable =
        doctorAvailabilityForDisplayOnlyModelData
            ?.value?.data?.postedDateAvailability;

    DateTime date = iterable?.availDate;

    if (date == null) {
      filterLoading = false;
      update();
      return;
    }

    PostedDateAvailabilityClass availability = iterable;

    availability.availData.forEach(
      (element) {
        String startTime =
            "${element.startTime.toLocal().hour > 12 ? element.startTime.toLocal().hour - 12 : element.startTime.toLocal().hour}:${element.startTime.toLocal().minute == 0 ? "00" : element.startTime.toLocal().minute}";
        String endTime =
            "${element.endTime.toLocal().hour > 12 ? element.endTime.toLocal().hour - 12 : element.endTime.toLocal().hour}:${element.endTime.toLocal().minute == 0 ? "00" : element.endTime.toLocal().minute} ${element.endTime.toLocal().hour >= 12 ? "PM" : "AM"}";
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

      print(
          '+++++++++++++++++++++++++++${startAppointmentDoctorData.value.message}+++++++++++++++++++');
      print(
          '+++++++++++++++++++++++++++${startAppointmentDoctorData.value.status}+++++++++++++++++++');
      // Utils.showSnackBar(
      //     title: '${startAppointmentDoctorData.value.message}',
      //     message: '${startAppointmentDoctorData.value.status}');
    } catch (isBlank) {
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return startAppointmentDoctorData.value;
  }

  ///*****getVisitedPatient Controller*****
  Future<VisitedPatientModel> getVisitedPatient({String patientId}) async {
    try {
      print('DEMO');
      // isLoading.value = true;
      visitedPatientModelData.apiState = APIState.PROCESSING;
      print('DEMO11');

      visitedPatientModelData = await DoctorHomeScreenService()
          .getVisitedPatient(
              doctorId: _userController.user.value.id, patientId: patientId);

      print('DEMO1341');
      // isLoading.value = false;
    } catch (isBlank) {
      print('DEMO11');
      print('DEMO>>>>>$isBlank');

      visitedPatientModelData.apiState = APIState.ERROR;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return visitedPatientModelData;
  }

  ///*****getPatientDetails Controller*****
  Future<PatientDetailsResponseModel> getPatientDetails() async {
    try {
      print('DEMO');
      // isLoading.value = true;
      patientDetailsResponseModel.apiState = APIState.PROCESSING;
      print('DEMO11');

      patientDetailsResponseModel = await DoctorHomeScreenService()
          .getPatientDetails(doctorId: _userController.user.value.id);

      print('DEMO1341');
      // isLoading.value = false;
    } catch (isBlank) {
      print('DEMO11');
      print('DEMO>>>>>$isBlank');

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
              doctorId: _userController.user.value.id,
              patientId: patientId,
              appointmentId: appointmentId);

      if (doctorPrescriptionsModelData.apiState == APIState.COMPLETE) {
        if (doctorPrescriptionsModelData.doctorPrescription.isNotEmpty) {
          Set appointmentId = {};
          doctorPrescriptionsModelData.doctorPrescription.forEach((element) {
            appointmentId.add(element.appointmentId);
          });
          appointmentId.toList().forEach((element1) {
            final tempData = doctorPrescriptionsModelData.doctorPrescription
                ?.where((element) => element.appointmentId == element1)
                ?.toList();
            doctorPrescription.add(tempData.first);
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

      if (doctorPrescriptionsModelData.doctorPrescription.isEmpty) {
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
        if ("${element.patientFirstName.toLowerCase()}${element.patientLastName.toLowerCase()}"
                .replaceAll(" ", "")
                .contains(value.toLowerCase().replaceAll(" ", "")) ||
            element.purposeOfVisit
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
    // aboutUsPrivacyPolicy();
    try {
      getAllPatient.apiState = APIState.PROCESSING;
      getAllPatient = await DoctorHomeScreenService()
          .getAllPatient(doctorId: _userController.user.value.id);

      print('SUCCESS::::::>>>$getAllPatient');
    } catch (isBlank) {
      getAllPatient.apiState = APIState.ERROR;
      // update();
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    update();
    return getAllPatient;
  }

  ///*****getResearchDoctors Controller*****

  Future<DoctorResearchDocumentModel> getDoctorResearchDocument() async {
    try {
      // isLoading.value = true;
      doctorResearchDocumentModelData.value.apiState = APIState.PROCESSING;
      doctorResearchDocumentModelData.value = await DoctorHomeScreenService()
          .doctorResearchDocumentModel(userId: _userController.user.value.id);
      // isLoading.value = false;
    } catch (isBlank) {
      // isLoading.value = false;
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
              userId: _userController.user.value.id, documentId: documentId);
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
        doctorId: _userController.user.value.id,
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
          .doctorAppoinmentsModel(doctorId: _userController.user.value.id);

      print('DOCTOR APPOINTMENT$doctorAppointmentsModelData');

      doctorAppointmentsModelData?.past?.sort(
        (a, b) {
          String dateA = "${b.appointmentDate} ${b.appointmentTime}";
          String dateB = "${a.appointmentDate} ${a.appointmentTime}";
          return DateTime.parse(dateA).compareTo(DateTime.parse(dateB));
        },
      );

      pastAppointmentData = doctorAppointmentsModelData.past;

      pastAppointmentData1 = jsonEncode(pastAppointmentData);
    } catch (isBlank) {
      print('ERROR');
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
        if ("${element.patientFirstName.toLowerCase()}${element.patientLastName.toLowerCase()}"
                .replaceAll(" ", "")
                .contains(searchValue.toLowerCase().replaceAll(" ", "")) ||
            element.purposeOfVisit
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

      print('DOCTOR APPOINTMENT$doctorAppointmentsModelData');
    } catch (isBlank) {
      print('ERROR');
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

  // ///*****getDoctorAvailability Controller*****
  //
  // Future<DoctorAvailabilityModel> getDoctorAvailabilityModel() async {
  //   try {
  //     // print("NewdoctorId=======>>>${_userController.user.value.id}");
  //     doctorAvailabilityModelData.value = await DoctorHomeScreenService()
  //         .doctorAvailabilityModel(dateTime: DateTime.now(), userId: _userController.user.value.id );
  //
  //     // print("NewdoctorData=======>>>${doctorAppointmentsModelData.value.data.past[0].createdDate.toString()}");
  //   } catch (isBlank) {
  //     Utils.showSnackBar(
  //         title: 'Error Occurred', message: 'Please try again later');
  //   }
  //
  //   return doctorAvailabilityModelData.value;
  // }
  Future<DoctorAvailability> getDoctorAvailability(
    String userId,
    dateTime,
    List<Map<String, dynamic>> availData,
    /* s0,
      s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13*/
  ) async {
    try {
      debugPrint("print1 => $dateTime");
      // print("print1 => $s0");
      // print("print1 => $s1");
      // print("print1 => $s2");
      // print("print1 => $s3");
      // print("print1 => $s4");
      // print("print1 => $s5");
      // print("print1 => $s6");
      // print("print1 => $s7");
      // print("print1 => $s8");
      // print("print1 => $s9");
      // print("print1 => $s10");
      // print("print1 => $s11");
      // print("print1 => $s12");
      // print("print1 => $s13");
      doctorAvailabilityData.value =
          await DoctorHomeScreenService().doctorAvailability(
        userId: userId, dateTime: dateTime, availData: availData,
        // s0: s0,
        // s1: s1,
        // s2: s2,
        // s3: s3,
        // s4: s4,
        // s5: s5,
        // s6: s6,
        // s7: s7,
        // s8: s8,
        // s9: s9,
        // s10: s10,
        // s11: s11,
        // s12: s12,
        // s13: s13,
      );
      if (doctorAvailabilityData.value != null) {
        // Get.toNamed(Routes.phoneAuthScreen)
        Utils.showSnackBar(
            'Update Successfully', 'Availability Updated Successfully');
      } else {
        Utils.showSnackBar('Update Error', 'Please try again later');
      }
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Update Error', e.message ?? '');
      }
    }
    return doctorAvailabilityData.value;
  }

  Future<DoctorMultipleAvailability> multipleDoctorAvailability(
    String userId,
    startTime,
    endTime,
    List<Map<String, dynamic>> availData,

    /* s0,
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
  ) async {
    try {
      debugPrint("print1 => $startTime");
      // log("print1 => $endTime");
      // print("print1 => $s0");
      // print("print1 => $s1");
      // print("print1 => $s2");
      // print("print1 => $s3");
      // print("print1 => $s4");
      // print("print1 => $s5");
      // print("print1 => $s6");
      // print("print1 => $s7");
      // print("print1 => $s8");
      // print("print1 => $s9");
      // print("print1 => $s10");
      // print("print1 => $s11");
      // print("print1 => $s12");
      // print("print1 => $s13");
      multiPleDoctorAvailability.value = await DoctorHomeScreenService()
          .doctorMultipleAvailability(
              userId: userId,
              startTime: startTime,
              endTime: endTime,
              availData: availData
              // s0: s0,
              // s1: s1,
              // s2: s2,
              // s3: s3,
              // s4: s4,
              // s5: s5,
              // s6: s6,
              // s7: s7,
              // s8: s8,
              // s9: s9,
              // s10: s10,
              // s11: s11,
              // s12: s12,
              // s13: s13,
              );
      if (multiPleDoctorAvailability.value != null) {
        // Get.toNamed(Routes.phoneAuthScreen)

        Utils.showSnackBar(
            'Update Successfully', 'Availability Updated Successfully');
      } else {
        Utils.showSnackBar('Update Error', 'Please try again later');
      }
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Update Error', e.message ?? '');
      }
    }
    return multiPleDoctorAvailability.value;
  }

  @override
  void onInit() async {
    // getVisitedPatient();
    // getDoctorPrescriptions();
    // getDoctorResearchDocument();
    // getDoctorNextAppointment();
    // getDoctorAvailability();

    await aboutUsPrivacyPolicy();
    super.onInit();
  }

  void callDoctorHomeScreenApi() {
    getDoctorHomePage();
  }
}
