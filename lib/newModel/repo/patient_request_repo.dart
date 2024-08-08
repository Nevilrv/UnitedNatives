import 'dart:developer';

import 'package:united_natives/newModel/apiModel/requestModel/patient_add_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/patient_all_request_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/patient_request_list_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class RequestRepo extends BaseService {
  /// doctor add class........

  Future<MessageStatusResponseModel> addRequestRepo(
      {AddRequestModel? model, String? id}) async {
    String url = '$addRequestURL/$id';
    var body = await model?.toJson();

    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: body!, withoutTypeHeader: true);
    log("ADD CLASS RESPONSE ::: $response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }

  /// request list.......

  Future<dynamic> requestListRepo(String id) async {
    String url = '$requestListsURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    RequestListResponseModel requestListResponseModel =
        RequestListResponseModel.fromJson(response);

    return requestListResponseModel;
  }

  /// all request.......

  Future<dynamic> allRequestRepo(String id) async {
    String url = '$allRequestURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    AllRequestResponseModel allRequestResponseModel =
        AllRequestResponseModel.fromJson(response);

    return allRequestResponseModel;
  }
}
