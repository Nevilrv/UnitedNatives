import 'package:united_natives/newModel/apiModel/responseModel/add_video_conference_res.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class VideoConferenceRepo extends BaseService {
  Future<AddVideoConferenceResponseModel> addVideoConferenceRepo(
      {Map<String, dynamic>? body}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: addVideoConferenceData,
      body: body!,
    );

    AddVideoConferenceResponseModel addVideoConferenceResponseModel =
        AddVideoConferenceResponseModel.fromJson(response);
    return addVideoConferenceResponseModel;
  }
}
