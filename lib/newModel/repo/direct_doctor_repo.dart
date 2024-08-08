import 'dart:developer';

import 'package:united_natives/newModel/apiModel/requestModel/add_direct_appointment_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_direct_appointment_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_doctor.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_direct_doctor_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class DirectDoctorRepo extends BaseService {
  /// get direct doctor .......

  Future<dynamic> getDirectDoctorRepo(String id) async {
    String url = '$getDirectDoctorURL/$id';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    GetDirectDoctorResponseModel getDirectDoctorResponseModel =
        GetDirectDoctorResponseModel.fromJson(response);

    return getDirectDoctorResponseModel;
  }

  /// add direct request....
  Future<AddDirectAppointmentResponseModel> addDirectRequestRepo(
      AddDirectAppointmentReqModel model, String id) async {
    var body = await model.toJson();
    String url = '$addDirectAppointmentURL/$id';

    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: url,
      body: body,
    );
    log("add class res :$response");
    AddDirectAppointmentResponseModel addDirectAppointmentResponseModel =
        AddDirectAppointmentResponseModel.fromJson(response);
    return addDirectAppointmentResponseModel;
  }

  Future<dynamic> getAllDoctorRepo() async {
    String url = getAllDoctorURL;

    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: url, withoutTypeHeader: true);
    GetAllDoctorResponseModel getAllDoctor =
        GetAllDoctorResponseModel.fromJson(response);

    return getAllDoctor;
  }
}
