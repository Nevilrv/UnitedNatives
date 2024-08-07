import 'package:get/get.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_my_doctors_request_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/delete_doctor_response_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/delete_my_doctor_notes_request_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/my_doctor_list_request_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/update_my_doctor_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_my_doctors_reposnse_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/delete_my_doctor_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/delete_my_doctor_reponse_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/my_doctor_list_reposne_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/my_doctor_screen_repo.dart';

class MyDoctorNotesViewModel extends GetxController {
  ApiResponse _addNewDoctorsApiResponse = ApiResponse.initial('Initial');
  ApiResponse _getMyDoctorListApiResponse = ApiResponse.initial('Initial');
  ApiResponse _deleteMyDoctorNoteApiResponse = ApiResponse.initial('Initial');
  ApiResponse _deleteMyDoctorApiResponse = ApiResponse.initial('Initial');

  ApiResponse get addNewDoctorsApiResponse => _addNewDoctorsApiResponse;
  ApiResponse get getMyDoctorListApiResponse => _getMyDoctorListApiResponse;
  ApiResponse get deleteMyDoctorApiResponse => _deleteMyDoctorApiResponse;
  ApiResponse get deleteMyDoctorNoteApiResponse =>
      _deleteMyDoctorNoteApiResponse;

  ///add new doctor
  Future<void> addNewDoctor({AddMyDoctorRequestModel? model}) async {
    _addNewDoctorsApiResponse = ApiResponse.loading('Loading');

    update();
    try {
      AddMyDoctorsResponseModel response =
          await MyDoctorScreenRepo().addMyDoctorRepo(model: model);
      _addNewDoctorsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _addNewDoctorsApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///update new doctor
  Future<void> updateDoctor({UpdateDoctorRequestModel? model}) async {
    _addNewDoctorsApiResponse = ApiResponse.loading('Loading');

    update();
    try {
      AddMyDoctorsResponseModel response =
          await MyDoctorScreenRepo().updateDoctorRepo(model: model);
      _addNewDoctorsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _addNewDoctorsApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///get all doctor
  Future<void> getAllDoctorList({MyDoctorListRequestModel? model}) async {
    _getMyDoctorListApiResponse = ApiResponse.loading('Loading');

    update();
    try {
      MyDoctorsListDataResponseModel response =
          await MyDoctorScreenRepo().getMyDoctorList(model: model);
      _getMyDoctorListApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _getMyDoctorListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///delete notes
  Future<void> deleteMyDoctorNotes({DeleteNotesRequestModel? model}) async {
    _deleteMyDoctorNoteApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      DeleteNotesResponseModel response =
          await MyDoctorScreenRepo().deleteNotesRepo(model: model);
      _deleteMyDoctorNoteApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _deleteMyDoctorNoteApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///delete doctor
  Future<void> deleteMyDoctor({DeleteDoctorRequestModel? model}) async {
    _deleteMyDoctorApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      DeleteMyDoctorResponseModel response =
          await MyDoctorScreenRepo().deleteDoctorRepo(model: model);
      _deleteMyDoctorApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _deleteMyDoctorApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
