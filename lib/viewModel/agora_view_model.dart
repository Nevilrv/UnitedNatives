import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_agora_token_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/agora_repo.dart';

class AgoraController extends GetxController {
  ApiResponse getServicesPatientApiResponse = ApiResponse.initial('Initial');
  ApiResponse getServicesDoctorApiResponse = ApiResponse.initial('Initial');

  Future<void> agoraController(String id) async {
    getServicesPatientApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      GetAgoraToken response = await AgoraRepo().agoraRepo(id);

      getServicesPatientApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getServicesPatientApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
