import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_notes_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import '../newModel/repo/notes_repo.dart';

class AddNotesController extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial('Initial');
  ApiResponse get apiResponse => _apiResponse;
  GetAllNotesModel? response;

  ///get notes patient side
  Future<void> addNotesControllers({var dId, var pId}) async {
    _apiResponse = ApiResponse.loading('Loading');
    update();
    try {
      response =
          await AddNotesRepo().addNotesRepo(doctorId: dId, patientId: pId);

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error('error');
    }
    update();
  }
}
