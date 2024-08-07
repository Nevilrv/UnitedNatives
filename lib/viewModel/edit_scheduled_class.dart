import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/responseModel/class_detail_doctor_data_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/scheduled_class_repo.dart';

class EditScheduledClassController extends GetxController {
  ApiResponse classDetailDoctorApiResponse = ApiResponse.initial('Initial');

  ///class detail doctor
  Future<void> classDetailDoctor({String? id, String? classId}) async {
    classDetailDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ClassDetailDoctorResponseModel response = await ScheduledClassRepo()
          .classDetailDoctorRepo(id: id ?? "", classId: classId ?? "");

      classDetailDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      classDetailDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
