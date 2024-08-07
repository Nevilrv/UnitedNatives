// import 'package:doctor_appointment_booking/controller/user_controller.dart';
// import 'package:doctor_appointment_booking/data/pref_manager.dart';
// import 'package:doctor_appointment_booking/model/login_verification.dart';
// import 'package:doctor_appointment_booking/model/user.dart';
// import 'package:doctor_appointment_booking/pages/contact.dart';
// import 'package:doctor_appointment_booking/pages/home/home.dart';
// import 'package:doctor_appointment_booking/utils/utils.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide User;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart' hide Trans;
//
//
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
//
// import '../../components/custom_button.dart';
// import '../../components/custom_icons.dart';
// import '../../components/text_form_field.dart';
// import '../../routes/routes.dart';
// import '../../utils/constants.dart';
//
// class LoginPageA extends StatefulWidget {
//   @override
//   _LoginPageAState createState() => _LoginPageAState();
// }
//
// class _LoginPageAState extends State<LoginPageA> {
//   // LocalAuthentication _auth = LocalAuthentication();
//   bool _checkBio = false;
//   bool _isBioFinger = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   UserController _userController = Get.put<UserController>(UserController());
//
//   UserCredential authResult;
//
//   final RoundedLoadingButtonController _btnController =
//   new RoundedLoadingButtonController();
//
//   @override
//   void initState() {
//     super.initState();
//     // _checkBiometrics();
//     // _listBioAndFindFingerType();
//     // _startAuth();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       key: _scaffoldKey,
//       body: LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints viewportConstraints) {
//           return SingleChildScrollView(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 minHeight: viewportConstraints.maxHeight,
//               ),
//               child: IntrinsicHeight(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 38),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Expanded(
//                         child: SizedBox(
//                           height: 80,
//                         ),
//                       ),
//                       Row(children: [
//                         Text(
//                           'sign_in'.tr(),
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         // Expanded(child: SizedBox()),
//                         // IconButton(
//                         //   icon: Icon(
//                         //     Icons.fingerprint,
//                         //     size: 80,
//                         //   ),
//                         //   onPressed: _startAuth,
//                         //   iconSize: 100,
//                         // ),
//                       ]),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       WidgetSignIn(
//                         scaffoldKey: _scaffoldKey,
//                       ),
//                       Center(
//                         child: FlatButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushNamed(Routes.forgotPassword);
//                           },
//                           child: Text(
//                             'forgot_yout_password'.tr(),
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .button
//                                 .copyWith(fontSize: 16),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: Divider(
//                               color: Colors.grey,
//                               endIndent: 20,
//                             ),
//                           ),
//                           Text(
//                             'social_login'.tr(),
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .subtitle2
//                                 .copyWith(fontSize: 16),
//                           ),
//                           Expanded(
//                             child: Divider(
//                               color: Colors.grey,
//                               indent: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Center(
//                         child: Container(
//                           width: 45,
//                           height: 45,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(colors: [
//                               Color(0xffff4f38),
//                               Color(0xff1ff355d),
//                             ], tileMode: TileMode.clamp),
//                           ),
//                           child: RoundedLoadingButton(
//                               color: Colors.red,
//                               valueColor: Colors.white,
//                               successColor: Colors.red,
//                               child: Icon(
//                                 CustomIcons.googlePlus,
//                                 color: Colors.white,
//                               ),
//                               controller: _btnController,
//                               onPressed: () async {
//                                 _userController.authResult =
//                                 await _userController.socialUserRegister();
//
//                                 setState(() {
//                                   if (_userController.authResult != null) {
//                                     _btnController.success();
//                                   }
//                                   _btnController.reset();
//                                 });
//                                 // Get.toNamed(Routes.phoneAuthScreen4);
//                                 // print("Email===>${authResult.user.email}");
//                                 if (_userController.authResult == null) {
//                                   Navigator.pop(context);
//                                 } else {
//                                   Get.toNamed(Routes.phoneAuthScreen5);
//                                   Utils.showSnackBar(
//                                       title:
//                                       "${_userController.authResult?.user?.email} successfully login! ",
//                                       message: "Enter your Secret PIN");
//                                 }
//                               }),
//                           // RoundedLoadingButton(
//                           //   child:
//                           // ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             width: 99,
//                             height: 99,
//                             padding: EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.white,
//                             ),
//                             child: CircleAvatar(
//                               backgroundColor: Colors.transparent,
//                               child: Image.asset(
//                                 'assets/images/indegenous2.png',
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       CustomButton(
//                           textSize: 22,
//                           onPressed:
//                               () => /*_onAlertWithCustomContentPressed(context), */
//                           Navigator.of(context).popAndPushNamed(
//                               Routes.doctorlogin), //Doctor login path
//                           text: 'I am a Doctor'.tr()),
//                       SafeArea(
//                         child: Center(
//                           child: Wrap(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: Text(
//                                   'dont_have_an_account'.tr(),
//                                   style: TextStyle(
//                                     color: Color(0xffbcbcbc),
//                                     fontSize: 16,
//                                     fontFamily: 'NunitoSans',
//                                   ),
//                                 ),
//                               ),
//                               InkWell(
//                                 borderRadius: BorderRadius.circular(2),
//                                 onTap: () {
//                                   Navigator.of(context)
//                                       .pushNamed(Routes.signup);
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(5),
//                                   child: Text(
//                                     'register_now'.tr(),
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .button
//                                         .copyWith(fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   _autoLogin() async {
//     // await Prefs.getString(Prefs.PASSWORD);
//     // await Prefs.getString(Prefs.EMAIL);
//     await Prefs.load();
//     // context.bloc<ThemeBloc>().add(ThemeChanged(
//     //     theme: Prefs.getBool(Prefs.DARKTHEME, def: false)
//     //         ? AppTheme.DarkTheme
//     //         : AppTheme.LightTheme));
//     Navigator.of(context).pushReplacementNamed(Routes.phoneAuthScreen2);
//     Utils.showSnackBar(
//         title: '${Config.getEmail()} successfully login!',
//         message: 'Enter your secret PIN to Continue');
//   }
//
// // void _checkBiometrics() async {
// //   try {
// //     final bio = await _auth.canCheckBiometrics;
// //     setState(() {
// //       _checkBio = bio;
// //     });
// //     print('Biometrics = $_checkBio');
// //   } catch (e) {}
// // }
// //
// // void _listBioAndFindFingerType() async {
// //   List<BiometricType> _listType;
// //   try {
// //     _listType = await _auth.getAvailableBiometrics();
// //   } on PlatformException catch (e) {
// //     print(e.message);
// //   }
// //   print('List Biometrics = $_listType');
// //
// //   if (_listType.contains(BiometricType.fingerprint)) {
// //     setState(() {
// //       _isBioFinger = true;
// //     });
// //     print('Fingerprint is $_isBioFinger');
// //   }
// // }
//
// /* void _startAuth() async {
//     bool _isAuthenticated=false;
//     try {
//       _isAuthenticated = await _auth.authenticateWithBiometrics(
//         localizedReason: 'Scan Your Fingerprint',
//         useErrorDialogs: true,
//         stickyAuth: true,
//         //androidAuthStrings: null,
//         //iOSAuthStrings: null
//       );
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//     if (_isAuthenticated) {
//       print("_isAuthenticated ===>");
//       // _autoLogin();
//       Get.offAndToNamed(Home.routeName);
//       // Navigator.pushReplacement(
//       //     context, MaterialPageRoute(builder: (c) => Home()));
//     }
//   }*/
// }
//
// class WidgetSignIn extends StatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;
//
//   WidgetSignIn({this.scaffoldKey});
//
//   @override
//   _WidgetSignInState createState() => _WidgetSignInState();
// }
//
// class _WidgetSignInState extends State<WidgetSignIn> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//
//   final UserController _userController = Get.find();
//   LoginVerificationData loginVerificationData = LoginVerificationData();
//   GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   FocusNode focusNode = FocusNode();
//   var currentFocus;
//   unFocus() {
//     currentFocus = FocusScope.of(context);
//
//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//   }
//
//   @override
//   void initState() {
//     _emailController.text;
//     _passwordController.text;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             'email_dot'.tr(),
//             style: kInputTextStyle.copyWith(fontSize: 22),
//           ),
//           CustomTextFormField(
//             textInputAction: TextInputAction.next,
//             validator: (text) {
//               if (text.isEmpty) {
//                 setState(() {
//                   isLoading = false;
//                 });
//                 return 'Please Enter Your Email';
//               }
//               return null;
//             },
//             controller: _emailController,
//             hintText: 'contact@sataware.com',
//             // validator: (text) {
//             //   if (text.isEmpty) {
//             //     return 'Enter Email';
//             //   }
//             //   return null;
//             // },
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             'password_dot'.tr(),
//             style: kInputTextStyle.copyWith(fontSize: 22),
//           ),
//           CustomTextFormField(
//             focusNode: focusNode,
//             textInputAction: TextInputAction.done,
//             controller: _passwordController,
//             hintText: '* * * * * *',
//             obscureText: true,
//             validator: (text) {
//               if (text.isEmpty) {
//                 setState(() {
//                   isLoading = false;
//                 });
//                 return 'Please Enter Your Password';
//               }
//               return null;
//             },
//           ),
//           SizedBox(
//             height: 35,
//           ),
//           isLoading
//               ? Center(
//             child: CircularProgressIndicator(
//               strokeWidth: 1,
//             ),
//           )
//               : CustomButton(
//             textSize: 22,
//             // onPressed: () async {
//             //   await _userController.userLogin(LogInType.NORMAL,1,
//             //       _emailController.text,
//             //       _passwordController.text,"");
//             // },
//             onPressed: () async {
//               unFocus();
//               setState(() {
//                 isLoading = true;
//               });
//               // await _userController.statusPIN(_userController.loginData.id);
//               if (_formKey.currentState.validate()) {
//                 _userController.loginData = User(
//                     email: _emailController.text,
//                     password: _passwordController.text,
//                     userType: "1");
//                 LoginVerification  res=  await _userController.loginVerification(
//                     _userController.loginData.email,
//                     _userController.loginData.password);
//                 print("RES  >>>> ${res.status}");
//                 if(res.status=='Success'){
//
//                   // get.testmode=true
//                   // Get.to(FlutterContactsExample());
//                   // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { return FlutterContactsExample(); }));
//                   Get.toNamed(Routes.phoneAuthScreen2, arguments:  true);
//                   // Navigator.pop(context);
//                   // Utils.showSnackBar(
//                   //     title:
//                   //     '${res.loginVerificationData.email} Successfully Login!',
//                   //     message: 'Enter Your Secret PIN to continue...');
//                 }
//
//                 setState(() {
//                   isLoading = false;
//                 });
//                 // await Navigator.pushNamed(context, Routes.phoneAuthScreen);
//
//                 // await _userController.userRegister(userData, 1,
//                 //     useProfilePic: _image);
//               }
//             },
//             text: 'login'.tr(),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// _onAlertWithCustomContentPressed(context) {
//   Alert(
//       context: context,
//       image: Image(
//         image: AssetImage('assets/images/Doctor.gif'),
//       ),
//       title: "Coming Soon",
//       content: Column(
//         children: <Widget>[],
//       ),
//       buttons: [
//         DialogButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             "Okay",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         )
//       ]).show();
// }
