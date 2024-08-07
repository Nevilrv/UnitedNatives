import 'package:get/get.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_maintenance_req_model.dart';
import 'package:united_natives/newModel/apiModel/requestModel/add_room_data_req_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/message_status_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/room_detail_response_model.dart';
import 'package:united_natives/newModel/apis/api_response.dart';
import 'package:united_natives/newModel/repo/room_doctor_repo.dart';

class RoomController extends GetxController {
  ApiResponse getRoomDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse addRoomDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse updateRoomDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse deleteRoomApiResponse = ApiResponse.initial('Initial');
  ApiResponse addMaintenanceApiResponse = ApiResponse.initial('Initial');
  final UserController userController = Get.find();
  /* RxString _isSelected = '1'.obs;

  RxString get isSelected => _isSelected;

  void setSelected(RxString value) {
    _isSelected = value;
    update();
  }

  void clearIsSelected() {
    _isSelected.value = '1';
    update();
  }*/

  ///request list.
  Future<void> getRoomDetail() async {
    getRoomDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      RoomeDetailResponseModel response =
          await RoomRepo().getRoomDetailRepo(userController.user.value.id);

      getRoomDetailApiResponse = ApiResponse.complete(response);
    } catch (e) {
      getRoomDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///doctor add room detail
  Future<void> addRoomDetail(
      {required AddRoomDetailsReqModel model, required String id}) async {
    addRoomDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await RoomRepo().addRoomsDetailRepo(
          model: model, id: id, userId: userController.user.value.id);
      addRoomDetailApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addRoomDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///doctor add room detail
  Future<void> updateRoomDetail(
      {required UpdateRoomDetailsReqModel model, required String id}) async {
    updateRoomDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await RoomRepo()
          .updateRoomsDetailRepo(
              model: model, id: id, userId: userController.user.value.id);
      updateRoomDetailApiResponse = ApiResponse.complete(response);
    } catch (e) {
      updateRoomDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> updateRoomDetailWithoutImg(
      {required UpdateRoomWithoutImgReqModel model, required String id}) async {
    updateRoomDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await RoomRepo()
          .updateRoomsDetailWithoutImgRepo(
              model: model, id: id, userId: userController.user.value.id);
      updateRoomDetailApiResponse = ApiResponse.complete(response);
    } catch (e) {
      updateRoomDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///delete room details
  Future<void> deletRoomDetail({required String id}) async {
    deleteRoomApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await RoomRepo()
          .deleteRoomRepo(id: id, userId: userController.user.value.id);

      deleteRoomApiResponse = ApiResponse.complete(response);
    } catch (e) {
      deleteRoomApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///add maintenancee
  Future<void> addMaintenanceRoom(
      {required AddMaintenanceModel model, required String id}) async {
    addMaintenanceApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      MessageStatusResponseModel response = await RoomRepo().addMaintenanceRepo(
          model: model, id: id, userId: userController.user.value.id);
      addMaintenanceApiResponse = ApiResponse.complete(response);
    } catch (e) {
      addMaintenanceApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
