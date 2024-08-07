import 'dart:convert';
import 'dart:developer';

import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/model/doctor_specialities_filter_model.dart';
import 'package:united_natives/model/patient_appointment_model.dart';
import 'package:united_natives/model/specialities_model.dart';
import 'package:united_natives/model/specific_appointment_details_model.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/network_util.dart';
import 'package:united_natives/utils/utils.dart';

class BookAppointmentScreenService {
  static final BookAppointmentScreenService _authService =
      BookAppointmentScreenService._init();

  factory BookAppointmentScreenService() {
    return _authService;
  }

  BookAppointmentScreenService._init();

  final NetworkAPICall _networkAPICall = NetworkAPICall();

  static const BANNER_TOKEN = '43b2fe6fb2cd47eb049520a9f5d94905';

  // Map<String, String> headers = {
  //   "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
  //   "Content-Type": 'application/json',
  // };

  // Map<String, String> headers2 = {
  //   "Authorization": 'Bearer 130c470359db8bdef071522cb0c733b8',
  //   "Content-Type": 'application/json',
  // };

  ///*****  Specialities API *****

  Future<SpecialitiesModel> specialitiesModel(
      {String stateId = '', String medicalCenterId = ''}) async {
    SpecialitiesModel specialitiesModelData = SpecialitiesModel();

    try {
      var result = await _networkAPICall.get(
          '${Constants.getSpecialities}?state_id=$stateId&medical_center_id=$medicalCenterId',
          header: Config.getHeaders());

      log('HELLO=======>>>>>API=======>>>>>${'${Constants.getSpecialities}?state_id=$stateId&medical_center_id=$medicalCenterId'}');

      if (result['status'] == 'Success') {
        specialitiesModelData = SpecialitiesModel.fromJson(result);
      } else {
        specialitiesModelData = SpecialitiesModel();
      }

      return specialitiesModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///*****  Doctor by Specialities API *****

  Future<DoctorBySpecialitiesModel> doctorBySpecialitiesModel(
      String userId, specialityId, stateId, medicalCenterId) async {
    DoctorBySpecialitiesModel doctorBySpecialitiesModelData =
        DoctorBySpecialitiesModel();
    var body = jsonEncode(({
      "speciality_id": specialityId,
      "user_id": userId,
      "state_id": stateId,
      "medical_center_id": medicalCenterId
    }));

    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorBySpecialities, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorBySpecialitiesModelData =
            DoctorBySpecialitiesModel.fromJson(result);
      } else {
        doctorBySpecialitiesModelData = DoctorBySpecialitiesModel();
      }

      return doctorBySpecialitiesModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///***** PatientAppointment API *****

  Future<PatientAppointmentModel> patientAppointmentModel(
      {required String patientId, doctorId, availabilityDate}) async {
    PatientAppointmentModel patientAppointmentModelData =
        PatientAppointmentModel();
    var body = jsonEncode({
      "user_id": patientId,
      "doctor_id": doctorId,
      "availability_date": availabilityDate
    });

    try {
      var result = await _networkAPICall.post(
          Constants.getPatientAppointment, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        patientAppointmentModelData = PatientAppointmentModel.fromJson(result);
      } else {
        patientAppointmentModelData = PatientAppointmentModel();
      }
      return patientAppointmentModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future<DoctorBySpecialitiesModel> filteredDoctor(
      {required String specialityId,
      userId,
      availabilityFilter,
      genderFilter,
      feesFilter,
      medicalCenterID}) async {
    DoctorBySpecialitiesModel doctorBySpecialitiesModelData =
        DoctorBySpecialitiesModel();
    var body = jsonEncode({
      "speciality_id": specialityId.toString(),
      "user_id": userId.toString(),
      "availability_filter": availabilityFilter.toString(),
      "gender_filter": genderFilter.toString(),
      "fees_filter": feesFilter.toString(),
      "medical_center_id": medicalCenterID.toString()
    });

    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorSpecialitiesFilter, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        doctorBySpecialitiesModelData =
            DoctorBySpecialitiesModel.fromJson(result);
      } else {
        doctorBySpecialitiesModelData = DoctorBySpecialitiesModel();
      }
      return doctorBySpecialitiesModelData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future<SpecificAppointmentDetailsModel> getSpecificAppontmentDetails(
      {required String patientId, appointmentId}) async {
    SpecificAppointmentDetailsModel specificAppointmentDetailsData =
        SpecificAppointmentDetailsModel();
    var body =
        jsonEncode({"patient_id": patientId, "appointment_id": appointmentId});

    try {
      var result = await _networkAPICall.post(
          Constants.getSpecificAppointmentDetails, body,
          header: Config.getHeaders());

      if (result['status'] == 'Success') {
        specificAppointmentDetailsData =
            SpecificAppointmentDetailsModel.fromJson(result);
      } else {
        specificAppointmentDetailsData = SpecificAppointmentDetailsModel();
      }
      return specificAppointmentDetailsData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  ///****** getDoctorSpecialityFilter API *****

  DoctorSpecialitiesFilter doctorSpecialitiesFilterData =
      DoctorSpecialitiesFilter();

  // DoctorAvailability doctorAvailabilityData = DoctorAvailability();

  Future<DoctorSpecialitiesFilter> doctorSpecialitiesFilter(
      {required String specialityId,
      userId,
      availabilityFilter,
      genderFilter,
      feesFilter}) async {
    var body = jsonEncode({
      "speciality_id": specialityId,
      "user_id": userId,
      "availability_filter": availabilityFilter,
      "gender_filter": genderFilter,
      "fees_filter": feesFilter
    });
    try {
      var result = await _networkAPICall.post(
          Constants.getDoctorSpecialitiesFilter, body,
          header: Config.getHeaders());
      // print("Availability====>>>$result");
      /*  if (result['status'] == 'Success') {
          doctorAvailabilityData = DoctorAvailability.fromJson(result['data']);
          print("Success");
        } else {
          doctorAvailabilityData = null;
          print("Failed");
        }
      */
      // await AppPreference().saveCustomerData(customerData);
      return doctorSpecialitiesFilterData;
    } catch (e, stackStrace) {
      // print("print4===>$dateTime");
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }
}
