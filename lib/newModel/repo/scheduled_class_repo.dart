import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/add_class_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/edit_class_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/add_class_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/class_detail_doctor_data_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_class_doctor_data_reponse_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:doctor_appointment_booking/newModel/services/api_service.dart';
import 'package:doctor_appointment_booking/newModel/services/base_service.dart';

class ScheduledClassRepo extends BaseService {
  /// doctor add class........

  Future<AddClassResponseModel> addClassRepo(AddClassReqModel model) async {
    var body = await model.toJson();
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: addClassURL, body: body, fileUpload: true);
    // log("add class res :${response}");
    AddClassResponseModel addDiaryResponse =
        AddClassResponseModel.fromJson(response);
    return addDiaryResponse;
  }

  /// doctor class data.......

  Future<dynamic> getClassDoctorRepo({String id, String date}) async {
    String url = getClassListDoctorURL + '/' + id + '/' + date;

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    print('RESPONSE   $response');
    GetClassDoctorDataResponseModel getClassDoctorDataResponseModel =
        GetClassDoctorDataResponseModel.fromJson(response);

    return getClassDoctorDataResponseModel;
  }

  ///class detail doctor data...

  Future<dynamic> classDetailDoctorRepo({String id, String classId}) async {
    String url = getClassDetailDoctorURL + '/' + classId + '/' + id;

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);
    ClassDetailDoctorResponseModel classDetailDoctorResponseModel =
        ClassDetailDoctorResponseModel.fromJson(response);

    return classDetailDoctorResponseModel;
  }

  /// doctor edit class........

  Future<AddClassResponseModel> editClassRepo(EditClassReqModel model,
      {String classId, String id}) async {
    var body = await model.toJson();

    String url = editClassURL + '/' + classId + '/' + id;
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: url, body: body, fileUpload: true);
    // log("add class res :${response}");
    AddClassResponseModel addDiaryResponse =
        AddClassResponseModel.fromJson(response);
    return addDiaryResponse;
  }

  /// doctor edit class........
  Future<dynamic> deleteClassRepo({String id, String classId}) async {
    String url = deleteClassURL + '/' + classId + '/' + id;

    var response =
        await ApiService().getResponse(apiType: APIType.aDelete, url: url);
    MessageStatusResponseModel messageStatusResponseModel =
        MessageStatusResponseModel.fromJson(response);

    return messageStatusResponseModel;
  }
}
