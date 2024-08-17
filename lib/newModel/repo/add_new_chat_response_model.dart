import 'dart:developer';

import 'package:united_natives/model/get_all_chat_messeage_doctor.dart';
import 'package:united_natives/model/get_all_patient_messagelist_model.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_new_message.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_new_message_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class AddNewChatMessageRepo extends BaseService {
  /// doctor add new chat msg........

  Future<AddNewChatResponseModel> addNewChatMessageRepo(
      AddNewMessageReqModel model) async {
    var body = await model.toJson();
    var response = await ApiService().getResponse(
        apiType: APIType.aPost,
        url: newChatMessageURL,
        body: body,
        fileUpload: true);
    // log("add class res :${response}");
    AddNewChatResponseModel addNewChatResponseModel =
        AddNewChatResponseModel.fromJson(response);
    return addNewChatResponseModel;
  }

  Future<GetAllChatMessagesDoctor> allChatMessageRepo(
      {String? chatKey, String? id}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: allChatMessageURL,
      body: {"chat_key": chatKey, "doctor_id": id},
    );

    log("add class res :$response");
    GetAllChatMessagesDoctor getAllChatMessagesDoctor =
        GetAllChatMessagesDoctor.fromJson(response);
    return getAllChatMessagesDoctor;
  }

  Future<GetAllPatientChatMessages> allChatMessagePatientRepo(
      {String? chatKey, String? id}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: allChatMessagePatientURL,
      body: {"chat_key": chatKey, "patient_id": id},
    );

    GetAllPatientChatMessages getAllChatMessagesDoctor =
        GetAllPatientChatMessages.fromJson(response);
    return getAllChatMessagesDoctor;
  }

  Future<GetSortedChatListDoctor> getDoctorSortedChatList(
      {String? doctorId}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: getSortedChatListDoctorURL,
      body: {"doctor_id": doctorId},
    );
    log("add class res :$response");
    GetSortedChatListDoctor getAllChatMessagesDoctor =
        GetSortedChatListDoctor.fromJson(response);
    return getAllChatMessagesDoctor;
  }
}
