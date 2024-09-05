import 'package:get/get.dart';
import 'package:united_natives/requestModel/add_personal_medication_notes_req_model.dart';
import 'package:united_natives/requestModel/delete_personal_medication_notes_request_model.dart';
import 'package:united_natives/requestModel/get_all_personal_medication_notes_request_model.dart';
import 'package:united_natives/requestModel/update_personal_medication_notes_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/delete_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/update_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/personal_medication_notes_repo.dart';

class PersonalMedicationNotesViewModel extends GetxController {
  ApiResponse getAllPersonalMedicationNotesApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse addNewPersonalMedicationNotesApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse updatePersonalMedicationNotesApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse deletePersonalMedicationNotesApiResponse =
      ApiResponse.initial('Initial');

  ///egt all personal medication notes
  Future<void> getAllPersonalMedicationNotes(
      {required GetAllPersonalMedicationNotesRequestModel model}) async {
    getAllPersonalMedicationNotesApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      GetAllPersonalMedicationNotesResponseModel response =
          await PersonalMedicationNotesRepo()
              .getPersonalMedicationNotesListRepo(model: model);
      getAllPersonalMedicationNotesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getAllPersonalMedicationNotesApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///add new personal medication notes
  Future<void> addPersonalMedicationNotes(
      {required AddPersonalMedicationNotesRequestModel model}) async {
    addNewPersonalMedicationNotesApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AddPersonalMedicationNotesResponseModel response =
          await PersonalMedicationNotesRepo()
              .addPersonalMedicationNotesRepo(model: model);
      addNewPersonalMedicationNotesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addNewPersonalMedicationNotesApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///update  personal medication notes
  Future<void> updatePersonalMedicationNotes(
      {required UpdatePersonalMedicationNotesRequestModel model}) async {
    updatePersonalMedicationNotesApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      UpdatePersonalMedicationNotesResponseModel response =
          await PersonalMedicationNotesRepo()
              .updatePersonalMedicationNotesRepo(model: model);
      updatePersonalMedicationNotesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      updatePersonalMedicationNotesApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///delete  personal medication notes
  Future<void> deletePersonalMedicationNotes(
      {required DeletePersonalMedicationNotesRequestModel model}) async {
    deletePersonalMedicationNotesApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      DeletePersonalMedicationNotesResponseModel response =
          await PersonalMedicationNotesRepo()
              .deletePersonalMedicationNotesRepo(model: model);
      deletePersonalMedicationNotesApiResponse = ApiResponse.complete(response);
    } catch (e) {
      deletePersonalMedicationNotesApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
