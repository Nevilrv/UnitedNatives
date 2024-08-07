import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/get_states_repo.dart';

class GetStatesViewModel extends GetxController {
  ApiResponse getStatesApiResponse = ApiResponse.initial('Initial');

  ///Get State
  Future<void> getStatesViewModel() async {
    getStatesApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      List<GetStatesResponseModel> response =
          await GetStatesRepo().getStatesRepo();

      getStatesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getStatesApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
