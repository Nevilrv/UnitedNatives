import 'dart:convert';
import 'dart:developer';
import 'package:doctor_appointment_booking/controller/patient_homescreen_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart';
import 'package:doctor_appointment_booking/viewModel/rate_and%20_contactus_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../../routes/routes.dart';

class GeneralWidget extends StatefulWidget {
  final bool isDark;
  final Function onDarkPressed;

  GeneralWidget({Key key, this.isDark, this.onDarkPressed}) : super(key: key);

  @override
  _GeneralWidgetState createState() => _GeneralWidgetState();
}

class _GeneralWidgetState extends State<GeneralWidget> {
  var _darkTheme;
  UserController _userController = Get.find<UserController>();
  final PatientHomeScreenController patientHomeScreenController =
      Get.find<PatientHomeScreenController>();

  RateContactUsController rateContactUsController =
      Get.put(RateContactUsController());
  @override
  void initState() {
    super.initState();
    _darkTheme = widget.isDark;
  }

  final InAppReview _inAppReview = InAppReview.instance;

  String _appStoreId = '6483363927';

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: _appStoreId,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              color: _darkTheme
                  ? Colors.white.withOpacity(0.12)
                  : Colors.grey[200],
              padding: EdgeInsets.all(15),
              child: Text(
                Translate.of(context).translate('general'),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ListTile(
              leading: Text(
                Translate.of(context).translate('About United Natives'),
                // 'About United Native Health'.tr(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.aboutus);
              },
            ),
            ListTile(
              leading: Text(
                Translate.of(context).translate('privacy_policy'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.privacypolicy);
              },
            ),
            ListTile(
              leading: Text(
                Translate.of(context).translate('help_and_support'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.contact);
              },
            ),
            GetBuilder<RateContactUsController>(
              builder: (controller) {
                return ListTile(
                  leading: Text(
                    Translate.of(context).translate('Rate United Natives'),
                    // 'Rate United Native Health'.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    _openStoreListing();

                    // return showRatingDialog(context, controller);
                  },
                );
              },
            ),
            // ListTile(
            //   leading: Text(
            //     'notification_settings'.tr(),
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   trailing: Icon(
            //     Icons.chevron_right,
            //     color: Colors.grey,
            //   ),
            //   onTap: () {
            //     Get.to(FlutterContactsExample());
            //   }
            //       // Navigator.of(context).pushNamed(Routes.notificationSettings),
            // ), //*Notification Settings*
            ListTile(
                leading: Text(
                  Translate.of(context).translate('Change Password'),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  print('Change password');
                  _onAlertWithCustomContentPressed(
                      context,
                      () async => await _userController
                          .changePassword(_userController.user.value.email));
                }),
            SwitchListTile(
              value: _darkTheme,
              onChanged: (_) {
                setState(() {
                  _darkTheme = !_darkTheme;
                  widget.onDarkPressed(_darkTheme);
                });
              },
              title: Text(
                'Dark Theme',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            _userController.user.value.userType.toString() != "1"
                ? SizedBox()
                : ListTile(
                    leading: Text(
                      Translate.of(context).translate('Delete your account'),
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      print('Delete your account');

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Account'),
                            content: Text(
                                "Are you sure want to delete your account?"),
                            actions: <Widget>[
                              TextButton(
                                child: Text("YES"),
                                onPressed: () async {
                                  await patientHomeScreenController
                                      .deletePatientAccount(_userController
                                          .user.value.id
                                          .toString())
                                      .then((value) {
                                    Prefs.clear();

                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.login, (route) => false);
                                  });

                                  // if (patientHomeScreenController
                                  //         .deletePatientAccountData.value.status ==
                                  //     "Success") {
                                  //   Prefs.clear();
                                  //   return
                                  //       // Get.offAll(() => Routes.login);
                                  //       Navigator.pushNamedAndRemoveUntil(context,
                                  //           Routes.login, (route) => false);
                                  // } else {
                                  //   Utils.showSnackBar(
                                  //       title: 'Something went wrong',
                                  //       message:
                                  //           'Please try again after some time!');
                                  // }
                                },
                              ),
                              TextButton(
                                child: Text("NO"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
          ],
        ),
        GetBuilder<UserController>(builder: (controller) {
          return patientHomeScreenController.isLoading1.value == true ||
                  controller.changePasswordLoader
              ? Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.82,
                    color: Colors.black12.withOpacity(0.06),
                    child: Center(
                      child: Utils.circular(),
                    ),
                  ),
                )
              : SizedBox();
        })
      ],
    );
  }

  showRatingDialog(context, RateContactUsController controller) {
    // We use the built in showDialog function to show our Rating Dialog
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return controller.rate != '0'
              ? Center(
                  child: Container(
                    height: Get.height * 0.3,
                    width: Get.height * 0.3,
                    decoration: BoxDecoration(
                        color: _darkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.02),
                        _darkTheme
                            ? Image.asset(
                                'assets/images/neww_b_Logo.png',
                                height: 70,
                                width: 70,
                              )
                            : Image.asset(
                                'assets/images/neww_w_Logo.png',
                                height: 70,
                                width: 70,
                              ),
                        SizedBox(height: Get.height * 0.015),
                        Text(
                          // 'IH',
                          'United Natives',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Your rating',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: Get.height * 0.015),
                        // RatingBar.builder(
                        //   initialRating: d,
                        //   minRating: 3,
                        //   maxRating: 2,
                        //   direction: Axis.horizontal,
                        //   allowHalfRating: false,
                        //   itemCount: 5,
                        //   updateOnDrag: false,
                        //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        //   itemBuilder: (context, _) => Icon(
                        //     Icons.star,
                        //     color: Colors.blue,
                        //     size: Get.height * 0.03,
                        //   ),
                        //   onRatingUpdate: (rating) {
                        //     print(rating);
                        //   },
                        // )
                        SmoothStarRating(
                            allowHalfRating: false,
                            starCount: 5,
                            rating: double.parse('${controller.rate}.0'),
                            size: Get.height * 0.05,
                            isReadOnly: true,
                            color: Colors.blue,
                            borderColor: Colors.blue,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            spacing: .5),
                      ],
                    ),
                  ),
                )
              : RatingDialog(
                  initialRating: 0,

                  // your app's name?
                  image: _darkTheme
                      ? Image.asset('assets/images/neww_b_Logo.png',
                          height: 50, width: 50)
                      : Image.asset('assets/images/neww_w_Logo.png',
                          height: 50, width: 50),
                  title: Text(
                    // 'IH',
                    'United Natives',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                  // encourage your user to leave a high rating?
                  message: Text(
                    'Tap a star to set your rating',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17),
                  ),
                  // your app's logo?
                  enableComment: false,
                  submitButtonText: 'Submit',

                  onCancelled: () => print('cancelled'),
                  starColor: Colors.blue,
                  onSubmitted: (response) async {
                    String rate = response.rating.toString();
                    var rate1 = rate.split('.');
                    print(rate1.first);
                    String url =
                        '${Constants.baseUrl + Constants.patientRating}/${_userController.user.value.id}';
                    String url1 =
                        '${Constants.baseUrl + Constants.doctorRating}/${_userController.user.value.id}';
                    Map<String, dynamic> body1 = {
                      "rating": rate1.first,
                    };

                    Map<String, String> header1 = {
                      "Authorization":
                          'Bearer ${Prefs.getString(Prefs.BEARER)}',
                    };
                    http.Response response1 = await http.post(
                        Uri.parse(Prefs.getString(Prefs.USERTYPE) == '1'
                            ? url
                            : url1),
                        body: jsonEncode(body1),
                        headers: header1);
                    log('RESPONSE MEET ENDED${response1.body}');
                    var data = jsonDecode(response1.body);

                    if (data["status"] == 'Fail') {
                      // Get.back();
                    } else {
                      log('rating ${data["message"]}');
                      rateContactUsController.setRate(rate1: '${rate1.first}');
                    }
                    print(
                        'rating: ${response.rating}, comment: ${response.comment}');
                  },
                );
        });
  }
}

_onAlertWithCustomContentPressed(context, Function onPressed) {
  Alert(
    context: context,
    image: Image(
      image: AssetImage('assets/images/settings.gif'),
    ),
    // title: "Are you want to sure update password?",
    // title: "Are you sure you want to update the password?",
    title: "Are you sure want to update the password?",
    // content: Column(
    //   children: <Widget>[
    //     TextField(
    //       decoration: InputDecoration(
    //         icon: Icon(Icons.lock),
    //         labelText: 'New Password',
    //         labelStyle: TextStyle(color: Colors.black),
    //       ),
    //     ),
    //     TextField(
    //       obscureText: true,
    //       decoration: InputDecoration(
    //         icon: Icon(Icons.lock),
    //         labelText: 'Confirm Password',
    //         labelStyle: TextStyle(color: Colors.black),
    //       ),
    //     ),
    //   ],
    // ),
    buttons: [
      DialogButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          "No",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      DialogButton(
        onPressed: onPressed,
        child: Text(
          "Yes",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      )
    ],
  ).show();
}
