import 'package:united_natives/newModel/apiModel/requestModel/set_rating_for_the_doctor_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/set_rating_for_the_doctor_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class SetRatingForTheDoctorRepo extends BaseService {
  ///SetRatingForTheDoctorRepo
  Future<dynamic> setRatingForTheDoctorRepo(
      {SetRatingForTheDoctorRequestModel? requestModel}) async {
    String url = setRatingForTheDoctorURL;
    var body = requestModel!.toJson();
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, body: body, url: url);
    SetRatingForTheDoctorResponseModel setRatingForTheDoctorResponseModel =
        SetRatingForTheDoctorResponseModel.fromJson(response);

    return setRatingForTheDoctorResponseModel;
  }
}
