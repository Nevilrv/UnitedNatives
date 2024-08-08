import 'dart:developer';

import 'package:united_natives/newModel/apiModel/requestModel/add_maintenance_req_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_room_data_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/room_detail_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class RoomRepo extends BaseService {
  /// patient class list.......

  Future<dynamic> getRoomDetailRepo(String id) async {
    String url = '$roomsURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    // print('RESPONSE   $response');
    RoomDetailResponseModel roomDetailResponseModel =
        RoomDetailResponseModel.fromJson(response);

    return roomDetailResponseModel;
  }

  Future<MessageStatusResponseModel> addRoomsDetailRepo(
      {AddRoomDetailsReqModel? model, String? id, String? userId}) async {
    String url = '$roomsURL/$id/$userId';

    var body = await model?.toJson();
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: body!, fileUpload: true);
    log("add class res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }

  Future<MessageStatusResponseModel> updateRoomsDetailRepo(
      {UpdateRoomDetailsReqModel? model, String? id, String? userId}) async {
    String url = '$roomsURL/$id/$userId';

    var body = await model?.toJson();
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: body!, fileUpload: true);
    log("add class res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }

  Future<MessageStatusResponseModel> updateRoomsDetailWithoutImgRepo(
      {UpdateRoomWithoutImgReqModel? model, String? id, String? userId}) async {
    String url = '$roomsURL/$id/$userId';

    var body = await model?.toJson();
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: body!, fileUpload: true);
    log("add class res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }

  ///
  Future<dynamic> deleteRoomRepo({String? id, String? userId}) async {
    String url = '$deleteRoomsURL/$id/$userId';

    var response =
        await ApiService().getResponse(apiType: APIType.aDelete, url: url);
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);

    return messageStatusResponseModel;
  }

  ///add maintenance
  Future<MessageStatusResponseModel> addMaintenanceRepo(
      {AddMaintenanceModel? model, String? id, String? userId}) async {
    String url = '$addMaintenanceRoomsURL/$id/$userId';
    var body = await model?.toJson();
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: body!, withoutTypeHeader: true);
    log("add res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }
}
