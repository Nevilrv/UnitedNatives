import 'package:get/get.dart';
import 'package:united_natives/newModel/apis/api_response.dart';

class RateContactUsController extends GetxController {
  ApiResponse getPatientRateApiResponse = ApiResponse.initial('Initial');

  String rate = '0';
  void setRate({required String rate1}) {
    rate = rate1;
    update();
  }
}
