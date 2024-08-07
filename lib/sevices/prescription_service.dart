import 'dart:convert';

import 'package:united_natives/model/prescription.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/network_util.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';

class PrescriptionService {
  static final PrescriptionService _prescriptionService =
      PrescriptionService._init();

  factory PrescriptionService() {
    return _prescriptionService;
  }

  PrescriptionService._init();

  ///-----------------------------------------------------------------------------------------------

  final NetworkAPICall _networkAPICall = NetworkAPICall();

  Future<List<Prescription>> doctorPrescriptions(
      {required String doctorId}) async {
    List<Prescription> prescriptionList = [];
    try {
      var body = jsonEncode(({"doctor_id": doctorId}));
      var result = await _networkAPICall.post(
        Constants.getDoctorPrescriptions,
        body,
        header: Config.getHeaders(),
      );

      if (result['status'] == 'Success') {
        var resultTemp = Prescription.getPrescriptionList(result['data']);
        prescriptionList.addAll(resultTemp);
      }
      return prescriptionList;
    } catch (e, stackTrace) {
      throw AppException.exceptionHandler(e, stackTrace);
    }
  }

  Future<List<Prescription>> getAppointmentPrescriptions(
      {required String appointmentId}) async {
    List<Prescription> prescriptionList = [];
    try {
      var body = jsonEncode(({"appointment_id": appointmentId}));
      var result = await _networkAPICall.post(
        Constants.getAppointmentPrescriptions,
        body,
        header: Config.getHeaders(),
      );

      if (result['status'] == 'Success') {
        var resultTemp = Prescription.getPrescriptionList(result['data']);
        prescriptionList.addAll(resultTemp);
      }
      return prescriptionList;
    } catch (e, stackTrace) {
      throw AppException.exceptionHandler(e, stackTrace);
    }
  }
}
