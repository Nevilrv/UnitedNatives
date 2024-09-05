import 'package:united_natives/requestModel/add_personal_medication_notes_req_model.dart';
import 'package:united_natives/requestModel/delete_personal_medication_notes_request_model.dart';
import 'package:united_natives/requestModel/get_all_personal_medication_notes_request_model.dart';
import 'package:united_natives/requestModel/update_personal_medication_notes_request_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/delete_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_all_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/update_personal_medication_notes_response_model.dart';
import 'package:united_natives/newModel/services/api_service.dart';
import 'package:united_natives/newModel/services/base_service.dart';

class PersonalMedicationNotesRepo extends BaseService {
  /// get all personal medication notes

  Future<GetAllPersonalMedicationNotesResponseModel>
      getPersonalMedicationNotesListRepo(
          {GetAllPersonalMedicationNotesRequestModel? model}) async {
    var body = model?.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: getPersonalMedicationNotesURL,
      body: body!,
    );
    // log("add class res :${response}");
    GetAllPersonalMedicationNotesResponseModel
        getAllPersonalMedicationNotesResponseModel =
        GetAllPersonalMedicationNotesResponseModel.fromJson(response);
    return getAllPersonalMedicationNotesResponseModel;
  }

  /// add personal medication notes

  Future<AddPersonalMedicationNotesResponseModel>
      addPersonalMedicationNotesRepo(
          {AddPersonalMedicationNotesRequestModel? model}) async {
    var body = model?.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: setPersonalMedicationNotesURL,
      body: body!,
    );
    // log("add class res :${response}");
    AddPersonalMedicationNotesResponseModel
        addPersonalMedicationNotesResponseModel =
        AddPersonalMedicationNotesResponseModel.fromJson(response);
    return addPersonalMedicationNotesResponseModel;
  }

  /// update personal medication notes

  Future<UpdatePersonalMedicationNotesResponseModel>
      updatePersonalMedicationNotesRepo(
          {UpdatePersonalMedicationNotesRequestModel? model}) async {
    var body = model?.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: updatePersonalMedicationNotesURL,
      body: body!,
    );
    // log("add class res :${response}");
    UpdatePersonalMedicationNotesResponseModel
        updatePersonalMedicationNotesResponseModel =
        UpdatePersonalMedicationNotesResponseModel.fromJson(response);
    return updatePersonalMedicationNotesResponseModel;
  }

  /// delete personal medication notes

  Future<DeletePersonalMedicationNotesResponseModel>
      deletePersonalMedicationNotesRepo(
          {DeletePersonalMedicationNotesRequestModel? model}) async {
    var body = model?.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: deletePersonalMedicationNotesURL,
      body: body!,
    );
    // log("delete class res :${response}");
    DeletePersonalMedicationNotesResponseModel
        deletePersonalMedicationNotesResponseModel =
        DeletePersonalMedicationNotesResponseModel.fromJson(response);
    return deletePersonalMedicationNotesResponseModel;
  }
}
