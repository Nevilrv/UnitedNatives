import 'package:get/get.dart';
import 'package:united_natives/model/get_all_chat_messeage_doctor.dart';
import 'package:united_natives/model/get_all_patient_messagelist_model.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_new_message.dart';
import 'package:united_natives/newModel/apiModel/responseModel/add_new_message_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/add_new_chat_response_model.dart';

class AddNewChatMessageController extends GetxController {
  ApiResponse addNewMessageApiResponse = ApiResponse.initial('Initial');
  ApiResponse allNewMessageApiResponse = ApiResponse.initial('Initial');
  ApiResponse allNewMessagePatientApiResponse = ApiResponse.initial('Initial');
  ApiResponse getDoctorSortedChatListApiResponse =
      ApiResponse.initial('Initial');

  ///doctor add new chat msg.....
  Future<void> addClass(AddNewMessageReqModel model) async {
    addNewMessageApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      AddNewChatResponseModel response =
          await AddNewChatMessageRepo().addNewChatMessageRepo(model);
      addNewMessageApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addNewMessageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> allChatMessage({String? chatKey, String? id}) async {
    if (allNewMessageApiResponse.status == Status.INITIAL) {
      allNewMessageApiResponse = ApiResponse.loading('Loading');
    }
    update();
    try {
      GetAllChatMessagesDoctor response = await AddNewChatMessageRepo()
          .allChatMessageRepo(chatKey: chatKey ?? "", id: id ?? "");
      allNewMessageApiResponse = ApiResponse.complete(response);
    } catch (e) {
      allNewMessageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  // bool isFirstChatMessages = true;

  Future<void> allChatMessagePatient({String? chatKey, String? id}) async {
    if (allNewMessagePatientApiResponse.status == Status.INITIAL) {
      allNewMessagePatientApiResponse = ApiResponse.loading('Loading');
    }
    update();
    try {
      GetAllPatientChatMessages response = await AddNewChatMessageRepo()
          .allChatMessagePatientRepo(chatKey: chatKey ?? "", id: id ?? "");
      allNewMessagePatientApiResponse = ApiResponse.complete(response);

      // isFirstChatMessages = false;
    } catch (e) {
      // isFirstChatMessages = false;
      allNewMessagePatientApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> getSortedChatListDoctor({String? doctorId}) async {
    if (getDoctorSortedChatListApiResponse.status == Status.INITIAL) {
      getDoctorSortedChatListApiResponse = ApiResponse.loading('Loading');
    }
    update();
    try {
      GetSortedChatListDoctor response = await AddNewChatMessageRepo()
          .getDoctorSortedChatList(doctorId: doctorId ?? "");
      getDoctorSortedChatListApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getDoctorSortedChatListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
