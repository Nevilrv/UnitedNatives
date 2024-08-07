// import 'dart:convert';
//
// import 'package:crypto/crypto.dart';
// import 'package:doctor_appointment_booking/controller/user_controller.dart';
// import 'package:doctor_appointment_booking/data/pref_manager.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/blocs/app_bloc.dart';
// import 'package:doctor_appointment_booking/model/login_verification.dart';
// import 'package:doctor_appointment_booking/model/social_login_google_verification.dart';
// import 'package:doctor_appointment_booking/newModel/apiModel/requestModel/add_chat_status_request_model.dart';
// import 'package:doctor_appointment_booking/newModel/apis/api_response.dart';
// import 'package:doctor_appointment_booking/routes/routes.dart';
// import 'package:doctor_appointment_booking/utils/constants.dart';
// import 'package:doctor_appointment_booking/utils/time.dart';
// import 'package:doctor_appointment_booking/utils/utils.dart';
// import 'package:doctor_appointment_booking/viewModel/log_out_view_model.dart';
// import 'package:flutter/material.dart' hide Key;
// import 'package:get/get.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
//
// class PhoneVerification7 extends StatefulWidget {
//   @override
//   _PhoneVerification7State createState() => _PhoneVerification7State();
// }
//
// class _PhoneVerification7State extends State<PhoneVerification7> {
//   String userType1 = "1";
//   var appBarHeight = 0.0;
//   var otpController = new TextEditingController();
//   bool _btnEnabled = false;
//
//   // get userType => UserController().user.value.userType;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   UserController _userController = Get.put(UserController());
//   LoginVerificationData loginVerificationData = LoginVerificationData();
//   SocialLoginGoogleData socialLoginGoogleData = SocialLoginGoogleData();
//   final RoundedLoadingButtonController _btnController =
//       new RoundedLoadingButtonController();
//   FocusNode focusNode = FocusNode();
//   var currentFocus;
//
//   unFocus() {
//     currentFocus = FocusScope.of(context);
//
//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//   }
//
//   LogOutController logOutController = Get.put(LogOutController());
//
//   Future<void> addChatOnlineStatus({bool type}) async {
//     AddChatOnlineStatusReqModel model = AddChatOnlineStatusReqModel();
//     model.isOnline = type;
//     model.lastSeen = DateTime.now().toString();
//     await logOutController.addChatStatus(model: model);
//     if (logOutController.addChatStatusApiResponse.status == Status.COMPLETE) {
//       print('COMPLETE>>>>>>>>>>');
//     } else if (logOutController.addChatStatusApiResponse.status ==
//         Status.ERROR) {
//       print('ERROR');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     appBarHeight = AppBar().preferredSize.height;
//     return Scaffold(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         body: Stack(children: <Widget>[
//           Container(
//             color: kColorPrimary,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 14, left: 14),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: appBarHeight,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.1,
//                 ),
//                 Text(
//                   'Enter Your Secret PIN',
//                   style: Theme.of(context).textTheme.headline4.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                 ),
//                 SizedBox(
//                   height: 6,
//                 ),
//                 Text(
//                   ('Enter your secret pin here'),
//                   style: Theme.of(context).textTheme.subtitle2.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 32, right: 32),
//                   child: Stack(
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(top: 0),
//                         child: getOtpTextUI(otptxt: otpController.text),
//                       ),
//                       Opacity(
//                         opacity: 0.0,
//                         child: Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   border: Border.all(
//                                     color: Theme.of(context).dividerColor,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 16),
//                                   child: Form(
//                                     key: _formKey,
//                                     child: Row(
//                                       children: <Widget>[
//                                         Expanded(
//                                           child: TextFormField(
//                                             focusNode: focusNode,
//                                             textInputAction:
//                                                 TextInputAction.done,
//                                             controller: otpController,
//                                             maxLength: 4,
//                                             onChanged: (String txt) {
//                                               if (txt.length == 4) {
//                                                 setState(() {
//                                                   _btnEnabled = true;
//                                                 });
//                                               } else {
//                                                 setState(() {
//                                                   _btnEnabled = false;
//                                                 });
//                                               }
//                                             },
//                                             onTap: () {},
//                                             style: TextStyle(
//                                               color: Theme.of(context)
//                                                   .primaryColor,
//                                               fontSize: 18,
//                                             ),
//                                             decoration: new InputDecoration(
//                                                 // errorText: validatePassword(
//                                                 //     otpController.text),
//
//                                                 border: InputBorder.none,
//                                                 labelStyle: TextStyle(
//                                                   color: Theme.of(context)
//                                                       .primaryColor,
//                                                 ),
//                                                 counterText: ""),
//                                             keyboardType: TextInputType.number,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 32, left: 32),
//                   child: RoundedLoadingButton(
//                     color: Colors.white,
//                     valueColor: kColorBlue,
//                     successColor: Colors.white,
//                     child: _btnEnabled == true
//                         ? Text('PROCEED',
//                             style: TextStyle(
//                                 color: kColorBlue, fontWeight: FontWeight.bold))
//                         : Text('Enter Secure PIN to Proceed',
//                             style: TextStyle(
//                                 color: kColorBlue,
//                                 fontWeight: FontWeight.bold)),
//                     controller: _btnController,
//                     onPressed: _btnEnabled == true
//                         ? () async {
//                             unFocus();
//                             final userPIN = '${otpController.text}';
//                             print('USERPIN:$userPIN');
//                             final encryptedUtf = utf8.encode(userPIN);
//                             print('UTF8:$encryptedUtf');
//                             final encryptedPIN = md5.convert(encryptedUtf);
//                             print('MD5PIN: $encryptedPIN');
//                             if (_formKey.currentState.validate()) {
//                               await _userController.socialLogin(
//                                 "google",
//                                 _userController.authResult?.user?.uid ??
//                                     Config.getSocialID(),
//                                 _userController.authResult?.user?.displayName
//                                         ?.split(" ")
//                                         ?.first ??
//                                     '',
//                                 _userController.authResult?.user?.displayName
//                                         ?.split(" ")
//                                         ?.reversed
//                                         ?.first ??
//                                     "",
//                                 "Male",
//                                 _userController.authResult?.user?.email ??
//                                     Config.getEmail(),
//                                 "12345678",
//                                 "2",
//                                 encryptedPIN.toString(),
//                                 _userController.authResult?.user?.photoURL ??
//                                     Config.getProfileImage() ??
//                                     "",
//                               );
//                               _btnController.stop();
//                               _btnController.reset();
//                             }
//                           }
//                         : null,
//                   ),
//                 ),
//                 SizedBox(height: 23),
//                 Center(
//                   child: InkWell(
//                     highlightColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     onTap: () async {
//                       socialLoginGoogleData =
//                           await _userController.socialLoginVerificationGoogle(
//                               "google", _userController.authResult.user.uid);
//
//                       await _userController.resetPIN(
//                           socialLoginGoogleData.id, "2");
//                     },
//                     child: Text(
//                       ('Reset PIN'),
//                       style: Theme.of(context).textTheme.button.copyWith(
//                           fontSize: 23,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 18,
//                 ),
//                 Center(
//                   child: InkWell(
//                     highlightColor: Colors.transparent,
//                     splashColor: Colors.transparent,
//                     onTap: () async {
//                       if (_userController.loginData?.userType == "1") {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: const Text('Are you sure want to logout?'),
//                               actions: <Widget>[
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('Cancel')),
//                                 TextButton(
//                                   onPressed: () async {
//                                     _userController.user.value.id = null;
//                                     await addChatOnlineStatus(type: false);
//                                     if (_userController.authResult != null) {
//                                       await logOutController
//                                           .doctorLogOut()
//                                           .then(
//                                         (value) {
//                                           _userController.signOut();
//                                           Prefs.clear();
//                                           AppBloc.loginCubit.onLogout();
//                                           Navigator.of(context)
//                                               .pushNamedAndRemoveUntil(
//                                                   Routes.doctorlogin,
//                                                   (Route<dynamic> route) =>
//                                                       false);
//
//                                           TimerChange.timer.cancel();
//                                         },
//                                       );
//                                     } else {
//                                       setState(() {
//                                         AppBloc.loginCubit.onLogout();
//                                       });
//
//                                       await logOutController
//                                           .doctorLogOut()
//                                           .then((value) async {
//                                         Prefs.clear();
//                                         // Get.reset();
//                                         // Get.offAndToNamed(Routes.doctorlogin);
//                                         Navigator.of(context)
//                                             .pushNamedAndRemoveUntil(
//                                                 Routes.doctorlogin,
//                                                 (Route<dynamic> route) =>
//                                                     false);
//                                       });
//                                     }
//                                   },
//                                   child: const Text(
//                                     'Log out',
//                                     style: TextStyle(color: Colors.red),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } else {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: const Text('Are you sure want to logout?'),
//                               actions: <Widget>[
//                                 TextButton(
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                     child: const Text('Cancel')),
//                                 TextButton(
//                                     onPressed: () async {
//                                       setState(() {
//                                         AppBloc.loginCubit.onLogout();
//                                       });
//
//                                       if (_userController.authResult != null) {
//                                         logOutController
//                                             .patientLogOut()
//                                             .then((value) {
//                                           _userController.signOut();
//                                           addChatOnlineStatus(type: false);
//                                           Prefs.clear();
//                                           Navigator.pushNamedAndRemoveUntil(
//                                               context,
//                                               Routes.login,
//                                               (route) => false);
//                                           TimerChange.timer.cancel();
//                                         });
//                                       } else {
//                                         setState(() {
//                                           AppBloc.loginCubit.onLogout();
//                                         });
//
//                                         logOutController
//                                             .patientLogOut()
//                                             .then((value) {
//                                           Prefs.clear();
//                                           addChatOnlineStatus(type: false);
//                                           print('^^^^^^');
//
//                                           print(
//                                               'LOGOUT EMAIL:${Config.getEmail()}');
//                                           // Get.reset();
//                                           Navigator.pushNamedAndRemoveUntil(
//                                               context,
//                                               Routes.login,
//                                               (route) => false);
//                                           // _showInterstitialAd();
//
//                                           // Get.offAll(Routes.login);
//                                         });
//                                       }
//                                     },
//                                     child: const Text(
//                                       'Log out',
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                       ),
//                                     )),
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     },
//                     child: Text(
//                       ('Logout'),
//                       style: Theme.of(context).textTheme.button.copyWith(
//                           fontSize: 23,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ]));
//   }
//
//   Widget getOtpTextUI({String otptxt = ""}) {
//     List<Widget> otpList = <Widget>[];
//     Widget getUI({String otxt = ""}) {
//       return Expanded(
//         child: Column(
//           children: <Widget>[
//             SizedBox(
//               height: 12,
//             ),
//             Text(
//               otxt,
//               style: Theme.of(context).textTheme.headline5.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).textTheme.headline6.color,
//                   ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 height: 2.5,
//                 width: 50,
//                 color: Theme.of(context).dividerColor,
//               ),
//             )
//           ],
//         ),
//       );
//     }
//
//     for (var i = 0; i < 4; i++) {
//       otpList.add(getUI(otxt: otptxt.length > i ? otptxt[i] : ""));
//     }
//     return Row(
//       children: otpList,
//     );
//   }
// }
