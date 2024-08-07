import 'dart:convert';

import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:doctor_appointment_booking/newModel/services/api_service.dart';
import 'package:doctor_appointment_booking/newModel/services/base_service.dart';

class GetStatesRepo extends BaseService {
  Future<dynamic> getStatesRepo() async {
    String url = getStatesURL;

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    // print('RESPONSE   $response');
    List<GetStatesResponseModel> getStatesResponseModelList =
        getStatesResponseModelFromJson(jsonEncode(response));

    return getStatesResponseModelList;
  }
}
