import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:united_natives/pages/login/phoneAuthScreen3.dart';
import 'package:http/http.dart' as http;
import 'package:united_natives/controller/doctor_homescreen_controller.dart';
import 'package:united_natives/controller/patient_homescreen_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/getSorted_patient_chatList_model.dart';
import 'package:united_natives/model/get_sorted_chat_list_doctor_model.dart';
import 'package:united_natives/model/login_verification.dart';
import 'package:united_natives/model/pin_status_model.dart';
import 'package:united_natives/model/reset_pin_model.dart';
import 'package:united_natives/model/social_login_google_verification.dart';
import 'package:united_natives/model/specialities_model.dart';
import 'package:united_natives/model/user.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/pages/appointment/doctor_appointment.dart';
import 'package:united_natives/pages/appointment/my_appointments_page.dart';
import 'package:united_natives/pages/doctormessages/messages_detail_page.dart';
import 'package:united_natives/pages/messages/messages_detail_page.dart';
import 'package:united_natives/pages/notifications/patient_notification_page.dart';
import 'package:united_natives/pages/prescription/prescription_list_page.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/sevices/user_backend_auth_service.dart';
import 'package:united_natives/utils/app_enum.dart';
import 'package:united_natives/utils/app_themes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/add_new_chat_message_view_model.dart';
import 'package:united_natives/viewModel/get_city_view_model.dart';
import 'package:united_natives/viewModel/get_states_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserController extends GetxController {
  Rx<User> user = User().obs;
  Rx<SpecialitiesModel> specialitiesModelData = SpecialitiesModel().obs;
  RxBool isLoading = false.obs;

  User? registerData;
  User? loginData;
  File? registerUserProfile;
  File? updateProfilePic;
  UserCredential? authResult;
  bool isShow = false;
  LoginVerificationData? loginVerificationData;
  PINStatusModel? pinStatusModelData;
  bool isCheck = false;
  // final RoundedLoadingButtonController _btnController =
  //     new RoundedLoadingButtonController();

  RxString selectedGender = ''.obs;
  RxString selectedSpeciality = ''.obs;
  RxString selectedInsuranceEligibility = ''.obs;
  RxString areYouAUSVeteran = ''.obs;
  RxString selectedBloodGroup = ''.obs;
  RxString selectedTribalStatus = ''.obs;
  RxString selectedMaritalStatus = ''.obs;
  RxString dateOfBirth = ''.obs;
  RxString certificateNo = ''.obs;
  RxString speciality = ''.obs;
  RxString education = ''.obs;

  RxString tribalFederallyMember = ''.obs;
  RxString tribalFederallyState = ''.obs;
  RxString tribalBackgroundStatus = ''.obs;
  RxString howYouHereAboutUs = ''.obs;

  onDispose() {
    selectedGender = ''.obs;
    selectedSpeciality = ''.obs;
    selectedInsuranceEligibility = ''.obs;
    areYouAUSVeteran = ''.obs;
    selectedBloodGroup = ''.obs;
    selectedTribalStatus = ''.obs;
    tribalFederallyMember = ''.obs;
    tribalFederallyState = ''.obs;
    tribalBackgroundStatus = ''.obs;
    selectedMaritalStatus = ''.obs;
    dateOfBirth = ''.obs;
    certificateNo = ''.obs;
    speciality = ''.obs;
    education = ''.obs;
  }

  final _genderItems = <String>[
    'Male',
    'Female',
    'Non-Binary',
    'Gender Neutral'
  ];
  final _insuranceItems = <String>['Yes', 'No'];
  final _howYouHereAboutUs = <String>[
    "Social media",
    "Flyer",
    "Referred",
    "Other"
  ];
  final _areYouAUSVeteran = <String>['Yes', 'No'];
  final _tribalBackgroundStatus = <String>[
    'Asian',
    'Black or African American',
    'Hispanic or Latino',
    'Native Hawaiian or Other Pacific Islander',
    'White',
    'Native American',
    'Alaska Native'
  ];
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
  final _maritalItems = <String>[
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Other',
    'Do Not Wish to Answer'
  ];
  final _tribalItems = <String>['Yes', 'No'];
  String? userProfile;

  List<DropdownMenuItem<String>>? dropDownGender;
  List<Map<String, dynamic>> dropDownSpeciality = [];
  // List<DropdownMenuItem<String>>? dropDownSpeciality;
  List<DropdownMenuItem<String>>? dropDownBlood;
  List<DropdownMenuItem<String>>? dropDownMarital;
  List<DropdownMenuItem<String>>? dropDownInsurance;
  List<DropdownMenuItem<String>>? dropDownTribal;
  List<DropdownMenuItem<String>>? dropDownTribal1;
  List<DropdownMenuItem<String>>? dropDownTribal2;
  List<DropdownMenuItem<String>>? dropDownTribal3;
  List<DropdownMenuItem<String>>? dropDownAreYouAUSVeteran;
  List<DropdownMenuItem<String>>? dropDownHowYouHereAboutUs;

  @override
  onInit() {
    getSpecialities();
    _initDropDowns();
    super.onInit();
  }

  RxBool _isInitialNotification = false.obs;

  RxBool get isInitialNotification => _isInitialNotification;

  set isInitialNotification(RxBool value) {
    _isInitialNotification = value;
    update();
  }

  final RxBool _isPinScreen = false.obs;

  RxBool get isPinScreen => _isPinScreen;

  set isPinScreen(RxBool value) {
    _isPinScreen.value = value.value;
    update();
  }

  final RxString _isScreenName = ''.obs;

  RxString get isScreenName => _isScreenName;

  set isScreenName(RxString value) {
    _isScreenName.value = value.value;

    update();
  }

  final RxString _notificationValue = ''.obs;

  RxString get notificationValue => _notificationValue;

  set notificationValue(RxString value) {
    _notificationValue.value = value.value;
    update();
  }

  _initDropDowns() {
    dropDownGender = _genderItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();

    dropDownBlood = _bloodGroupItem
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();

    dropDownMarital = _maritalItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();

    dropDownInsurance = _insuranceItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();

    dropDownTribal = _tribalItems
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
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
    dropDownAreYouAUSVeteran = _areYouAUSVeteran
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
    dropDownHowYouHereAboutUs = _howYouHereAboutUs
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ),
        )
        .toList();
  }

  void onChangeGender(value) => selectedGender.value = value ?? '';
  void onAareYouAUSVeteran(value) => areYouAUSVeteran.value = value ?? '';
  void onChangeSpeciality(value) => selectedSpeciality.value = value ?? '';

  void onDateOfBirth(value) => dateOfBirth.value = value ?? '';

  void onChangeBloodGroup(value) => selectedBloodGroup.value = value;

  void onChangeMaritalStatus(value) => selectedMaritalStatus.value = value;

  void onChangeInsuranceEligibility(value) =>
      selectedInsuranceEligibility.value = value;

  void onChangeTribalStatus(value) => selectedTribalStatus.value = value;
  void onChangeTribalFederallyStatus(value) =>
      tribalFederallyMember.value = value;
  void onChangeTribalStateStatus(value) => tribalFederallyState.value = value;
  void onChangeTribalBackgroundStatus(value) =>
      tribalBackgroundStatus.value = value;
  void onChangeHowYouHereAboutUsStatus(value) =>
      howYouHereAboutUs.value = value;

  Future userRegister(User userData, String userType, String bearerToken,
      {File? useProfilePic}) async {
    try {
      User userData = User(
        firstName: registerData?.firstName,
        lastName: registerData?.lastName,
        gender: selectedGender.value,
        email: registerData?.email,
        contactNumber: registerData?.contactNumber,
        emergencyContact: registerData?.emergencyContact,
        dateOfBirth: registerData?.dateOfBirth ?? "",
        certificateNo: registerData?.certificateNo,
        perAppointmentCharge: registerData?.perAppointmentCharge,
        password: registerData?.password,
        bloodGroup: selectedBloodGroup.value,
        allergies: registerData?.allergies,
        maritalStatus: selectedMaritalStatus.value,
        insuranceEligibility: selectedInsuranceEligibility.value,
        insuranceCompanyName: registerData?.insuranceCompanyName,
        usVeteranStatus: areYouAUSVeteran.value,
        tribalStatus: selectedTribalStatus.value,
        tribalFederallyMember: registerData?.tribalFederallyMember,
        tribalFederallyState: registerData?.tribalFederallyState,
        tribalBackgroundStatus: registerData?.tribalBackgroundStatus,
        howDidYouHearAboutUs: registerData?.howDidYouHearAboutUs,
        education: registerData?.education,
        speciality: registerData?.speciality,
        state: registerData?.state ?? "",
        //isAdmin: registerData.isAdmin,
        city: registerData?.city ?? "",
        isNativeAmerican: registerData?.isNativeAmerican ?? "",
        isIhUser: registerData?.isIhUser,
        medicalCenterID: registerData?.medicalCenterID ?? "",
        providerType: registerData?.providerType ?? "",
        height: registerData?.height,
        weight: registerData?.weight,
        currentCaseManagerInfo: registerData?.currentCaseManagerInfo,
      );
      debugPrint("registerData.providerType----->${jsonEncode(userData)}");
      await UserBackendAuthService().register(userData, userType, bearerToken,
          profilePic: registerUserProfile ?? File(""));
      // await Prefs.setString(Prefs.BEARER, bearerToken);
      if (userType == "1") {
        Get.toNamed(Routes.login);
      } else {
        Get.toNamed(Routes.doctorlogin);
      }
      Utils.showSnackBar('Register Successfully', 'Please Login');
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Register Error', e.message);
      } else {
        Utils.showSnackBar('Register failed', "Please try again later");
      }
    }
  }

  Future<SpecialitiesModel> getSpecialities() async {
    try {
      specialitiesModelData.value =
          await UserBackendAuthService().specialitiesModelDropDown();

      for (var element in specialitiesModelData.value.specialities!) {
        dropDownSpeciality.add(element.toJson());
      }

      // dropDownSpeciality = specialitiesModelData.value.specialities
      //         ?.map((map) => DropdownMenuItem<String>(
      //             value: map.id, child: Text(map.specialityName ?? "")))
      //         .toList() ??
      //     [];
    } catch (isBlank) {
      // Utils.showSnackBar(
      //      'Error Occurred',  'Please try again later');
    }

    return specialitiesModelData.value;
  }

  Future userSocialRegister(
      User userData,
      String
          // firstName,
          // lastName,
          // gender,
          // email,
          // password,
          // bloodGroup,
          // maritalStatus,
          // emergencyContact,
          // insuranceEligibility,
          // tribalStatus,
          userType,
      bearerToken,
      // perAppointmentCharge,
      {File? useProfilePic}) async {
    try {
      await UserBackendAuthService().socialRegister(
          userData, userType, bearerToken,
          useProfilePic: useProfilePic ?? File(""));
      // await Prefs.setString(Prefs.BEARER, bearerToken);
      if (userType == "1") {
        Get.toNamed(Routes.login);
      } else {
        Get.toNamed(Routes.doctorlogin);
      }
      Utils.showSnackBar('Register Successfully', 'Please Login');
    } catch (e) {
      if (e is AppException) {
        // Utils.showSnackBar( 'Register Error',  e.message);
      } else {
        Utils.showSnackBar('Register Failed', "Please try again later");
      }
    }
  }

  Future socialLogin(String loginType, String id, firstName, lastName, gender,
      email, password, userType, bearerToken, socialProfilePic) async {
    try {
      user.value = await UserBackendAuthService().socialLogin(
          loginType,
          id,
          firstName,
          lastName,
          gender,
          email,
          password,
          userType,
          bearerToken,
          socialProfilePic);

      log('user.value==========>>>>>${user.value}');

      await Prefs.setString(Prefs.BEARER, bearerToken);
      await Prefs.setString(Prefs.EMAIL, email);
      await Prefs.setString(Prefs.profileImage, socialProfilePic);
      await Prefs.setString(Prefs.USERTYPE, userType);
      await Prefs.setString(Prefs.LOGINTYPE, loginType);
      await Prefs.setString(Prefs.SOCIALID, id);
      await Prefs.setString(Prefs.normalPassword, '12345678');
      Get.changeTheme(Prefs.getBool(Prefs.DARKTHEME, def: false)
          ? Themes().isDark
          : Themes().isLight);

      if (userType == "1") {
        Get.toNamed(Routes.home);
      } else if (userType == "2") {
        Get.toNamed(Routes.home2);
      }
      Utils.showSnackBar('Welcome $firstName', 'Google Sign in Successfully!');
      return user.value;
    } catch (e) {
      log('e======1111====>>>>>$e');
      if (e is AppException) {
        Utils.showSnackBar('Login Failed', e.message);
      } else {
        Utils.showSnackBar('Login Failed', "Please try again later");
      }
    }
  }

  Future socialUserRegister() async {
    try {
      UserCredential authResult =
          await UserBackendAuthService().signInWithGoogle();

      // await Prefs.setString(Prefs.BEARER, bearerToken);
      // if (userType == "1"){
      //   Get.toNamed(Routes.login);
      // }else{
      //   Get.toNamed(Routes.doctorlogin);
      // }

      Utils.showSnackBar(
          'Please Enter Secure PIN', 'Google Sign in Successful!');
      return authResult;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Login Error', e.message);
      } else {
        Utils.showSnackBar('Login Failed', "Please try again later");
      }
    }
  }

  Future forgotPassword(User userData) async {
    try {
      await UserBackendAuthService().forgotPassword(userData);
      Get.back();
      Utils.showSnackBar(
          'Password Reset', 'Reset link sent to your registered Email');
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar(
            'We can\'t sent Reset Password link', 'Please try again later');
      }
    }
  }

  bool changePasswordLoader = false;

  Future changePassword(String email) async {
    try {
      Get.back();
      changePasswordLoader = true;
      update();
      await UserBackendAuthService().changePassword(email);
      changePasswordLoader = false;
      update();

      Utils.showSnackBar(
          'Password Reset', 'Reset link sent to your registered Email');
    } catch (e) {
      changePasswordLoader = false;
      update();
      if (e is AppException) {
        Get.back();
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Get.back();
        Utils.showSnackBar(
            'We can\'t sent Reset Password link', 'Please try again later');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await UserBackendAuthService().signOut();
      Utils.showSnackBar("Sign Out Successfully!", "Visit Again");
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar('We can\'t sign out!', 'Please try again later');
      }
    }
  }

  Future resetPIN(String userId, BuildContext context) async {
    try {
      ResetPIN resetPINData = await UserBackendAuthService().resetPIN(userId);

      pinStatusModelData = await statusPIN(userId);

      if (pinStatusModelData?.pinStatusData?.requestStatus == "2") {
        if (!context.mounted) return;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneVerification3(
                  loginVerificationData: loginVerificationData,
                  resetPINId: "${pinStatusModelData?.pinStatusData?.id}"),
            ));
      } else {
        Get.offAndToNamed(Routes.login);
      }

      Utils.showSnackBar("${resetPINData.message}",
          "Request ID for reset PIN is ${resetPINData.requestId.toString()}, Please wait...");
      return resetPINData;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar(
            'We can\'t Reset  your Secure PIN', 'Please try again later');
      }
    }
  }

  Future<PINStatusModel> statusPIN(String userId) async {
    try {
      PINStatusModel pinStatusModelData =
          await UserBackendAuthService().pinStatus(userId);
      return pinStatusModelData;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar(
            'We can\'t check your Secure PIN Status', 'Please try again later');
      }
      return PINStatusModel();
    }
  }

  Future loginVerificationDetails(String email, password) async {
    try {
      LoginVerificationData loginVerificationData =
          await UserBackendAuthService()
              .loginVerificationDetails(email: email, password: password);
      // Navigator.pop(context);
      // Utils.showSnackBar( 'PIN Reset',
      //      'Reset link sent to your registered Email');
      return loginVerificationData;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar(
            'We can\'t sent Reset PIN link', 'Please try again later');
      }
    }
  }

  Future loginVerification(String email, password, String textPassword) async {
    try {
      LoginVerification loginVerification = await UserBackendAuthService()
          .loginVerification(email: email, password: password);

      if (loginVerification.status == "Fail") {
        Utils.showSnackBar('Warning!', "${loginVerification.message}");
        return;
      }

      // if (loginVerification.loginVerificationData.isFirstTime == "1") {
      //   Get.toNamed(Routes.requestPhoneVerification);
      // } else {
      Get.toNamed(Routes.phoneAuthScreen2, arguments: isShow = true);
      Prefs.setString(Prefs.normalPassword, textPassword);
      Prefs.setString(
          Prefs.isLoginFirst,
          loginVerification.loginVerificationData?.isFirstTime == "1"
              ? "1"
              : "");
      Utils.showSnackBar(
          '$email Successfully Login!', 'Enter Your Secret PIN to continue...');
      // }

      return loginVerification;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar('Error!!!!!!!!!!!!!!!', 'Please try again later');
      }
    }
  }

  Future socialLoginVerificationGoogle(String loginType, googleId) async {
    try {
      SocialLoginGoogleData socialLoginGoogleData =
          await UserBackendAuthService().socialLoginVerificationGoogle(
              loginType: loginType, googleId: googleId);

      // Navigator.pop(context);
      // Utils.showSnackBar( 'PIN Reset',
      //      'Reset link sent to your registered Email');
      return socialLoginGoogleData;
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar(
            'We can\'t sent Reset PIN link', 'Please try again later');
      }
    }
  }

  // Future userPIN(User userData , String token) async {
  //   try {
  //     await UserBackendAuthService().userPIN(userData, token);
  //     Utils.showSnackBar( 'Welcome ${user.value.firstName} !',);
  //   } catch (e) {
  //     if (e is AppException) {
  //       Utils.showSnackBar( 'Error Occured',  e.message);
  //     } else {
  //       Utils.showSnackBar( 'We can\'t login!',
  //            'Please try again later');
  //     }
  //   }
  // }
  static AddNewChatMessageController addNewChatMessageController =
      Get.put(AddNewChatMessageController());
  static GetSortedChatListDoctor getSortedChatListDoctor =
      GetSortedChatListDoctor();
  static PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  static final DoctorHomeScreenController _doctorHomeScreenController =
      Get.find<DoctorHomeScreenController>();

  final GetCitiesViewModel getCitiesViewModel = Get.put(GetCitiesViewModel());
  final GetStatesViewModel getStatesViewModel = Get.put(GetStatesViewModel());
  String stateID = '';

  getStateCityData() async {
    await getStatesViewModel.getStatesViewModel();
    List<GetStatesResponseModel> data =
        getStatesViewModel.getStatesApiResponse.data;
    for (var element in data) {
      if (element.id.toString() == user.value.state.toString()) {
        user.value.stateName = element.name?.toLowerCase().capitalizeFirst;
        stateID = element.id!;
      }
    }
    await getCitiesViewModel.getCitiesViewModel(stateId: stateID);
    List<GetCityResponseModel> data1 =
        getCitiesViewModel.getCitiesApiResponse.data;
    for (var e1 in data1) {
      if (e1.id.toString() == user.value.city.toString()) {
        user.value.cityName = e1.name?.toLowerCase().capitalizeFirst;
      }
    }
  }

  Future<User> userLogin(LogInType logInType, String userType, String email,
      password, bearerToken, secretPin, BuildContext context) async {
    try {
      isCheck = true;
      user.value = await UserBackendAuthService().login(
        logInType,
        email: email,
        userType: userType,
        bearerToken: bearerToken,
        password: password,
      );

      getStateCityData();

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
                  user.value.medicalCenterID.toString()) {
                user.value.medicalCenterName = element['post_title'];
              }
            },
          );
        }
      }

      update();
      Prefs.setString(Prefs.BEARER, bearerToken);
      Prefs.setString(Prefs.EMAIL, email);
      await Prefs.setString(Prefs.profileImage,
          user.value.profilePic ?? user.value.socialProfilePic!);
      Prefs.setString(Prefs.SOCIALID, "${user.value.id}");
      Prefs.setString(Prefs.PASSWORD, password);
      Prefs.setString(Prefs.USERTYPE, userType);
      Prefs.setString(Prefs.USERTYPE, userType);
      Prefs.setString(Prefs.IsAdmin, "${user.value.isAdmin}");
      Prefs.setString(Prefs.SecretPin, secretPin);
      log("PREFERENCE IsAdmin ${Prefs.getString(Prefs.IsAdmin)}");
      log("Prefs.getBool(Prefs.DARKTHEME, def: false) ${Prefs.getBool(Prefs.DARKTHEME, def: false)}");

      Get.changeTheme(Prefs.getBool(Prefs.DARKTHEME, def: false)
          ? Themes().isDark
          : Themes().isLight);
      if (userType == "1") {
        if (isPinScreen.value == true) {
          if (isScreenName.value == 'patientAppointment') {
            Get.offAllNamed(Routes.home);
            await Get.to(const MyAppointmentsPage());
            isPinScreen.value = false;
          } else if (isScreenName.value == 'patientAppointmentPrescription') {
            Get.offAllNamed(Routes.home);
            await Get.to(PrescriptionPage(
              appointmentId: notificationValue.value,
            ));
            isPinScreen.value = false;
          } else if (isScreenName.value == 'zoomMeeting') {
            Get.offAllNamed(Routes.home);
            await Get.to(const PatientNotificationPage());
            isPinScreen.value = false;
          } else if (isScreenName.value == 'doctorChat') {
            List<SortedPatientChat> patientChat = <SortedPatientChat>[];
            await patientHomeScreenController.getSortedPatientChatList().then(
              (value) {
                for (var element in patientHomeScreenController.newDataList) {
                  if (notificationValue.value == element.doctorId.toString()) {
                    patientChat.add(element);
                  }
                }
              },
            ).then(
              (value) async {
                patientHomeScreenController.chatKey.value =
                    patientChat[0].chatKey ?? "";
                patientHomeScreenController.doctorName.value =
                    patientChat[0].doctorFirstName ?? "";
                patientHomeScreenController.doctorLastName.value =
                    patientChat[0].doctorLastName ?? "";
                patientHomeScreenController.doctorId.value =
                    patientChat[0].doctorId ?? "";
                patientHomeScreenController.toId.value =
                    patientChat[0].doctorId ?? "";

                patientHomeScreenController.doctorProfile =
                    patientChat[0].doctorProfilePic ?? '';
                patientHomeScreenController.doctorSocialProfile =
                    patientChat[0].doctorSocialProfilePic ?? '';

                patientHomeScreenController
                    .getAllPatientChatMessages.value.patientChatList
                    ?.clear();

                patientHomeScreenController.getAllPatientChatMessagesList(
                    patientChat[0].chatKey ?? "");
                Get.offAllNamed(Routes.home);

                await Get.to(
                  MessagesDetailPage(
                    sortedPatientChat: patientChat[0],
                  ),
                );
                isPinScreen.value = false;
              },
            );
          } else if (isScreenName.value == '') {
            Get.offAllNamed(Routes.home);
          }
          isPinScreen.value = false;
        } else {
          Get.offAllNamed(Routes.home2);
          isPinScreen.value = false;
        }
      } else {
        // final RoundedLoadingButtonController _btnController =
        //     new RoundedLoadingButtonController();
        // Get.offAllNamed(Routes.home2);
        if (isPinScreen.value == true) {
          if (isScreenName.value == 'doctorAppointment') {
            Get.offAllNamed(
              Routes.home2,
            );
            await Get.to(
              const MyAppointmentsDoctor(),
            );
            isPinScreen.value = false;
          } else if (isScreenName.value == 'patientChat') {
            List<ShortedDoctorChat> doctorChat = <ShortedDoctorChat>[];
            await addNewChatMessageController
                .getSortedChatListDoctor(
              doctorId: user.value.id,
            )
                .then(
              (value) {
                getSortedChatListDoctor = addNewChatMessageController
                    .getDoctorSortedChatListApiResponse.data;

                getSortedChatListDoctor.doctorChatList?.forEach(
                  (element) {
                    if (notificationValue.value ==
                        element.patientId.toString()) {
                      doctorChat.add(element);
                    }
                  },
                );
              },
            ).then(
              (value) async {
                _doctorHomeScreenController.doctorChat.value = doctorChat[0];
                Get.offAllNamed(
                  Routes.home2,
                );
                await Get.to(const DoctorMessagesDetailPage());
                isPinScreen.value = false;
              },
            );
          } else if (isScreenName.value == '') {
            Get.offAllNamed(
              Routes.home2,
            );
            isPinScreen.value = false;
          }
          isPinScreen.value = false;
        } else {
          Get.offAllNamed(Routes.home2);

          isPinScreen.value = false;
        }
      }
    } catch (e) {
      if (e is AppException) {
        if (e.message == "You are not Active, Please connect with Admin.") {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.clear,
                              color: Colors.black, size: 28),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 45),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Please connect with Admin",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Your application has been submitted for admin verification. Please wait until your application is verified. For faster verification, email us at satawaretechnologies@gmail.com",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(Get.width, 40),
                                ),
                                child: const Text(
                                  "Okay",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          Utils.showSnackBar('Login failed', e.message);
        }

        isCheck = false;
        update();
      } else {
        isCheck = false;
        update();
      }
    }
    return user.value;
  }

  Future changePIN(String userId, requestId, bearerToken) async {
    try {
      await UserBackendAuthService().changePIN(userId, requestId, bearerToken);
      // if(userType == "1"){
      //   Get.toNamed(Routes.home);
      // }else{
      //   Get.toNamed(Routes.home2);
      // }
      Utils.showSnackBar('PIN Reset Successfully!',
          'PIN Reset Process has been added to the queue. Data manipulation will take approximately 30 minutes to complete.');
      Get.offAndToNamed(Routes.login);
    } catch (e) {
      if (e is AppException) {
        Utils.showSnackBar('Error Occurred', e.message);
      } else {
        Utils.showSnackBar(
            'We can\'t Change your Secure PIN', 'Please try again later');
      }
    }
  }

  void updateUserData(
    User updateUser,
    String profilePic,
    height,
    weight,
    emergencyContact,
    currentCaseManager,
    certificate,
    education,
    speciality,
    perAppointmentCharge,
    state,
    city,
  ) {
    user.value = updateUser;
    user.value.profilePic = profilePic;
    user.value.height = height;
    user.value.weight = weight;
    user.value.emergencyContact = emergencyContact;
    user.value.currentCaseManagerInfo = currentCaseManager;
    user.value.certificateNo = certificate;
    user.value.education = education;
    user.value.speciality = speciality;
    user.value.perAppointmentCharge = perAppointmentCharge;
    user.value.state = state;
    user.value.city = city;
  }
}
