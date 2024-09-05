import 'package:get/get.dart';
import 'package:united_natives/requestModel/add_class_request_model.dart';
import 'package:united_natives/requestModel/edit_class_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_class_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/class_detail_doctor_data_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_class_doctor_data_reponse_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/scheduled_class_repo.dart';

class ScheduledClassController extends GetxController {
  ApiResponse addclassApiResponse = ApiResponse.initial('Initial');
  ApiResponse editclassApiResponse = ApiResponse.initial('Initial');
  ApiResponse getClassDoctorApiResponse = ApiResponse.initial('Initial');
  ApiResponse classDetailDoctorApiResponse = ApiResponse.initial('Initial');
  ApiResponse deleteClassApiResponse = ApiResponse.initial('Initial');

  ///doctor add class
  Future<void> addClass(AddClassReqModel model) async {
    addclassApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AddClassResponseModel response =
          await ScheduledClassRepo().addClassRepo(model);
      addclassApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addclassApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///doctor class list
  Future<void> getClassDoctor(
      {required String id, required String date}) async {
    getClassDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      GetClassDoctorDataResponseModel response =
          await ScheduledClassRepo().getClassDoctorRepo(date: date, id: id);

      getClassDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getClassDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///class detail doctor
  Future<void> classDetailDoctor(
      {required String id, required String classId}) async {
    classDetailDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ClassDetailDoctorResponseModel response = await ScheduledClassRepo()
          .classDetailDoctorRepo(id: id, classId: classId);

      classDetailDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      classDetailDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///doctor edit class
  Future<void> editClass(EditClassReqModel model,
      {required String classId, required String id}) async {
    editclassApiResponse = ApiResponse.loading('Loading');
    //update();
    try {
      AddClassResponseModel response = await ScheduledClassRepo()
          .editClassRepo(model, classId: classId, id: id);
      editclassApiResponse = ApiResponse.complete(response);
    } catch (e) {
      editclassApiResponse = ApiResponse.error('error');
    }
    //update();
  }

  ///doctor delete class

  Future<void> deleteClassDoctor(
      {required String id, required String classId}) async {
    deleteClassApiResponse = ApiResponse.loading('Loading');
    //update();
    try {
      MessageStatusResponseModel response =
          await ScheduledClassRepo().deleteClassRepo(id: id, classId: classId);

      deleteClassApiResponse = ApiResponse.complete(response);
    } catch (e) {
      deleteClassApiResponse = ApiResponse.error('error');
    }
    //update();
  }
}
