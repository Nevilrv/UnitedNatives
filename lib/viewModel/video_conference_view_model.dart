import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_video_conference_res.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/video_conference_details_repo.dart';

class VideoConferenceViewModel extends GetxController {
  ApiResponse addVideoConferenceDetailsApiResponse =
      ApiResponse.initial('Initial');

  Future<void> addVideoConference({required Map<String, dynamic> body}) async {
    addVideoConferenceDetailsApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AddVideoConferenceResponseModel response =
          await VideoConferenceRepo().addVideoConferenceRepo(body: body);
      addVideoConferenceDetailsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addVideoConferenceDetailsApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
