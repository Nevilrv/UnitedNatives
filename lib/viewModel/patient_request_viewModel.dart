import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/newModel/apiModel/requestModel/patient_add_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/patient_all_request_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/patient_request_list_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/patient_request_repo.dart';

class RequestController extends GetxController {
  ApiResponse addRequestApiResponse = ApiResponse.initial('Initial');
  ApiResponse getRequestListApiResponse = ApiResponse.initial('Initial');
  ApiResponse allRequestApiResponse = ApiResponse.initial('Initial');
  final UserController userController = Get.find();

  ///doctor add class
  Future<void> addRequest({required AddRequestModel model}) async {
    addRequestApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await RequestRepo()
          .addRequestRepo(model: model, id: userController.user.value.id);
      addRequestApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addRequestApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///request list.
  Future<void> getRequestList() async {
    getRequestListApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      RequestListResponseModel response = await RequestRepo()
          .requestListRepo("${userController.user.value.id}");

      getRequestListApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getRequestListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///all request .
  Future<void> allRequest() async {
    allRequestApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AllRequestResponseModel response =
          await RequestRepo().allRequestRepo("${userController.user.value.id}");

      allRequestApiResponse = ApiResponse.complete(response);
    } catch (e) {
      allRequestApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
