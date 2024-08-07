import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/model/patient_update_data.dart';
import 'package:doctor_appointment_booking/model/specialities_model.dart';
import 'package:doctor_appointment_booking/model/user.dart';
import 'package:doctor_appointment_booking/sevices/user_backend_auth_service.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/exception.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class UserUpdateController extends GetxController {
  final UserController _userController = Get.find();
  Rx<SpecialitiesModel> specialitiesModelData = SpecialitiesModel().obs;
  Rx<PatientUpdateDataModel> patientUpdateModelData =
      PatientUpdateDataModel().obs;

  final editProfileFlag = false.obs;

  File userProfilePic;

  // final File _image = .obs;
  final firstNameController = TextEditingController();
  final perAppointmentChargeController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final currentCaseContactController = TextEditingController();
  final certificateNoController = TextEditingController();
  final educationController = TextEditingController();
  final providerTypeController = TextEditingController();
  final specialityController = TextEditingController();

  final allergiesController = TextEditingController();
  final insuranceCompanyName = TextEditingController();
  final whatTribe1Controller = TextEditingController();
  final whatTribe2Controller = TextEditingController();

  ScrollController dScrollController = ScrollController();
  ScrollController pScrollController = ScrollController();

  final selectedGender = ''.obs;
  final selectedInsuranceEligibility = ''.obs;
  final selectedBloodGroup = ''.obs;
  final selectedTribalStatus = ''.obs;
  final selectedMaritalStatus = ''.obs;
  final dateOfBirth = "".obs;
  final certificateNo = ''.obs;
  final speciality = ''.obs;
  final education = ''.obs;

  final areYouAUSVeteran = ''.obs;
  final tribalFederallyMember = ''.obs;
  final tribalFederallyState = ''.obs;
  final tribalBackgroundStatus = ''.obs;

  // var genderItems = <String>['Male'.tr(), 'Female'.tr()];
  var genderItems = <String>['Male', 'Female', 'Non-Binary', 'Gender Neutral'];

  var _insuranceItems = <String>['Yes'.tr(), 'No'.tr()];
  static const _bloodGroupItem = <String>[
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  var _maritalItems = <String>[
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Other',
    'Do Not Wish to Answer'
  ];

  var _tribalBackgroundStatus = <String>[
    'Asian',
    'Black or African American',
    'Hispanic or Latino',
    'Native Hawaiian or Other Pacific Islander',
    'White'
  ];

  // var _maritalItems = <String>['Single'.tr(), 'Married'.tr()];
  var _tribalItems = <String>['Yes'.tr(), 'No'.tr()];
  String userProfile;
  String getStateId;
  String getCityId;
  String getMedicalCenterId;
  List<DropdownMenuItem<String>> dropDownGender;
  List<DropdownMenuItem<String>> dropDownSpeciality;
  List<DropdownMenuItem<String>> dropDownBlood;
  List<DropdownMenuItem<String>> dropDownMarital;
  List<DropdownMenuItem<String>> dropDownInsurance;
  List<DropdownMenuItem<String>> dropDownTribal;
  List<DropdownMenuItem<String>> dropDownAreYouAUSVeteran;
  List<DropdownMenuItem<String>> dropDownTribal1;
  List<DropdownMenuItem<String>> dropDownTribal2;
  List<DropdownMenuItem<String>> dropDownTribal3;

  // final DateTime now = DateTime.now();
  String convertedDateTime =
      "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

  onInitPage() {
    print('speciality.value${speciality.value}');
    firstNameController.text = _userController.user.value.firstName ?? '';
    perAppointmentChargeController.text =
        _userController.user.value.perAppointmentCharge ?? '';
    lastNameController.text = _userController.user.value.lastName ?? '';
    contactController.text = _userController.user.value.contactNumber ?? '';
    emailController.text = _userController.user.value.email ?? '';
    heightController.text = _userController.user.value.height ?? '';
    weightController.text = _userController.user.value.weight ?? '';
    emergencyContactController.text =
        _userController.user.value.emergencyContact ?? '';
    currentCaseContactController.text =
        _userController.user.value.currentCaseManagerInfo ?? '';
    educationController.text = _userController.user.value.education ?? '';
    providerTypeController.text = _userController.user.value.providerType ?? '';
    certificateNoController.text =
        _userController.user.value.certificateNo ?? '';
    specialityController.text = _userController.user.value.speciality ?? '';
    userProfile = _userController.user.value.profilePic;
    selectedGender.value = _userController.user.value.gender;
    speciality.value = _userController.user.value.speciality ?? "";
    dateOfBirth.value = _userController.user.value.dateOfBirth;
    selectedBloodGroup.value = _userController.user.value.bloodGroup;
    selectedMaritalStatus.value = _userController.user.value.maritalStatus;
    selectedInsuranceEligibility.value =
        _userController.user.value.insuranceEligibility;
    selectedTribalStatus.value = _userController.user.value.tribalStatus;
    getStateId = _userController.user.value.stateId;
    getCityId = _userController.user.value.cityId;
    getMedicalCenterId = _userController.user.value.medicalCenterID;

    areYouAUSVeteran.value = _userController.user.value.usVeteranStatus;
    tribalFederallyMember.value =
        _userController.user.value.tribalFederallyMember.isNotEmpty
            ? "Yes"
            : "No";

    tribalFederallyState.value =
        _userController.user.value.tribalFederallyState.isNotEmpty
            ? "Yes"
            : "No";
    tribalBackgroundStatus.value =
        _userController.user.value.tribalBackgroundStatus;

    allergiesController.text = _userController.user.value.allergies;
    insuranceCompanyName.text = _userController.user.value.insuranceCompanyName;
    whatTribe1Controller.text =
        _userController.user.value.tribalFederallyMember;
    whatTribe2Controller.text = _userController.user.value.tribalFederallyState;

    print("date init:--->>.${dateOfBirth.value}");
    _initDropDowns();
    print(
        '_userController.user.value.dateOfBirth==========>>>>>${_userController.user.value.dateOfBirth}');
  }

  void editProfile() => editProfileFlag.value = !editProfileFlag.value;

  _initDropDowns() {
    dropDownGender = genderItems
        .map((String value) =>
            DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    dropDownSpeciality = _userController
            .specialitiesModelData.value.specialities
            .map((map) => DropdownMenuItem<String>(
                value: map.specialityName, child: Text(map.specialityName)))
            ?.toList() ??
        [];

    // speciality.value = _userController
    //     .specialitiesModelData.value.specialities
    //     .map((map) => map.id).toString();

    dropDownBlood = _bloodGroupItem
        .map((String value) =>
            DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    dropDownMarital = _maritalItems
        .map((String value) =>
            DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    dropDownInsurance = _insuranceItems
        .map((String value) =>
            DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    dropDownTribal = _tribalItems
        .map((String value) =>
            DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    dropDownAreYouAUSVeteran = _tribalItems
        .map((String value) =>
            DropdownMenuItem<String>(value: value, child: Text(value)))
        .toList();

    dropDownTribal1 = _tribalItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();

    dropDownTribal2 = _tribalItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();

    dropDownTribal3 = _tribalBackgroundStatus
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();
  }

  void onChangeGender(value) => selectedGender.value = value ?? '';

  onChangeSpeciality(value) {
    speciality.value = value ?? '';
    print('speciality.value >>>  ${speciality.value}');
  }

  onDateOfBirth(value) => dateOfBirth.value = value ?? '';

  void onChangeBloodGroup(value) => selectedBloodGroup.value = value;

  void onChangeMaritalStatus(value) => selectedMaritalStatus.value = value;

  void onChangeInsuranceEligibility(value) =>
      selectedInsuranceEligibility.value = value;

  void onChangeTribalStatus(value) => selectedTribalStatus.value = value;
  void onAareYouAUSVeteran(value) => areYouAUSVeteran.value = value;
  void onChangeTribalFederallyStatus(value) =>
      tribalFederallyMember.value = value;
  void onChangeTribalStateStatus(value) => tribalFederallyState.value = value;
  void onChangeTribalBackgroundStatus(value) =>
      tribalBackgroundStatus.value = value;

  Future<PatientUpdateDataModel> userProfileUpdate(
      {User userUpdateData, File userProfilePic, String userType}) async {
    try {
      String id;
      _userController.specialitiesModelData.value.specialities
          .forEach((element) {
        if (element.specialityName == speciality.value) {
          id = element.id;
        }
      });

      User userUpdateData = User(
        // profilePic: userProfilePic ?? _userController.user.value.profilePic,
        id: _userController.user.value.id,
        email: _userController.user.value.email,
        firstName:
            firstNameController.text ?? _userController.user.value.firstName,
        lastName:
            lastNameController.text ?? _userController.user.value.lastName,
        contactNumber:
            contactController.text ?? _userController.user.value.contactNumber,
        gender: selectedGender.value ?? _userController.user.value.gender,
        dateOfBirth:
            dateOfBirth.value ?? _userController.user.value.dateOfBirth,
        bloodGroup:
            selectedBloodGroup.value ?? _userController.user.value.bloodGroup,
        maritalStatus: selectedMaritalStatus.value ??
            _userController.user.value.maritalStatus,
        height: heightController.text,
        weight: weightController.text,
        emergencyContact: emergencyContactController.text ??
            _userController.user.value.emergencyContact,
        currentCaseManagerInfo: currentCaseContactController.text ??
            _userController.user.value.currentCaseManagerInfo,
        insuranceEligibility: selectedInsuranceEligibility.value ??
            _userController.user.value.insuranceEligibility,
        tribalStatus: selectedTribalStatus.value ??
            _userController.user.value.tribalStatus,
        certificateNo: certificateNoController.text ??
            _userController.user.value.certificateNo,
        education:
            educationController.text ?? _userController.user.value.education,
        providerType: providerTypeController.text ??
            _userController.user.value.providerType,
        speciality: '${[id]}' ?? _userController.user.value.speciality,
        perAppointmentCharge: perAppointmentChargeController.text ??
            _userController.user.value.perAppointmentCharge,
        stateId: getStateId ?? _userController.user.value.stateId,
        medicalCenterID:
            getMedicalCenterId ?? _userController.user.value.medicalCenterID,
        cityId: getCityId ?? _userController.user.value.cityId,
        allergies: allergiesController.text.trim(),
        tribalFederallyState: whatTribe2Controller.text.trim(),
        tribalBackgroundStatus: tribalBackgroundStatus.value,
        tribalFederallyMember: whatTribe1Controller.text.trim(),
        usVeteranStatus: areYouAUSVeteran.value,
        insuranceCompanyName: insuranceCompanyName.text.trim(),
      );

      patientUpdateModelData.value = await UserBackendAuthService()
          .userProfileUpdate(userUpdateData, userProfilePic, userType);
      print(
          'patientUpdateModelData.value.patientUpdateData.caseManager==========>>>>>${patientUpdateModelData.value.patientUpdateData.caseManager}');
      _userController.updateUserData(
        userUpdateData,
        patientUpdateModelData.value.patientUpdateData.profilePic ??
            patientUpdateModelData.value.patientUpdateData.socialProfilePic,
        patientUpdateModelData.value.patientUpdateData.height,
        patientUpdateModelData.value.patientUpdateData.weight,
        patientUpdateModelData.value.patientUpdateData.emergencyContact,
        patientUpdateModelData.value.patientUpdateData.caseManager,
        patientUpdateModelData.value.patientUpdateData.certificate,
        patientUpdateModelData.value.patientUpdateData.education,
        patientUpdateModelData.value.patientUpdateData.speciality,
        perAppointmentChargeController.text ??
            _userController.user.value.perAppointmentCharge,
        patientUpdateModelData.value.patientUpdateData.stateName,
        patientUpdateModelData.value.patientUpdateData.cityName,
      );

      await _userController.getStateCityData();

      if (userType == "2") {
        String url = '${Constants.medicalCenterURL}listar/v1/active-centres';
        Map<String, String> header = {"Content-Type": "application/json"};
        http.Response response =
            await http.get(Uri.parse(url), headers: header);
        if (response.statusCode == 200) {
          var result = json.decode(response.body);
          result['data']['locations'].forEach(
            (element) {
              if (element['ID'].toString() ==
                  _userController.user.value.medicalCenterID.toString()) {
                _userController.user.value.medicalCenterName =
                    element['post_title'];
              }
            },
          );
        }
      }

      Get.back();

      Utils.showSnackBar('Update', 'Profile Update Successfully');
      return patientUpdateModelData.value;
    } catch (e) {
      print('e==========>>>>>$e');

      if (e is AppException) {
        Utils.showSnackBar('Update Error', e.message);
      } else {
        Utils.showSnackBar('Update Failed',
            "Please Filled All Details, All Details are Mandatory");
      }
      return null;
    }
  }
}

class ChangeState extends GetxController {
  String change = 'Blood Sugar 1 Hour';
  bool changeValue, changeVal2;
  void changeString(String value) {
    change = value;
    update();
  }

  void changeBool(bool value) {
    changeValue = value;
    changeVal2 = value;
    update();
  }

  Timer timer;
  int start = 0;
  DateTime date;
  DateTime startTimerDate;
  List<dynamic> locationList = [];
  double totalDistance = 0;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  StreamSubscription locationStream;

  Future<void> startTimer({String value}) async {
    final permissionStatus = await getCurrentLocation();

    if (permissionStatus == null) {
      Get.showSnackbar(GetSnackBar(
        padding: EdgeInsets.only(bottom: 10, top: 10, left: 20),
        messageText: Text(
          "Please give the location permission",
          style: TextStyle(color: Colors.white),
        ),
        title: 'ERROR',
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));

      return;
    }
    date = null;
    startTimerDate = DateTime.now();

    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) async {
        start++;
        dayHourMinuteSecondFunction(Duration(seconds: start));

        update();
        print('-start--$start');
      },
    );
  }

  void endTimer() {
    if (locationStream != null) {
      locationStream.pause();
      locationStream.cancel();
    }

    timer.cancel();
    start = 0;
    update();
  }

  void dayHourMinuteSecondFunction(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    // String days = twoDigits(duration.inDays);
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(twoDigitHours),
        int.parse(twoDigitMinutes),
        int.parse(twoDigitSeconds));
    print('--date--$date');
  }

  Future<dynamic> getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        Get.showSnackbar(GetSnackBar(
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 20),
          messageText: Text(
            "Please turn on the location services",
            style: TextStyle(color: Colors.white),
          ),
          title: 'Warning',
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
        getCurrentLocation();
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    locationList.clear();
    locationStream =
        location.onLocationChanged.listen((LocationData currentLocation) {
      print('CURRENT LOCATION ===>$currentLocation');
      Map<String, dynamic> location = {
        'Latitude': currentLocation.latitude,
        'Longitude': currentLocation.longitude
      };
      locationList.add(location);

      getDistance();
    });
    return true;
  }

  void getDistance() {
    totalDistance = 0;
    for (int i = 0; i < locationList.length - 1; i++) {
      var startLatitude = locationList[i]['Latitude'];
      var startLongitude = locationList[i]['Longitude'];
      var endLatitude = locationList[i + 1]['Latitude'];
      var endLongitude = locationList[i + 1]['Longitude'];

      const int earthRadius = 6371; // in kilometers

      double toRadians(double degree) {
        return degree * pi / 180.0;
      }

      double deltaLatitude = toRadians(endLatitude - startLatitude);
      double deltaLongitude = toRadians(endLongitude - startLongitude);

      double a = pow(sin(deltaLatitude / 2), 2) +
          cos(toRadians(startLatitude)) *
              cos(toRadians(endLatitude)) *
              pow(sin(deltaLongitude / 2), 2);

      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      totalDistance = earthRadius * c;
    }

    print('Total Distance: $totalDistance km');
  }
}
