import 'dart:convert';

import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class GetStatesRepo extends BaseService {
  Future<dynamic> getStatesRepo() async {
    String url = getStatesURL;

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    List<GetStatesResponseModel> getStatesResponseModelList =
        getStatesResponseModelFromJson(jsonEncode(response));

    return getStatesResponseModelList;
  }
}
