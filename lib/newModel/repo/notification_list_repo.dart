import 'dart:developer';

import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/notification_list_response_model.dart';
import 'package:doctor_appointment_booking/newModel/services/api_service.dart';
import 'package:doctor_appointment_booking/newModel/services/base_service.dart';

class NotificationListRepo extends BaseService {
  /// notification list.......

  Future<dynamic> notificationListRepo(String id) async {
    String url = getNotificationListURL + id;

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    log('RESPONSE NOTIFICATION  $response');
    NotificationListResponseModel notificationListResponseModel =
        NotificationListResponseModel.fromJson(response);

    return notificationListResponseModel;
  }

  Future<dynamic> deleteNotificationRepo({String id, String userID}) async {
    String url = deleteNotificationURL + id + '/' + userID;

    var response =
        await ApiService().getResponse(apiType: APIType.aDelete, url: url);
    print('RESPONSE   $response');
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);

    return messageStatusResponseModel;
  }

  Future<dynamic> deleteAllNotificationRepo({String userID}) async {
    String url = deleteAllNotificationURL + 'all_notification' + '/' + userID;

    var response =
        await ApiService().getResponse(apiType: APIType.aDelete, url: url);
    print('RESPONSE   $response');
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);

    return messageStatusResponseModel;
  }
}
