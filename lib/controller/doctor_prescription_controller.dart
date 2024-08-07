import 'package:doctor_appointment_booking/model/api_state_enum.dart';
import 'package:doctor_appointment_booking/model/prescription.dart';
import 'package:doctor_appointment_booking/sevices/prescription_service.dart';
import 'package:get/get.dart';
import 'user_controller.dart';

class PrescriptionController extends GetxController {
  RxList<Prescription> prescriptionList = <Prescription>[].obs;
  RxList<Prescription> appointmentPrescriptionList = <Prescription>[].obs;

  Rx<APIState> apiState = APIState.NONE.obs;
  Rx<APIState> appointmentApiState = APIState.NONE.obs;

  final UserController _userController = Get.find();

  Future refreshGetDoctorPrescriptions() async {
    getDoctorPrescriptions();
  }

  void getDoctorPrescriptions() async {
    try {
      apiState.value = APIState.PROCESSING;
      prescriptionList.addAll(await PrescriptionService()
          .doctorPrescriptions(doctorId: _userController.user.value.id));
      if (prescriptionList.isEmpty) {
        apiState.value = APIState.COMPLETE_WITH_NO_DATA;
      } else {
        apiState.value = APIState.COMPLETE;
      }
    } catch (e) {
      apiState.value = APIState.ERROR;
    }
    apiState.refresh();
  }

  void getAppointmentPrescriptions({String appointmentId}) async {
    try {
      appointmentApiState.value = APIState.PROCESSING;
      appointmentPrescriptionList?.clear();
      appointmentPrescriptionList.addAll(await PrescriptionService()
          .getAppointmentPrescriptions(appointmentId: appointmentId));

      appointmentPrescriptionList
          .sort((a, b) => a.created.compareTo(b.created));

      if (appointmentPrescriptionList.isEmpty) {
        appointmentApiState.value = APIState.COMPLETE_WITH_NO_DATA;
      } else {
        appointmentApiState.value = APIState.COMPLETE;
      }
    } catch (e) {
      appointmentApiState.value = APIState.ERROR;
    }
    appointmentApiState.refresh();
  }
}
