import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/get_city_repo.dart';

class GetCitiesViewModel extends GetxController {
  ApiResponse getCitiesApiResponse = ApiResponse.initial('Initial');

  ///Get Cities
  Future<void> getCitiesViewModel({String? stateId}) async {
    getCitiesApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      List<GetCityResponseModel> response =
          await GetCitiesRepo().getCitiesRepo(stateId: stateId ?? "");

      getCitiesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getCitiesApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
