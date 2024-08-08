import 'dart:developer';

import 'package:united_natives/newModel/apiModel/responseModel/intake_form_list_res_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/intake_form_res_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/submit_form_res_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class UnitedNativesFormRepo extends BaseService {
  Future<dynamic> getIntakeFormRepo(
      {String? medicalCenterId, String? userId}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aGet,
        url: "$getIntakeForm$medicalCenterId&user_id=$userId",
        medicalCenter: true,
        withoutTypeHeader: true);
    log('RESPONSE   $response');
    IntakeFormListResponseModel intakeFormListResponseModel =
        IntakeFormListResponseModel.fromJson(response);

    log('intakeFormListResponseModel $intakeFormListResponseModel');

    return intakeFormListResponseModel;
  }

  Future<dynamic> intakeFormRepo(
      {String? medicalCenterId, String? formId}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aGet,
        url:
            "$getUnitedNativesMedicalCenterForm$medicalCenterId&form_id=$formId",
        medicalCenter: true,
        withoutTypeHeader: true);
    log('RESPONSE   $response');
    IntakeFormResponseModel intakeFormResponseModel =
        IntakeFormResponseModel.fromJson(response);

    log('intakeFormResponseModel $intakeFormResponseModel');

    return intakeFormResponseModel;
  }

  Future<dynamic> unitedNativesSubmitFormRepo(
      {Map<String, dynamic>? body}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aImageUpload,
      body: body!,
      url: submitUnitedNativesForm,
      noHeader: true,
      medicalCenter: true,
    );
    log('RESPONSE   $response');
    SubmitUnitedNativesFormResponseModel submitUnitedNativesFormResponseModel =
        SubmitUnitedNativesFormResponseModel.fromJson(response);
    log('submitUnitedNativesFormResponseModel  $submitUnitedNativesFormResponseModel');
    return submitUnitedNativesFormResponseModel;
  }
}
