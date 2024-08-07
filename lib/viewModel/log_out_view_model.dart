import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/chat_status_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/log_out_repo.dart';

import '../newModel/apiModel/responseModel/message_status_response_model.dart';

class LogOutController extends GetxController {
  ApiResponse patientLogOutApiResponse = ApiResponse.initial('Initial');
  ApiResponse doctorLogOutApiResponse = ApiResponse.initial('Initial');
  ApiResponse getChatStatusApiResponse = ApiResponse.initial('Initial');
  ApiResponse addChatStatusApiResponse = ApiResponse.initial('Initial');
  final UserController userController = Get.find();

  ///patient logout
  Future<void> patientLogOut() async {
    patientLogOutApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response =
          await LogOutRepo().patientLogOutRepo(userController.user.value.id);
      patientLogOutApiResponse = ApiResponse.complete(response);
    } catch (e) {
      patientLogOutApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///doctor logout
  Future<void> doctorLogOut() async {
    doctorLogOutApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response =
          await LogOutRepo().doctorLogOutRepo(userController.user.value.id);
      doctorLogOutApiResponse = ApiResponse.complete(response);
    } catch (e) {
      doctorLogOutApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///request list.
  Future<void> getChatStatus({required String id}) async {
    getChatStatusApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ChatStatusResponseModel response =
          await LogOutRepo().chatOnlineStatusRepo(id: id);

      getChatStatusApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getChatStatusApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///doctor logout
  Future<void> addChatStatus(
      {required AddChatOnlineStatusReqModel model}) async {
    addChatStatusApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ChatStatusResponseModel response = await LogOutRepo()
          .addChatOnlineStatusRepo(
              model: model, id: userController.user.value.id);
      addChatStatusApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addChatStatusApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
