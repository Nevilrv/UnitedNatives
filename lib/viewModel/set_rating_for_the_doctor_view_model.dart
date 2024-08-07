import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/requestModel/set_rating_for_the_doctor_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/set_rating_for_the_doctor_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/set_rating_for_the_doctor_repo.dart';

class SetRatingForTheDoctorViewModel extends GetxController {
  ApiResponse setRatingForTheDoctorApiResponse = ApiResponse.initial('Initial');

  ///SetRatingForTheDoctorViewModel
  Future<void> setRatingForTheDoctorViewModel(
      {required SetRatingForTheDoctorRequestModel requestModel}) async {
    setRatingForTheDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      SetRatingForTheDoctorResponseModel response =
          await SetRatingForTheDoctorRepo()
              .setRatingForTheDoctorRepo(requestModel: requestModel);

      setRatingForTheDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      setRatingForTheDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
