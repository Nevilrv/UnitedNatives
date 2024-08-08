import 'dart:convert';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class GetCitiesRepo extends BaseService {
  Future<dynamic> getCitiesRepo({String? stateId}) async {
    String url = '$getCityURL?state_id=$stateId';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    // print('RESPONSE   $response');
    List<GetCityResponseModel> getCityResponseModelList =
        getCityResponseModelFromJson(jsonEncode(response));

    return getCityResponseModelList;
  }
}
