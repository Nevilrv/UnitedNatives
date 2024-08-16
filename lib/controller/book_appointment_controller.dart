import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/model/doctor_by_specialities.dart';
import 'package:united_natives/model/doctor_filter_model.dart';
import 'package:united_natives/model/doctor_specialities_filter_model.dart';
import 'package:united_natives/model/patient_appointment_model.dart';
import 'package:united_natives/model/specialities_model.dart';
import 'package:united_natives/model/specific_appointment_details_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/sevices/book_appointment_screen_service.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';

class BookAppointmentController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController patientPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController purposeOfVisitController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController providerController = TextEditingController();

  clearData() {
    nameController.clear();
    phoneController.clear();
    faxController.clear();
    patientPhoneController.clear();
    emailController.clear();
    purposeOfVisitController.clear();
    companyController.clear();
    providerController.clear();
    selectedState = null;
    selectedCity = null;
  }

  bool isLoader = false;

  updateLoader(value) {
    isLoader = value;
    update();
  }

  Rx<SpecialitiesModel> specialitiesModelData = SpecialitiesModel().obs;
  Rx<DoctorBySpecialitiesModel> doctorBySpecialitiesModelData =
      DoctorBySpecialitiesModel().obs;
  Rx<PatientAppointmentModel> patientAppointmentModelData =
      PatientAppointmentModel().obs;

  RxList<WeekAvailability> weekAvailabilityList = <WeekAvailability>[].obs;

  Rx<DoctorSpecialitiesFilter> doctorSpecialitiesFilterData =
      DoctorSpecialitiesFilter().obs;
  Rx<DoctorFilterModel> doctorFilterModelData = DoctorFilterModel().obs;
  Rx<SpecificAppointmentDetailsModel> specificAppointmentDetailsData =
      SpecificAppointmentDetailsModel().obs;

  final UserController _userController = Get.find<UserController>();
  RxInt selectedIndex = (-1).obs;

  RxString mySelectedDate = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isFiltered = true.obs;

  int allDoctorCount = 0;
  int doctorCount = 0;
  int ihOrNatives = 1;
  String? medicalCenterForm;
  String? medicalCenterId;

  changeValue(int value) {
    ihOrNatives = value;
    update();
  }

  RxBool medicalLoader = true.obs;

  GetStatesResponseModel? selectedState;
  List<GetCityResponseModel> cityList = [];
  GetCityResponseModel? selectedCity;

  changeCityValue(List<GetCityResponseModel> data) {
    cityList = [];
    selectedCity = null;
    cityList = data;
    update();
  }

  setStateName(GetStatesResponseModel data) {
    selectedState = data;
    update();
  }

  setCityName(GetCityResponseModel data) {
    selectedCity = data;
    update();
  }

  clearStateCity() {
    cityList = [];
    selectedCity = null;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  someoneElse() {
    nameController.clear();
    emailController.clear();
    selectedState = null;
    selectedCity = null;
    cityList = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  ///*****bookAppointment Controller*****`
  Future<SpecialitiesModel> getSpecialities(RxBool isLoading,
      {String stateId = '', String medicalCenterId = ''}) async {
    try {
      isLoading.value = true;
      specialitiesModelData.value = await BookAppointmentScreenService()
          .specialitiesModel(
              stateId: stateId, medicalCenterId: medicalCenterId);
      allDoctorCount = 0;
      specialitiesModelData.value.specialities?.forEach((element) {
        allDoctorCount += int.parse(element.doctorsCount.toString());
      });
      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return specialitiesModelData.value;
  }

  ///*****get Doctor by Specialities Controller*****

  Future<DoctorBySpecialitiesModel> getDoctorSpecialities(
      String specialityId, BuildContext context,
      {String? stateId, String? medicalCenterId}) async {
    try {
      log('medicalCenterId---------->>>>>>>>$medicalCenterId');

      isFiltered.value = true;
      isLoading.value = true;
      doctorBySpecialitiesModelData.value = await BookAppointmentScreenService()
          .doctorBySpecialitiesModel("${_userController.user.value.id}",
              specialityId, stateId ?? "", medicalCenterId ?? "");
      doctorCount = doctorBySpecialitiesModelData.value.doctorsCount!;
      update();
    } catch (isBlank) {
      isLoading.value = false;
    }

    return doctorBySpecialitiesModelData.value;
  }

  ///*****getPatientAppointment Controller*****
  updateController() {
    return update();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<PatientAppointmentModel> getPatientAppointment(
      String doctorId, BuildContext context) async {
    try {
      isLoading.value = true;
      final availabilityDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc());
      patientAppointmentModelData.value = await BookAppointmentScreenService()
          .patientAppointmentModel(
              patientId: "${_userController.user.value.id}",
              doctorId: doctorId,
              availabilityDate: availabilityDate);
      weekAvailabilityList.clear();
      weekAvailabilityList
          .addAll(patientAppointmentModelData.value.data!.weekAvailability!);

      List<WeekAvailability> iterable = weekAvailabilityList;

      List<DateTime> dayList = [];

      for (var element in iterable) {
        dayList.add(element.date!);
      }

      DateFormat format = DateFormat("yyyy-MM-dd");

      List<DateTime> tempDayList = [];

      for (var i = 0; i < iterable.length; i++) {
        Availability? availability = iterable[i].availability;
        if (availability != null) {
          availability.availData?.forEach(
            (e1) {
              if (e1.avail == "1" && e1.status != "Booked") {
                DateTime startUtcDateTime = e1.startTime!.toLocal();
                DateTime startDateTime = DateTime(
                    startUtcDateTime.year,
                    startUtcDateTime.month,
                    startUtcDateTime.day,
                    startUtcDateTime.hour,
                    startUtcDateTime.minute);
                tempDayList.add(startDateTime);
              }
            },
          );
        }
      }

      forLoop(tempDayList, format, dayList, iterable, 0);
      forLoop(tempDayList, format, dayList, iterable, 1);
      forLoop(tempDayList, format, dayList, iterable, 2);
      forLoop(tempDayList, format, dayList, iterable, 3);
      forLoop(tempDayList, format, dayList, iterable, 4);
      forLoop(tempDayList, format, dayList, iterable, 5);
      forLoop(tempDayList, format, dayList, iterable, 6);
      forLoop(tempDayList, format, dayList, iterable, 7);
      forLoop(tempDayList, format, dayList, iterable, 8);

      if (weekAvailabilityList.isNotEmpty) {
        mySelectedDate.value =
            "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
        selectedIndex.value = 0;

        final temp = weekAvailabilityList.indexWhere((element) =>
            mySelectedDate.value.toString() ==
            DateFormat("yyyy-MM-dd").format(element.date!));
        if (temp > 0) {
          selectedIndex.value = temp == 0 ? 0 : temp - 1;
        }
        filterData();
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }
    return patientAppointmentModelData.value;
  }

  void forLoop(List<DateTime> tempDayList, DateFormat format,
      List<DateTime> dayList, List<WeekAvailability> iterable, int index) {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
    for (var el2 in tempDayList) {
      if (el2.toString().contains(format.format(dayList[index]))) {
        if (now.isBefore(el2)) {
          iterable[index].actualSlotCount++;
        }
      }
    }
  }

  Future<DoctorBySpecialitiesModel> getFilteredDoctor(
      String specialityId,
      userId,
      availabilityFilter,
      genderFilter,
      feesFilter,
      medicalCenterID) async {
    try {
      isLoading.value = true;
      doctorBySpecialitiesModelData.value = await BookAppointmentScreenService()
          .filteredDoctor(
              specialityId: specialityId,
              userId: userId,
              availabilityFilter: availabilityFilter,
              genderFilter: genderFilter,
              feesFilter: feesFilter,
              medicalCenterID: medicalCenterID);

      isFiltered.value = false;
      isLoading.value = false;
    } catch (isBlank) {
      isFiltered.value = true;
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return doctorBySpecialitiesModelData.value;
  }

  Future<SpecificAppointmentDetailsModel> getSpecificAppointmentDetails(
      String patientId, appointmentId) async {
    try {
      isLoading.value = true;
      specificAppointmentDetailsData.value =
          await BookAppointmentScreenService().getSpecificAppontmentDetails(
              patientId: patientId, appointmentId: appointmentId);
      isLoading.value = false;
    } catch (isBlank) {
      isLoading.value = false;
      Utils.showSnackBar('Error Occurred', 'Please try again later');
    }

    return specificAppointmentDetailsData.value;
  }

  String medicalName = '';
  List categoryOfMedicalCenter = [];
  var chooseMedicalCenter;

  setMedicalCenterId(String id, String name, String formUrl) {
    chooseMedicalCenter = id;
    medicalName = name;
    medicalCenterForm = formUrl;
    update();
  }

  Future getMedicalCenter({String? stateName, var chooseStateId}) async {
    medicalLoader.value = true;
    String url;
    // String state = "";
    url = '${Constants.medicalCenterURL}listar/v1/active-centres';
    // String url1 =
    //     '${Constants.medicalCenterURL}listar/v1/active-centres?location_slug=$state';
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    http.Response response = await http
        .get(Uri.parse(/*stateName != "" ? url1 :*/ url), headers: header);

    if (response.statusCode == 200) {
      if (response.body != "") {
        var result = jsonDecode(response.body);
        categoryOfMedicalCenter = result['data']['locations'];

        if (categoryOfMedicalCenter.isNotEmpty ||
            categoryOfMedicalCenter != []) {
          for (var element in categoryOfMedicalCenter) {
            if (element['post_title'].toString() == "United Natives") {
              medicalName =
                  categoryOfMedicalCenter.first['post_title'].toString();
              medicalCenterForm =
                  categoryOfMedicalCenter.first['google_form_url'].toString();
              chooseMedicalCenter =
                  categoryOfMedicalCenter.first['ID'].toString();
            }
          }
        }

        getDoctorSpecialities("", Get.overlayContext!,
            stateId: chooseStateId ?? "",
            medicalCenterId: chooseMedicalCenter ?? '');
        //   }
        // });
        update();
        medicalLoader.value = false;
        return result;
      }
    } else {
      medicalLoader.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    mySelectedDate.value =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    getSpecialities(false.obs);
  }

  int getDifference(int hour, String date) {
    if (date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      int nowSec = (TimeOfDay.now().hour * 60 + TimeOfDay.now().minute) * 60;
      int veiSec = (hour * 60 + 00) * 60;
      int dif = veiSec - nowSec;
      return dif;
    } else {
      return 1;
    }
  }

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  filterData() {
    items.clear();
    List<WeekAvailability> iterable = weekAvailabilityList;
    DateFormat format = DateFormat("yyyy-MM-dd");
    for (WeekAvailability element in iterable) {
      DateTime? localTime = element.date?.toLocal();
      String date =
          "${localTime?.year.toString()}-${localTime?.month.toString().padLeft(2, '0')}-${localTime?.day.toString().padLeft(2, '0')}";
      String date1 =
          "${localTime?.year.toString()}-${localTime?.month.toString().padLeft(2, '0')}-${(localTime!.day - 1).toString().padLeft(2, '0')}";
      String date2 =
          "${localTime.year.toString()}-${localTime.month.toString().padLeft(2, '0')}-${(localTime.day + 1).toString().padLeft(2, '0')}";
      Availability? availability = element.availability;
      if (format.format(DateTime.parse(mySelectedDate.value)) == date ||
          format.format(DateTime.parse(mySelectedDate.value)) == date1 ||
          format.format(DateTime.parse(mySelectedDate.value)) == date2) {
        if (availability != null) {
          availability.availData?.forEach(
            (e1) {
              if (e1.avail == "1" && e1.status != "Booked") {
                DateTime startUtcDateTime = e1.startTime!.toLocal();
                DateTime startDateTime = DateTime(
                    startUtcDateTime.year,
                    startUtcDateTime.month,
                    startUtcDateTime.day,
                    startUtcDateTime.hour,
                    startUtcDateTime.minute);
                DateTime now = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    DateTime.now().hour,
                    DateTime.now().minute);
                if (format.format(DateTime.parse(mySelectedDate.value)) ==
                    format.format(startDateTime)) {
                  if (format.format(now) == format.format(startDateTime)) {
                    if (now.isBefore(startDateTime)) {
                      items.add({
                        "start_time":
                            "${startDateTime.hour}:${startDateTime.toLocal().minute}",
                      });
                    }
                  } else {
                    items.add({
                      "start_time":
                          "${startDateTime.hour}:${startDateTime.toLocal().minute}",
                    });
                  }
                }
              }
            },
          );
        }
      }
    }
  }
}
