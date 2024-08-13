import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/model/login_verification.dart';
import 'package:united_natives/model/patient_update_data.dart';
import 'package:united_natives/model/pin_status_model.dart';
import 'package:united_natives/model/reset_pin_model.dart';
import 'package:united_natives/model/social_login_google_verification.dart';
import 'package:united_natives/model/specialities_model.dart';
import 'package:united_natives/model/user.dart';
import 'package:united_natives/utils/app_enum.dart';
import 'package:united_natives/utils/exception.dart';
import 'package:united_natives/utils/network_util.dart';
import 'package:united_natives/utils/utils.dart';

import '../utils/constants.dart';

class UserBackendAuthService {
  static final UserBackendAuthService _authService =
      UserBackendAuthService._init();
  // final UserController _userController = Get.find();

  factory UserBackendAuthService() {
    return _authService;
  }

  UserBackendAuthService._init();

  final NetworkAPICall _networkAPICall = NetworkAPICall();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const bannerToken = '43b2fe6fb2cd47eb049520a9f5d94905';
  Map<String, String> headers = {
    "Authorization": 'Bearer 43b2fe6fb2cd47eb049520a9f5d94905',
    "Content-Type": 'application/x-www-form-urlencoded',
  };

  Map<String, String> headersDoctor = {
    "Authorization": 'Bearer 130c470359db8bdef071522cb0c733b8',
    "Content-Type": 'application/x-www-form-urlencoded',
  };

  // Map<String, String> headersPIN = {
  //   "Authorization": 'Bearer $token',
  //   "Content-Type": 'application/x-www-form-urlencoded',
  // };

  Future<SpecialitiesModel> specialitiesModelDropDown() async {
    SpecialitiesModel specialitiesModelData = SpecialitiesModel();

    try {
      var result =
          await _networkAPICall.get(Constants.getSpecialities, header: headers);

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

  Future<User> login(
    LogInType loginType, {
    required String email,
    password,
    required String userType,
    required String bearerToken,
  }) async {
    try {
      User userData = User();
      if (loginType == LogInType.FACEBOOK) {
      } else if (loginType == LogInType.GOOGLE) {
      } else if (loginType == LogInType.NORMAL) {
        userData = await _normalLogin(
            email: email,
            password: password,
            userType: userType,
            bearerToken: bearerToken);
        Prefs.getString(bearerToken);
      }

      return userData;
    } catch (e) {
      throw AppException.exceptionHandler(e);
    }
  }

  User userData = User();

  Future<User> _normalLogin(
      {required String email,
      password,
      required String userType,
      required String bearerToken}) async {
    var body = jsonEncode({
      "email": email,
      "password": "$password",
      'device_token': Prefs.getString(Prefs.FcmToken)
    });

    log('body=====1111111=====>>>>>${body}');

    Map<String, String> loginHeaders = {
      "Authorization": 'Bearer $bearerToken',
      "Content-Type": 'application/x-www-form-urlencoded',
    };

    try {
      if (userType == "1") {
        var result = await _networkAPICall.post(Constants.patientLogin, body,
            header: loginHeaders);

        log('result==========>>>>>${result}');

        if (result['status'] == 'Success') {
          userData = User.fromJson(result['data']);
        } else {
          userData = User();
        }
      } else if (userType == "2") {
        var result = await _networkAPICall.post(Constants.doctorLogIn, body,
            header: loginHeaders);
        if (result['status'] == 'Success') {
          userData = User.fromJson(result['data']);
        } else {
          userData = User();
        }
      }

      // await AppPreference().saveCustomerData(customerData);
      return userData;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future register(User userData, String userType, String bearerToken,
      {required File profilePic}) async {
    try {
      Map<String, String> body = {
        'first_name': userData.firstName ?? "",
        'last_name': userData.lastName ?? "",
        'gender': userData.gender ?? "",
        'email': userData.email ?? "",
        'contact_number': userData.contactNumber ?? "",
        'date_of_birth': userData.dateOfBirth ?? "",
        'blood_group': userData.bloodGroup ?? "",
        'allergies': userData.allergies ?? "",
        'marital_status': userData.maritalStatus ?? "",
        'insurance_eligibility': userData.insuranceEligibility ?? "",
        'medical_insurance_name': userData.insuranceCompanyName ?? "",
        'us_veteran_status': userData.usVeteranStatus ?? "",
        'tribal_status': userData.tribalStatus ?? "",
        'tribal_federally_member': userData.tribalFederallyMember ?? "",
        'tribal_federally_state': userData.tribalFederallyState ?? "",
        'tribal_background_status': userData.tribalBackgroundStatus ?? "",
        'how_did_you_hear_about_us': userData.howDidYouHearAboutUs ?? "",
        'password': userData.password ?? "",
        'emergency_contact': userData.emergencyContact ?? "",
        'state': userData.state ?? "",
        'city': userData.city ?? "",
        "height": userData.height ?? "",
        "weight": userData.weight ?? "",
        "emergency_contact_number": userData.emergencyContact ?? "",
        "case_manager": userData.currentCaseManagerInfo ?? "",

        // 'is_IH_user': userData.isIhUser,
        //'is_admin':userData.isAdmin
        // 'is_native_american':userData.isNativeAmerican,
      };

      log('body-----HELLO----->>>>>>>>$body');

      log('body==========>>>>>${jsonEncode(body)}');

      Map<String, String> bodyDoctor = {
        'first_name': userData.firstName ?? "",
        'last_name': userData.lastName ?? "",
        'gender': userData.gender ?? "",
        'email': userData.email ?? "",
        'password': userData.password ?? "",
        'per_appointment_rate': userData.perAppointmentCharge ?? "",
        'contact_number': userData.contactNumber ?? "",
        'date_of_birth': userData.dateOfBirth ?? "",
        'speciality': userData.speciality ?? "",
        'certificate_no': userData.certificateNo ?? "",
        'education': userData.education ?? "",
        'state': userData.state ?? "",
        'city': userData.city ?? "",
        'is_IH_user': userData.isIhUser ?? "",
        "medical_center_id": userData.medicalCenterID ?? "",
        'provider_type': userData.providerType ?? "",
        // 'is_admin':userData.isAdmin
        // 'is_native_american':userData.isNativeAmerican,
      };

      log('bodyDoctor==========>>>>>$bodyDoctor');

      Map<String, String> registerHeaders = {
        "Authorization": 'Bearer $bearerToken',
        "Content-Type": 'application/x-www-form-urlencoded',
      };

      try {
        if (userType == "1") {
          var userData = await _networkAPICall.multipartRequestPost(
              Constants.patientSignUp, body,
              image1: profilePic,
              image1Key: 'profilePic',
              header: registerHeaders);

          log('userData==========>>>>>$userData');
        } else {
          await _networkAPICall.multipartRequestPost(
              Constants.doctorSignUp, bodyDoctor,
              image1: profilePic,
              image1Key: 'profilePic',
              header: registerHeaders);
        }
      } catch (e, stackStrace) {
        throw AppException.exceptionHandler(e, stackStrace);
      }
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future socialRegister(
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
      {required File useProfilePic}) async {
    try {
      Map<String, String> body = {
        'first_name': userData.firstName ?? "",
        'last_name': userData.lastName ?? "",
        'gender': userData.gender ?? "",
        'email': userData.email ?? "",
        'password': userData.password ?? "",
        'blood_group': userData.bloodGroup ?? "",
        'marital_status': userData.maritalStatus ?? "",
        'emergency_contact': userData.emergencyContact ?? "",
        'insurance_eligibility': userData.insuranceEligibility ?? "",
        'tribal_status': userData.tribalStatus ?? "",
      };
      Map<String, String> bodyDoctor = {
        'first_name': userData.firstName ?? "",
        'last_name': userData.lastName ?? "",
        'gender': userData.gender ?? "",
        'email': userData.email ?? "",
        'password': userData.password ?? "",
        'per_appointment_rate': userData.perAppointmentCharge ?? "",
      };
      Map<String, String> registerHeaders = {
        "Authorization": 'Bearer $bearerToken',
        "Content-Type": 'application/x-www-form-urlencoded',
      };

      try {
        if (userType == "1") {
          var userData = await _networkAPICall.multipartRequestPost(
              Constants.patientSignUp, body,
              image1: useProfilePic,
              image1Key: 'profilePic',
              header: registerHeaders);

          log('userData==========>>>>>$userData');
        } else {
          await _networkAPICall.multipartRequestPost(
              Constants.doctorSignUp, bodyDoctor,
              image1: useProfilePic,
              image1Key: 'profilePic',
              header: registerHeaders);
        }
      } catch (e, stackStrace) {
        throw AppException.exceptionHandler(e, stackStrace);
      }
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future<User> socialLogin(String loginType, id, firstName, lastName, gender,
      email, password, userType, bearerToken, socialProfilePic) async {
    var googleBody = {
      "login_type": loginType,
      "google_id": id,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "email": email,
      "password": password,
      "social_profile_pic": socialProfilePic
    };
    Map<String, String> registerHeaders = {
      "Authorization": 'Bearer $bearerToken',
      'Content-Type': 'application/json',
    };

    log('registerHeaders==========>>>>>$registerHeaders');
    log('googleBody==========>>>>>$googleBody');
    // try {
    //   print('patient====>$userType');
    //   if (userType == "1") {
    //     await _networkAPICall.post(
    //         Constants.socialLogin, googleBody,
    //         header: registerHeaders);
    //   } else {
    //     await _networkAPICall.post(
    //         Constants.socialLogin, googleBody,
    //         header: registerHeaders);
    //   }
    //   print("Try to calling =====> $userType");
    // } catch (e, stackStrace) {
    //   throw AppException.exceptionHandler(e, stackStrace);
    // }
    try {
      if (userType == "1") {
        var result = await _networkAPICall.post(
            Constants.socialLogin, json.encode(googleBody),
            header: registerHeaders);
        if (result['status'] == 'Success') {
          userData = User.fromJson(result['data']);
        } else {
          userData = User();
        }
      } else if (userType == "2") {
        var result = await _networkAPICall.post(
            Constants.doctorSocialLogin, json.encode(googleBody),
            header: registerHeaders);
        if (result['status'] == 'Success') {
          userData = User.fromJson(result['data']);
        } else {
          userData = User();
        }
        return userData;
      }
    } catch (e, stackStrace) {
      log('e====e====e=>>>>>$e');

      throw AppException.exceptionHandler(e, stackStrace);
    }
    return userData;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Future forgotPassword(
    User userData,
  ) async {
    try {
      var body = jsonEncode({"email_id": userData.email});

      try {
        await _networkAPICall.post(Constants.forgotPassword, body,
            header: Config.getHeaders());
      } catch (e, stackStrace) {
        throw AppException.exceptionHandler(e, stackStrace);
      }
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future changePassword(
    String email,
  ) async {
    try {
      var body = jsonEncode({"email_id": email});
      log('body==========>>>>>$body');
      try {
        await _networkAPICall.post(Constants.forgotPassword, body,
            header: Config.getHeaders());
      } catch (e, stackStrace) {
        throw AppException.exceptionHandler(e, stackStrace);
      }
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future loginVerificationDetails(
      {required String email, required String password}) async {
    LoginVerificationData loginVerificationData = LoginVerificationData();
    var body = jsonEncode({"email": email, "password": password});

    try {
      var result = await _networkAPICall.post(Constants.loginVerification, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        loginVerificationData = LoginVerificationData.fromJson(result['data']);
      } else {
        loginVerificationData = LoginVerificationData();
      }
      return loginVerificationData;
    } catch (e, stackStrace) {
      // print("print4===>$dateTime");
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future loginVerification(
      {required String email, required String password}) async {
    LoginVerification loginVerification = LoginVerification();
    var body = jsonEncode({"email": email, "password": password});
    log('email==========>>>>>$email');
    try {
      var result = await _networkAPICall.post(Constants.loginVerification, body,
          header: Config.getHeaders());

      loginVerification = LoginVerification.fromJson(result);

      // if (result['status'] == 'Success') {
      //   if (result['data'] != "This email not exists") {
      //     loginVerification = LoginVerification.fromJson(result);
      //   } else {
      //     loginVerification =
      //         LoginVerification(message: "This email not exists");
      //   }
      // } else {
      //   loginVerification = null;
      //   print("Failed");
      // }
      return loginVerification;
    } catch (e, stackStrace) {
      // print("print4===>$dateTime");
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future socialLoginVerificationGoogle(
      {required String loginType, required String googleId}) async {
    SocialLoginGoogleData socialLoginGoogleData = SocialLoginGoogleData();
    var body = jsonEncode({"login_type": loginType, "google_id": googleId});
    log('Config.getHeaders()==========>>>>>${Config.getHeaders()}');
    try {
      var result = await _networkAPICall.post(
          Constants.socialLoginVerificationGoogle, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        socialLoginGoogleData = SocialLoginGoogleData.fromJson(result['data']);
      } else {
        socialLoginGoogleData = SocialLoginGoogleData();
      }
      return socialLoginGoogleData;
    } catch (e, stackStrace) {
      // print("print4===>$dateTime");
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future resetPIN(
    String userId,
  ) async {
    var body = jsonEncode({"user_id": userId});
    ResetPIN resetPINData;
    try {
      var result = await _networkAPICall.post(Constants.resetPIN, body,
          header: Config.getHeaders());
      if (result['status'] == 'Success') {
        resetPINData = ResetPIN.fromJson(result);
        return resetPINData;
      }
      return result;
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future<PINStatusModel> pinStatus(String userId) async {
    var body = jsonEncode({"user_id": userId});
    PINStatusModel pinStatusModelData;
    try {
      var result = await _networkAPICall.post(Constants.statusPIN, body,
          header: Config.getHeaders());
      // if (result['status'] == 'Success') {
      pinStatusModelData = PINStatusModel.fromJson(result);
      // print("pinStatus====>>>${pinStatusModelData.pinStatus.adminVerified}");
      // }
      return pinStatusModelData;
    } catch (e, stackStrace) {
      // print("print4===>$dateTime");
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future changePIN(String userId, requestId, bearerToken) async {
    try {
      var body = jsonEncode({"user_id": userId, "request_id": requestId});

      try {
        Map<String, String> getHeaders() {
          return {
            "Authorization": 'Bearer $bearerToken',
            "Content-Type": 'application/json',
          };
        }

        await _networkAPICall.post(Constants.changePIN, body,
            header: getHeaders());
        await Prefs.setString(Prefs.BEARER, bearerToken);
      } catch (e, stackStrace) {
        throw AppException.exceptionHandler(e, stackStrace);
      }
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // if (googleUser == null) {
    //   return;
    // }

    log('googleUser==========>>>>>$googleUser');

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    // var user = authResult.user;
    // Once signed in, return the UserCredential
    return authResult;
  }

  Future<PatientUpdateDataModel> userProfileUpdate(
      User userUpdateData, File profilePic, String userType) async {
    PatientUpdateDataModel patientUpdateDataModelData =
        PatientUpdateDataModel();
    try {
      Map<String, String> body = {
        "user_id": userUpdateData.id ?? "",
        "first_name": userUpdateData.firstName ?? "",
        "last_name": userUpdateData.lastName ?? "",
        "gender": userUpdateData.gender ?? "",
        "contact_number": userUpdateData.contactNumber ?? "",
        "dob": userUpdateData.dateOfBirth ?? "",
        "blood_group": userUpdateData.bloodGroup ?? "",
        "marital_status": userUpdateData.maritalStatus ?? "",
        "height": userUpdateData.height ?? "",
        "weight": userUpdateData.weight ?? "",
        "emergency_contact_number": userUpdateData.emergencyContact ?? "",
        "case_manager": userUpdateData.currentCaseManagerInfo ?? "",
        "insurance_eligibility": userUpdateData.insuranceEligibility ?? "",
        "tribal_status": userUpdateData.tribalStatus ?? "",
        "state": userUpdateData.stateId ?? "",
        "city": userUpdateData.cityId ?? "",
        'allergies': userUpdateData.allergies ?? "",
        'medical_insurance_name': userUpdateData.insuranceCompanyName ?? "",
        'us_veteran_status': userUpdateData.usVeteranStatus ?? "",
        'tribal_federally_member': userUpdateData.tribalFederallyMember ?? "",
        'tribal_federally_state': userUpdateData.tribalFederallyState ?? "",
        'tribal_background_status': userUpdateData.tribalBackgroundStatus ?? "",

        // "profile_pic": userUpdateData.profilePic,
      };

      log('body==========>>>>>${jsonEncode(body)}');

      Map<String, String> doctorBody = {
        "user_id": userUpdateData.id ?? "",
        "first_name": userUpdateData.firstName ?? "",
        "last_name": userUpdateData.lastName ?? "",
        "gender": userUpdateData.gender ?? "",
        "contact_number": userUpdateData.contactNumber ?? "",
        "certificate_no": userUpdateData.certificateNo ?? "",
        "speciality": userUpdateData.speciality ?? "",
        "education": userUpdateData.education ?? "",
        "per_appointment_rate": userUpdateData.perAppointmentCharge ?? "",
        "dob": userUpdateData.dateOfBirth ?? "",
        "state_id": userUpdateData.stateId ?? "",
        "city_id": userUpdateData.cityId ?? "",
        "medical_center_id": userUpdateData.medicalCenterID ?? "",
        "provider_type": userUpdateData.providerType ?? "",
      };
      if (userType == "1") {
        // PatientUpdateData patientUpdateData =
        var result = await _networkAPICall.multipartRequestPost(
            Constants.patientUpdateProfile, body,
            image1: profilePic,
            image1Key: 'profilePic',
            header: Config.getHeaders());

        log('result==========>>>>>$result');

        if (result['status'] == 'Success') {
          patientUpdateDataModelData = PatientUpdateDataModel.fromJson(result);

          log('patientUpdateDataModelData---------->>>>>>>>$result');
        } else {
          patientUpdateDataModelData = PatientUpdateDataModel();
        }
        return patientUpdateDataModelData;
      } else {
        var result = await _networkAPICall.multipartRequestPost(
          Constants.doctorUpdateProfile,
          doctorBody,
          image1: profilePic,
          image1Key: 'profilePic',
          header: Config.getHeaders(),
        );
        if (result['status'] == 'Success') {
          patientUpdateDataModelData = PatientUpdateDataModel.fromJson(result);
        } else {
          patientUpdateDataModelData = PatientUpdateDataModel();
        }
        return patientUpdateDataModelData;
      }
      // Get.find<UserController>().user.value = User(
      //   firstName: profileUpdateData.firstName,
      //   lastName: profileUpdateData.lastName,
      //   gender: profileUpdateData.gender,
      //   contactNumber: profileUpdateData.contactNumber,
      //   bloodGroup: profileUpdateData.bloodGroup,
      //   maritalStatus: profileUpdateData.maritalStatus,
      //   height: profileUpdateData.height,
      //   weight: profileUpdateData.weight,
      //   emergencyContact: profileUpdateData.emergencyContactNumber,
      //   currentCaseManagerInfo: profileUpdateData.currentCaseManager,
      //   insuranceEligibility: profileUpdateData.insuranceEligibility,
      //   tribalStatus: profileUpdateData.tribalStatus,
      //   speciality: profileUpdateData.speciality,
      //   education: profileUpdateData.education,
      //   dateOfBirth: profileUpdateData.dob,
      // );
    } catch (e, stackStrace) {
      throw AppException.exceptionHandler(e, stackStrace);
    }
  }

  // Future userPIN(User userData, String token) async {
  //   try {
  //     var body = jsonEncode({
  //       "user_id" : userData.id
  //     });
  //
  //     try {
  //       print("token==>$token");
  //      var response = await _networkAPICall.post(Constants.initiatePINReset, body,
  //           header:{'Authorization': 'Bearer $token', "Content-Type": 'application/x-www-form-urlencoded'});
  //      if (response.statusCode == 200){
  //         // var token = await getToken();
  //         // token = User.fromJson(json.decode(response.body)).id;
  //        UserBackendAuthService().setToken(token);
  //                 return User.fromJson(json.decode(response.body));
  //       } else {
  //             throw Exception('Failed auth');
  //           }
  //     } catch (e, stackStrace) {
  //       throw AppException.exceptionHandler(e, stackStrace);
  //     }
  //   } catch (e, stackStrace) {
  //     throw AppException.exceptionHandler(e, stackStrace);
  //   }
  // }

  // Future<String> setToken(String value) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('Bearer', value);
  // }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('Bearer');
  }
}
