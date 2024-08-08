import 'dart:developer';

import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_chat_status_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/chat_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class LogOutRepo extends BaseService {
  /// patient logout
  Future<MessageStatusResponseModel> patientLogOutRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: patientLogOutURL,
      body: {"user_id": id, "device_token": Prefs.getString(Prefs.FcmToken)},
    );
    log("logout  class res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }

  /// doctor logout
  Future<MessageStatusResponseModel> doctorLogOutRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: doctorLogoutURL,
      body: {"user_id": id, "device_token": Prefs.getString(Prefs.FcmToken)},
    );
    log("logout  class res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }

  /// get chat online status
  Future<dynamic> chatOnlineStatusRepo({String? id}) async {
    String url = '$chatStatusURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);

    ChatStatusResponseModel chatStatusResponseModel =
        ChatStatusResponseModel.fromJson(response);

    return chatStatusResponseModel;
  }

  /// add chat online status
  Future<ChatStatusResponseModel> addChatOnlineStatusRepo(
      {AddChatOnlineStatusReqModel? model, String? id}) async {
    String url = '$chatStatusURL/$id';
    dynamic body = await model?.toJson();

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: url,
      body: body,
    );

    ChatStatusResponseModel chatStatusResponseModel =
        ChatStatusResponseModel.fromJson(response);
    return chatStatusResponseModel;
  }
}
