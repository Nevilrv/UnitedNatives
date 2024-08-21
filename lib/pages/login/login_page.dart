// import 'dart:async';
// import 'dart:math';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:doctor_appointment_booking/controller/ads_controller.dart';
// import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
// import 'package:doctor_appointment_booking/sevices/app_notification.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../components/custom_button.dart';
// import '../../components/custom_icons.dart';
// import '../../components/social_icon.dart';
// import '../../components/text_form_field.dart';
// import '../../routes/routes.dart';
// import '../../utils/constants.dart';
// import '../splash_page.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   String fcmToken;
//
//   @override
//   void initState() {
//
//     getFcm();
//     print('ABC........');
//     super.initState();
//   }
//
//   Future getFcm() async {
//     fcmToken = await AppNotificationHandler.getFcmToken();
//     print('FCMTOKEN$fcmToken');
//   }
//
//   AdsController adsController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GetBuilder<AdsController>(builder: (ads) {
//       return Scaffold(
//         bottomNavigationBar: AdsBottomBar(
//         ads: ads,
//
//         context: context,
//
//         ),
//         body: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints viewportConstraints) {
//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints:
//                     BoxConstraints(minHeight: viewportConstraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 38),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Expanded(
//                           child: SizedBox(height: 80),
//                         ),
//                         Text(
//                           Translate.of(context).translate('sign_in'),
//                           style: TextStyle(
//                               fontSize: 30, fontWeight: FontWeight.w700),
//                         ),
//                         SizedBox(height: 30),
//                         WidgetSignin(),
//                         Center(
//                           child: FlatButton(
//                             onPressed: () {
//                               Navigator.of(context)
//                                   .pushNamed(Routes.forgotPassword);
//                             },
//                             child: Text(
//                               Translate.of(context)
//                                   .translate('forgot_yout_password'),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .button
//                                   .copyWith(fontSize: 14),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Divider(color: Colors.grey, endIndent: 20),
//                             ),
//                             Text(
//                               Translate.of(context).translate('social_login'),
//                               style: Theme.of(context).textTheme.subtitle2,
//                             ),
//                             Expanded(
//                               child: Divider(color: Colors.grey, indent: 20),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             SocialIcon(
//                               colors: [
//                                 Color(0xff102397),
//                                 Color(0xff187adf),
//                               ],
//                               iconData: CustomIcons.facebook,
//                               onPressed: () {},
//                             ),
//                             SocialIcon(
//                               colors: [
//                                 Color(0xffff4f38),
//                                 Color(0xff1ff355d),
//                               ],
//                               iconData: CustomIcons.googlePlus,
//                               onPressed: () {},
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               width: 99,
//                               height: 99,
//                               padding: EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle, color: Colors.white),
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.transparent,
//                                 child: Image.asset(
//                                     'assets/images/icon_doctor_0.png',
//                                     fit: BoxFit.fill),
//                               ),
//                             ),
//                           ],
//                         ),
//                         CustomButton(
//                           textSize: 24,
//                           onPressed:
//                               () => /*_onAlertWithCustomContentPressed(context), */
//                                   Navigator.of(context).popAndPushNamed(
//                                       Routes.doctorlogin), //Doctor login path
//                           text: Translate.of(context)
//                               .translate('i_am_a_provider'),
//                         ),
//                         SafeArea(
//                           child: Center(
//                             child: Wrap(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(5),
//                                   child: Text(
//                                     Translate.of(context)
//                                         .translate('dont_have_an_account'),
//                                     style: TextStyle(
//                                         color: Color(0xffbcbcbc),
//                                         fontSize: 14,
//                                         fontFamily: 'NunitoSans'),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   borderRadius: BorderRadius.circular(2),
//                                   onTap: () {
//                                     Navigator.of(context)
//                                         .pushNamed(Routes.signup);
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Text(
//                                       Translate.of(context)
//                                           .translate('register_now'),
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .button
//                                           .copyWith(fontSize: 14),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 10)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     });
//   }
// }
//
// class WidgetSignin extends StatefulWidget {
//   @override
//   _WidgetSigninState createState() => _WidgetSigninState();
// }
//
// class _WidgetSigninState extends State<WidgetSignin> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
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
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           Translate.of(context).translate('email_dot'),
//           style: kInputTextStyle,
//         ),
//         CustomTextFormField(
//             controller: _emailController, hintText: 'contact@sataware.com'),
//         SizedBox(
//           height: 20,
//         ),
//         Text(Translate.of(context).translate('password_dot'),
//             style: kInputTextStyle),
//         CustomTextFormField(
//             focusNode: focusNode,
//             controller: _passwordController,
//             hintText: '* * * * * *',
//             obscureText: true),
//         SizedBox(
//           height: 35,
//         ),
//         CustomButton(
//           textSize: 24,
//           onPressed: () async {
//             unFocus();
//             Navigator.of(context).popAndPushNamed(Routes.home);
//           },
//           text: Translate.of(context).translate('login'),
//         )
//       ],
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
//             style: TextStyle(color: Colors.white, fontSize: 22),
//           ),
//         )
//       ]).show();
// }
