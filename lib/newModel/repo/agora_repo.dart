import 'dart:developer';
import 'package:united_natives/newModel/apiModel/responseModel/get_agora_token_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class AgoraRepo extends BaseService {
  Future<GetAgoraToken> agoraRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: 'common/agoraToken/$id',
    );
    log("agora response :$response");
    GetAgoraToken getAgoraToken = GetAgoraToken.fromJson(response);
    return getAgoraToken;
  }
}
