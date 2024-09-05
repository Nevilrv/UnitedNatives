import 'package:get/get.dart';
import 'package:united_natives/requestModel/book_withdraw_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/class_detail_patient_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_class_list_patient_data_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/patient_scheduled_class_repo.dart';

class PatientScheduledClassController extends GetxController {
  ApiResponse getClassPatientApiResponse = ApiResponse.initial('Initial');
  ApiResponse classDetailPatientApiResponse = ApiResponse.initial('Initial');
  ApiResponse bookWithdrawClassApiResponse = ApiResponse.initial('Initial');

  ///doctor class list
  Future<void> getClassListPatient(
      {required String id, required String date}) async {
    getClassPatientApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ClassListPatientResponseModel response = await PatientScheduledClassRepo()
          .getClassPatientRepo(date: date, id: id);

      getClassPatientApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getClassPatientApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///class detail doctor
  Future<void> classDetailDoctor(
      {required String id, required String classId}) async {
    classDetailPatientApiResponse = ApiResponse.loading('Loading');
    //update();
    try {
      ClassDetailPatientResponseModel response =
          await PatientScheduledClassRepo()
              .classDetailPatientRepo(id: id, classId: classId);

      classDetailPatientApiResponse = ApiResponse.complete(response);
    } catch (e) {
      classDetailPatientApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///patient book class
  Future<void> bookWithdrawClass(
      {required BookWithdrawReqModel model,
      required String classId,
      required String id}) async {
    bookWithdrawClassApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await PatientScheduledClassRepo()
          .bookWithdrawClassRepo(model: model, classId: classId, id: id);
      bookWithdrawClassApiResponse = ApiResponse.complete(response);
    } catch (e) {
      bookWithdrawClassApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
