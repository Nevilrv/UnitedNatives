import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/newModel/apiModel/responseModel/services_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/services_repo.dart';

class ServicesDataController extends GetxController {
  ApiResponse getServicesPatientApiResponse = ApiResponse.initial('Initial');
  ApiResponse getServicesDoctorApiResponse = ApiResponse.initial('Initial');
  final UserController userController = Get.find();

  ///doctor services
  Future<void> getServicesPatient() async {
    getServicesPatientApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ServicesResponseModel response = await ServicesRepo()
          .getServicesPatientRepo("${userController.user.value.id}");

      getServicesPatientApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getServicesPatientApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///patient services
  Future<void> getServicesDoctor() async {
    getServicesDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ServicesResponseModel response = await ServicesRepo()
          .getServicesDoctorRepo("${userController.user.value.id}");

      getServicesDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getServicesDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
