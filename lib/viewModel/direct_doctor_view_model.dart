import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_direct_appointment_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_direct_appointment_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_doctor.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_direct_doctor_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/direct_doctor_repo.dart';

class DirectDoctorController extends GetxController {
  ApiResponse getDirectDoctorApiResponse = ApiResponse.initial('Initial');
  ApiResponse getAllDoctorApiResponse = ApiResponse.initial('Initial');
  ApiResponse addDirectAppointmentApiResponse = ApiResponse.initial('Initial');
  final UserController userController = Get.find();

  ///request list.
  Future<void> getDirectDoctor() async {
    getDirectDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      GetDirectDoctorResponseModel response = await DirectDoctorRepo()
          .getDirectDoctorRepo(userController.user.value.id);

      getDirectDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getDirectDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///add direct appointment....
  Future<void> addDirectAppointmentClass(
      AddDirectAppointmentReqModel model) async {
    addDirectAppointmentApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AddDirectAppointmentResponseModel response = await DirectDoctorRepo()
          .addDirectRequestRepo(model, userController.user.value.id);
      addDirectAppointmentApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addDirectAppointmentApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> getAllDoctor() async {
    getAllDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      GetAllDoctorResponseModel response =
          await DirectDoctorRepo().getAllDoctorRepo();

      getAllDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getAllDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
