import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/add_my_doctors_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/delete_doctor_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/delete_my_doctor_notes_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/my_doctor_list_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/update_my_doctor_request_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/add_my_doctors_reposnse_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/delete_my_doctor_notes_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/delete_my_doctor_reponse_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:doctor_appointment_booking/newModel/services/api_service.dart';
import 'package:doctor_appointment_booking/newModel/services/base_service.dart';

class MyDoctorScreenRepo extends BaseService {
  /// add doctor

  Future<dynamic> addMyDoctorRepo({AddMyDoctorRequestModel model}) async {
    var body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: addDoctorURL,
      body: body,
    );

    AddMyDoctorsResponseModel addMyDoctorsResponseModel =
        AddMyDoctorsResponseModel.fromJson(response);
    return addMyDoctorsResponseModel;
  }

  /// update doctor

  Future<dynamic> updateDoctorRepo({UpdateDoctorRequestModel model}) async {
    var body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: updateMyDoctorURL,
      body: body,
    );

    AddMyDoctorsResponseModel addMyDoctorsResponseModel =
        AddMyDoctorsResponseModel.fromJson(response);
    return addMyDoctorsResponseModel;
  }

  /// get all doctor list
  Future<MyDoctorsListDataResponseModel> getMyDoctorList(
      {MyDoctorListRequestModel model}) async {
    var body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: getMyDoctorListURL,
      body: body,
    );

    MyDoctorsListDataResponseModel myDoctorsListResponseModel =
        MyDoctorsListDataResponseModel.fromJson(response);
    return myDoctorsListResponseModel;
  }

  /// delete NOTES

  Future<DeleteNotesResponseModel> deleteNotesRepo(
      {DeleteNotesRequestModel model}) async {
    var body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: deleteMyDoctorNotesURL,
      body: body,
    );

    DeleteNotesResponseModel deleteNotesResponseModel =
        DeleteNotesResponseModel.fromJson(response);
    return deleteNotesResponseModel;
  }

  /// delete Doctors

  Future<DeleteMyDoctorResponseModel> deleteDoctorRepo(
      {DeleteDoctorRequestModel model}) async {
    var body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: deleteMyDoctorURL,
      body: body,
    );

    DeleteMyDoctorResponseModel deleteMyDoctorResponseModel =
        DeleteMyDoctorResponseModel.fromJson(response);
    return deleteMyDoctorResponseModel;
  }
}
