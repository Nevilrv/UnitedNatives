import 'dart:convert';
import 'dart:developer';

import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/model/doctor_by_specialities.dart';
import 'package:doctor_appointment_booking/model/doctor_filter_model.dart';
import 'package:doctor_appointment_booking/model/doctor_specialities_filter_model.dart';
import 'package:doctor_appointment_booking/model/patient_appointment_model.dart';
import 'package:doctor_appointment_booking/model/specialities_model.dart';
import 'package:doctor_appointment_booking/model/specific_appointment_details_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:doctor_appointment_booking/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:doctor_appointment_booking/sevices/book_appointment_screen_service.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  UserController _userController = Get.find<UserController>();
  RxInt selectedIndex = (-1).obs;

  RxString mySelectedDate = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isFiltered = true.obs;

  // RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;
  int allDoctorCount = 0;
  int doctorCount = 0;
  int ihOrNatives = 1;
  String medicalCenterForm;
  String medicalCenterId;

  changeValue(int value) {
    ihOrNatives = value;
    update();
  }

  // int i = 0;
  //
  // int updateCount() {
  //   i = 0;
  //   items.forEach((element) {
  //     if (element <=
  //             int.parse("${DateTime.now().toString().substring(11, 13)}") &&
  //         00 < int.parse("${DateTime.now().toString().substring(14, 16)}") &&
  //         mySelectedDate.value == DateTime.now().toString().split(" ")[0]) {
  //       i = i + 1;
  //     }
  //   });
  //   return i;
  // }

  RxBool medicalLoader = true.obs;

  GetStatesResponseModel selectedState;
  List<GetCityResponseModel> cityList = [];
  GetCityResponseModel selectedCity;

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
      specialitiesModelData.value.specialities.forEach((element) {
        allDoctorCount += int.parse(element.doctorsCount.toString());
        print('==AllDoctorCount===>$allDoctorCount');
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
      {String stateId, String medicalCenterId}) async {
    try {
      log('medicalCenterId---------->>>>>>>>$medicalCenterId');

      isFiltered.value = true;
      isLoading.value = true;
      doctorBySpecialitiesModelData.value = await BookAppointmentScreenService()
          .doctorBySpecialitiesModel(_userController.user.value.id,
              specialityId, stateId ?? "", medicalCenterId ?? "");
      doctorCount = doctorBySpecialitiesModelData.value.doctorsCount;
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
          '${DateFormat('yyyy-MM-dd').format(DateTime.now().toUtc())}';
      patientAppointmentModelData.value = await BookAppointmentScreenService()
          .patientAppointmentModel(
              patientId: _userController.user.value.id,
              doctorId: doctorId,
              availabilityDate: availabilityDate);
      weekAvailabilityList.clear();
      weekAvailabilityList
          .addAll(patientAppointmentModelData.value.data.weekAvailability);

      List<WeekAvailability> iterable = weekAvailabilityList;

      List<DateTime> dayList = [];

      iterable.forEach((element) {
        dayList.add(element.date);
      });

      DateFormat format = DateFormat("yyyy-MM-dd");

      /*for (var i = 0; i < iterable.length; i++) {
        DateTime localTime = dayList[i].toLocal();
        String date =
            "${localTime.year.toString()}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')}";
        Availability availability = iterable[i].availability;

        if (availability != null) {
          availability.availData.forEach(
            (e1) {
              DateTime startUtcDateTime = e1.startTime.toLocal();
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

              if (format.format(DateTime.parse(date)) ==
                  format.format(startDateTime)) {
                if (e1.avail == "1" && e1.status != "Booked") {
                  if (format.format(now) == format.format(startDateTime)) {
                    if (now.isBefore(startDateTime)) {
                      iterable[i].actualSlotCount =
                          iterable[i].actualSlotCount + 1;
                    }
                  } else {
                    iterable[i].actualSlotCount =
                        iterable[i].actualSlotCount + 1;
                  }
                }
              }
            },
          );
        }
      }*/

      List<DateTime> tempDayList = [];

      for (var i = 0; i < iterable.length; i++) {
        Availability availability = iterable[i].availability;
        if (availability != null) {
          availability.availData.forEach(
            (e1) {
              if (e1.avail == "1" && e1.status != "Booked") {
                DateTime startUtcDateTime = e1.startTime.toLocal();
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
            DateFormat("yyyy-MM-dd").format(element.date));
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
    tempDayList.forEach(
      (el2) {
        if (el2.toString().contains(format.format(dayList[index]))) {
          if (now.isBefore(el2)) {
            iterable[index].actualSlotCount++;
          }
        }
      },
    );
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

  Future getMedicalCenter({String stateName, var chooseStateId}) async {
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
      if (response.body != "" || response.body != null) {
        var result = jsonDecode(response.body);
        print("result--->$result");
        categoryOfMedicalCenter = result['data']['locations'];

        if (categoryOfMedicalCenter.isNotEmpty ||
            categoryOfMedicalCenter != null) {
          categoryOfMedicalCenter.forEach((element) {
            if (element['post_title'].toString() == "United Natives") {
              medicalName =
                  categoryOfMedicalCenter.first['post_title'].toString();
              medicalCenterForm =
                  categoryOfMedicalCenter.first['google_form_url'].toString();
              chooseMedicalCenter =
                  categoryOfMedicalCenter.first['ID'].toString();
            }
          });
        }
        // getSpecialities(false.obs,
        //     stateId: chooseStateId ?? "",
        //     medicalCenterId: chooseMedicalCenter ?? '');

        getDoctorSpecialities("", Get.overlayContext,
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
      print('ERROR IN GETTING MEDICAL CENTER DETAILS');
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

/*  filterData() {
    items.clear();
    List<WeekAvailability> iterable = weekAvailabilityList;
    for (WeekAvailability element in iterable) {
      String date = element.date;
      Availability availability = element.availability;

      if (mySelectedDate.value == date) {
        if (availability?.avail8 == "1" &&
            availability.availStatus8 != "Booked") {
          items.add({"time": 8, "show": "8:00\nAM"});
        }
        if (availability?.avail9 == "1" &&
            availability.availStatus9 != "Booked") {
          items.add({"time": 9, "show": "9:00\nAM"});
        }

        if (availability?.avail10 == "1" &&
            availability.availStatus10 != "Booked") {
          items.add({"time": 10, "show": "10:00\nAM"});
        }
        if (availability?.avail11 == "1" &&
            availability.availStatus11 != "Booked") {
          items.add({"time": 11, "show": "11:00\nAM"});
        }
        if (availability?.avail12 == "1" &&
            availability.availStatus12 != "Booked") {
          items.add({"time": 12, "show": "12:00\nAM"});
        }
        if (availability?.avail13 == "1" &&
            availability.availStatus13 != "Booked") {
          items.add({"time": 13, "show": "1:00\nPM"});
        }
        if (availability?.avail14 == "1" &&
            availability.availStatus14 != "Booked") {
          items.add({"time": 14, "show": "2:00\nPM"});
        }
        if (availability?.avail15 == "1" &&
            availability.availStatus15 != "Booked") {
          items.add({"time": 15, "show": "3:00\nPM"});
        }
        if (availability?.avail16 == "1" &&
            availability.availStatus16 != "Booked") {
          items.add({"time": 16, "show": "4:00\nPM"});
        }
        if (availability?.avail17 == "1" &&
            availability.availStatus17 != "Booked") {
          items.add({"time": 17, "show": "5:00\nPM"});
        }
        if (availability?.avail18 == "1" &&
            availability.availStatus18 != "Booked") {
          items.add({"time": 18, "show": "6:00\nPM"});
        }
        if (availability?.avail19 == "1" &&
            availability.availStatus19 != "Booked") {
          items.add({"time": 19, "show": "7:00\nPM"});
        }
        if (availability?.avail20 == "1" &&
            availability.availStatus20 != "Booked") {
          items.add({"time": 20, "show": "8:00\nPM"});
        }
        if (availability?.avail21 == "1" &&
            availability.availStatus21 != "Booked") {
          items.add({"time": 21, "show": "9:00\nPM"});
        }
        if (availability?.avail22 == "1" &&
            availability.availStatus22 != "Booked") {
          items.add({"time": 22, "show": "10:00\nPM"});
        }
        if (availability?.avail23 == "1" &&
            availability.availStatus23 != "Booked") {
          items.add({"time": 23, "show": "11:00\nPM"});
        }
      }

      // if (mySelectedDate.value == date) {
      //   if (availability?.avail8 == "1" &&
      //       availability.availStatus8 != "Booked" &&
      //       getDifference(8) > 0) {
      //     items.add(8);
      //   }
      //   if (availability?.avail9 == "1" &&
      //       availability.availStatus9 != "Booked" &&
      //       getDifference(9) > 0) {
      //     items.add(9);
      //   }
      //
      //   if (availability?.avail10 == "1" &&
      //       availability.availStatus10 != "Booked" &&
      //       getDifference(10) > 0) {
      //     items.add(10);
      //   }
      //   if (availability?.avail11 == "1" &&
      //       availability.availStatus11 != "Booked" &&
      //       getDifference(11) > 0) {
      //     items.add(11);
      //   }
      //   if (availability?.avail12 == "1" &&
      //       availability.availStatus12 != "Booked" &&
      //       getDifference(12) > 0) {
      //     items.add(12);
      //   }
      //   if (availability?.avail13 == "1" &&
      //       availability.availStatus13 != "Booked" &&
      //       getDifference(13) > 0) {
      //     items.add(13);
      //   }
      //   if (availability?.avail14 == "1" &&
      //       availability.availStatus14 != "Booked" &&
      //       getDifference(14) > 0) {
      //     items.add(14);
      //   }
      //   if (availability?.avail15 == "1" &&
      //       availability.availStatus15 != "Booked" &&
      //       getDifference(15) > 0) {
      //     items.add(15);
      //   }
      //   if (availability?.avail16 == "1" &&
      //       availability.availStatus16 != "Booked" &&
      //       getDifference(16) > 0) {
      //     items.add(16);
      //   }
      //   if (availability?.avail17 == "1" &&
      //       availability.availStatus17 != "Booked" &&
      //       getDifference(17) > 0) {
      //     items.add(17);
      //   }
      //   if (availability?.avail18 == "1" &&
      //       availability.availStatus18 != "Booked" &&
      //       getDifference(18) > 0) {
      //     items.add(18);
      //   }
      //   if (availability?.avail19 == "1" &&
      //       availability.availStatus19 != "Booked" &&
      //       getDifference(19) > 0) {
      //     items.add(19);
      //   }
      //   if (availability?.avail20 == "1" &&
      //       availability.availStatus20 != "Booked" &&
      //       getDifference(20) > 0) {
      //     items.add(20);
      //   }
      //   if (availability?.avail21 == "1" &&
      //       availability.availStatus21 != "Booked" &&
      //       getDifference(21) > 0) {
      //     items.add(21);
      //   }
      //   if (availability?.avail22 == "1" &&
      //       availability.availStatus22 != "Booked" &&
      //       getDifference(22) > 0) {
      //     items.add(22);
      //   }
      //   if (availability?.avail23 == "1" &&
      //       availability.availStatus23 != "Booked" &&
      //       getDifference(23) > 0) {
      //     items.add(23);
      //   }
      // }
    }
  }*/

  // RxList<int> items = <int>[].obs;
  ///
  // filterData() {
  //   items.clear();
  //   List<WeekAvailability> iterable = weekAvailabilityList;
  //   for (WeekAvailability element in iterable) {
  //     String date = element.date;
  //     Availability availability = element.availability;
  //
  //     if (mySelectedDate.value == date) {
  //       if (availability?.avail8 == "1" &&
  //           availability.availStatus8 != "Booked") {
  //         items.add(8);
  //       }
  //       if (availability?.avail9 == "1" &&
  //           availability.availStatus9 != "Booked") {
  //         items.add(9);
  //       }
  //
  //       if (availability?.avail10 == "1" &&
  //           availability.availStatus10 != "Booked") {
  //         items.add(10);
  //       }
  //       if (availability?.avail11 == "1" &&
  //           availability.availStatus11 != "Booked") {
  //         items.add(11);
  //       }
  //       if (availability?.avail12 == "1" &&
  //           availability.availStatus12 != "Booked") {
  //         items.add(12);
  //       }
  //       if (availability?.avail13 == "1" &&
  //           availability.availStatus13 != "Booked") {
  //         items.add(13);
  //       }
  //       if (availability?.avail14 == "1" &&
  //           availability.availStatus14 != "Booked") {
  //         items.add(14);
  //       }
  //       if (availability?.avail15 == "1" &&
  //           availability.availStatus15 != "Booked") {
  //         items.add(15);
  //       }
  //       if (availability?.avail16 == "1" &&
  //           availability.availStatus16 != "Booked") {
  //         items.add(16);
  //       }
  //       if (availability?.avail17 == "1" &&
  //           availability.availStatus17 != "Booked") {
  //         items.add(17);
  //       }
  //       if (availability?.avail18 == "1" &&
  //           availability.availStatus18 != "Booked") {
  //         items.add(18);
  //       }
  //       if (availability?.avail19 == "1" &&
  //           availability.availStatus19 != "Booked") {
  //         items.add(19);
  //       }
  //       if (availability?.avail20 == "1" &&
  //           availability.availStatus20 != "Booked") {
  //         items.add(20);
  //       }
  //       if (availability?.avail21 == "1" &&
  //           availability.availStatus21 != "Booked") {
  //         items.add(21);
  //       }
  //       if (availability?.avail22 == "1" &&
  //           availability.availStatus22 != "Booked") {
  //         items.add(22);
  //       }
  //       if (availability?.avail23 == "1" &&
  //           availability.availStatus23 != "Booked") {
  //         items.add(23);
  //       }
  //     }
  //
  //     // if (mySelectedDate.value == date) {
  //     //   if (availability?.avail8 == "1" &&
  //     //       availability.availStatus8 != "Booked" &&
  //     //       getDifference(8) > 0) {
  //     //     items.add(8);
  //     //   }
  //     //   if (availability?.avail9 == "1" &&
  //     //       availability.availStatus9 != "Booked" &&
  //     //       getDifference(9) > 0) {
  //     //     items.add(9);
  //     //   }
  //     //
  //     //   if (availability?.avail10 == "1" &&
  //     //       availability.availStatus10 != "Booked" &&
  //     //       getDifference(10) > 0) {
  //     //     items.add(10);
  //     //   }
  //     //   if (availability?.avail11 == "1" &&
  //     //       availability.availStatus11 != "Booked" &&
  //     //       getDifference(11) > 0) {
  //     //     items.add(11);
  //     //   }
  //     //   if (availability?.avail12 == "1" &&
  //     //       availability.availStatus12 != "Booked" &&
  //     //       getDifference(12) > 0) {
  //     //     items.add(12);
  //     //   }
  //     //   if (availability?.avail13 == "1" &&
  //     //       availability.availStatus13 != "Booked" &&
  //     //       getDifference(13) > 0) {
  //     //     items.add(13);
  //     //   }
  //     //   if (availability?.avail14 == "1" &&
  //     //       availability.availStatus14 != "Booked" &&
  //     //       getDifference(14) > 0) {
  //     //     items.add(14);
  //     //   }
  //     //   if (availability?.avail15 == "1" &&
  //     //       availability.availStatus15 != "Booked" &&
  //     //       getDifference(15) > 0) {
  //     //     items.add(15);
  //     //   }
  //     //   if (availability?.avail16 == "1" &&
  //     //       availability.availStatus16 != "Booked" &&
  //     //       getDifference(16) > 0) {
  //     //     items.add(16);
  //     //   }
  //     //   if (availability?.avail17 == "1" &&
  //     //       availability.availStatus17 != "Booked" &&
  //     //       getDifference(17) > 0) {
  //     //     items.add(17);
  //     //   }
  //     //   if (availability?.avail18 == "1" &&
  //     //       availability.availStatus18 != "Booked" &&
  //     //       getDifference(18) > 0) {
  //     //     items.add(18);
  //     //   }
  //     //   if (availability?.avail19 == "1" &&
  //     //       availability.availStatus19 != "Booked" &&
  //     //       getDifference(19) > 0) {
  //     //     items.add(19);
  //     //   }
  //     //   if (availability?.avail20 == "1" &&
  //     //       availability.availStatus20 != "Booked" &&
  //     //       getDifference(20) > 0) {
  //     //     items.add(20);
  //     //   }
  //     //   if (availability?.avail21 == "1" &&
  //     //       availability.availStatus21 != "Booked" &&
  //     //       getDifference(21) > 0) {
  //     //     items.add(21);
  //     //   }
  //     //   if (availability?.avail22 == "1" &&
  //     //       availability.availStatus22 != "Booked" &&
  //     //       getDifference(22) > 0) {
  //     //     items.add(22);
  //     //   }
  //     //   if (availability?.avail23 == "1" &&
  //     //       availability.availStatus23 != "Booked" &&
  //     //       getDifference(23) > 0) {
  //     //     items.add(23);
  //     //   }
  //     // }
  //   }
  // }

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  filterData() {
    items.clear();
    List<WeekAvailability> iterable = weekAvailabilityList;
    DateFormat format = DateFormat("yyyy-MM-dd");
    for (WeekAvailability element in iterable) {
      DateTime localTime = element.date.toLocal();
      String date =
          "${localTime.year.toString()}-${localTime.month.toString().padLeft(2, '0')}-${localTime.day.toString().padLeft(2, '0')}";
      String date1 =
          "${localTime.year.toString()}-${localTime.month.toString().padLeft(2, '0')}-${(localTime.day - 1).toString().padLeft(2, '0')}";
      String date2 =
          "${localTime.year.toString()}-${localTime.month.toString().padLeft(2, '0')}-${(localTime.day + 1).toString().padLeft(2, '0')}";
      Availability availability = element.availability;
      if (format.format(DateTime.parse(mySelectedDate.value)) == date ||
          format.format(DateTime.parse(mySelectedDate.value)) == date1 ||
          format.format(DateTime.parse(mySelectedDate.value)) == date2) {
        if (availability != null) {
          availability.availData.forEach(
            (e1) {
              if (e1.avail == "1" && e1.status != "Booked") {
                DateTime startUtcDateTime = e1.startTime.toLocal();
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
