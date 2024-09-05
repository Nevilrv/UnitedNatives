import 'dart:developer';

import 'package:united_natives/requestModel/book_withdraw_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/class_detail_patient_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_class_list_patient_data_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class PatientScheduledClassRepo extends BaseService {
  /// patient class list.......

  Future<dynamic> getClassPatientRepo({String? id, String? date}) async {
    String url = '$getClassListPatientURL/$id/$date';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    // print('RESPONSE   $response');

    ClassListPatientResponseModel classListPatientResponseModel =
        ClassListPatientResponseModel.fromJson(response);

    return classListPatientResponseModel;
  }

  ///class detail patient data...

  Future<dynamic> classDetailPatientRepo({String? id, String? classId}) async {
    String url = '$getClassDetailPatientURL/$classId/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    ClassDetailPatientResponseModel classDetailPatientResponseModel =
        ClassDetailPatientResponseModel.fromJson(response);

    return classDetailPatientResponseModel;
  }

  ///book withdraw patient

  Future<MessageStatusResponseModel> bookWithdrawClassRepo(
      {BookWithdrawReqModel? model, String? id, String? classId}) async {
    String url = '$bookWithdrawURL/$classId/$id';

    var response = await ApiService().getResponse(
        apiType: APIType.aPost,
        url: url,
        body: model!.toJson(),
        withoutTypeHeader: true);
    log("book  class res :$response");
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);
    return messageStatusResponseModel;
  }
}
