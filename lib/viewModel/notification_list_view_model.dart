import 'dart:developer';
import 'package:get/get.dart';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/notification_list_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/notification_list_repo.dart';

class NotificationListController extends GetxController {
  ApiResponse getNotificationListApiResponse = ApiResponse.initial('Initial');
  ApiResponse deleteNotificationApiResponse = ApiResponse.initial('Initial');
  ApiResponse deleteAllNotificationApiResponse = ApiResponse.initial('Initial');
  final UserController userController = Get.find();

  ///request list.
  Future<void> getNotificationList() async {
    if (getNotificationListApiResponse.status == Status.INITIAL) {
      getNotificationListApiResponse = ApiResponse.loading('Loading');
    }

    update();
    try {
      NotificationListResponseModel response = await NotificationListRepo()
          .notificationListRepo("${userController.user.value.id}");

      log('response-----NOTIFICATION----->>>>>>>>$response');

      getNotificationListApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getNotificationListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///delete room details
  Future<void> deletNotification({required String id}) async {
    deleteNotificationApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await NotificationListRepo()
          .deleteNotificationRepo(id: id, userID: userController.user.value.id);

      deleteNotificationApiResponse = ApiResponse.complete(response);
    } catch (e) {
      deleteNotificationApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> deleteAllNotification() async {
    deleteAllNotificationApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await NotificationListRepo()
          .deleteAllNotificationRepo(userID: userController.user.value.id);

      deleteAllNotificationApiResponse = ApiResponse.complete(response);
    } catch (e) {
      deleteAllNotificationApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
