import 'dart:async';
import 'package:get/get.dart';
import 'package:united_natives/viewModel/patient_homescreen_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';

class TimerChange {
  static Timer? timer;
  // static DoctorHomeScreenController _doctorHomeScreenController =
  //     Get.find<DoctorHomeScreenController>();
  final UserController _userController = Get.find<UserController>();
  AddNewChatMessageController addNewChatMessageController =
      Get.put(AddNewChatMessageController());

  static PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>()..getSortedPatientChatList();
  void docTimerChange() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      addNewChatMessageController.getSortedChatListDoctor(
          doctorId: _userController.user.value.id);
      // _doctorHomeScreenController.getSortedChatListDoctor();
    });
  }

  Future<void> patientTimerChange() async {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      patientHomeScreenController.getSortedPatientChatList();
    });
  }
}
