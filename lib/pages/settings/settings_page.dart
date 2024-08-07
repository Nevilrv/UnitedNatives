import 'dart:convert';

import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/theme_controlller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/data/pref_manager.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/viewModel/rate_and%20_contactus_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  // var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  RateContactUsController rateContactUsController =
      Get.put(RateContactUsController());

  ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    print('USERTYPE${Prefs.getString(Prefs.USERTYPE)}');
    getRate();
    themeController.color = themeController.isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.grey[200];
  }

  getRate() async {
    String url =
        '${Constants.baseUrl + Constants.patientRating}/${_userController.user.value.id}';
    String url1 =
        '${Constants.baseUrl + Constants.doctorRating}/${_userController.user.value.id}';

    Map<String, String> header1 = {
      "Authorization": 'Bearer ${Prefs.getString(Prefs.BEARER)}',
    };
    http.Response response1 = await http.get(
        Uri.parse(Prefs.getString(Prefs.USERTYPE) == '1' ? url : url1),
        headers: header1);
    print('RESPONSE MEET ENDED${response1.body}');
    var data = jsonDecode(response1.body);

    if (data["status"] == 'Fail') {
      print("<<<<<<<<");
      rateContactUsController.setRate(rate1: '0');
    } else {
      print('rating ${data["data"]['rating']}');
      rateContactUsController.setRate(rate1: '${data["data"]['rating']}');
    }
    print(data["status"]);
  }

  AdsController adsController = Get.find();
  UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<AdsController>(builder: (ads) {
      return Scaffold(
        bottomNavigationBar: AdsBottomBar(
          ads: ads,
          context: context,
        ),
        backgroundColor: themeController.isDark
            ? Colors.white.withOpacity(0.12)
            : Colors.grey[200],
        body: GetBuilder<ThemeController>(
          builder: (controller) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Material(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GeneralWidget(
                    isDark: controller.isDark,
                    onDarkPressed: (darkTheme) {
                      controller.updateTheme(darkTheme);
                      setState(() {});
                      /*print('darkTheme---------->>>>>>>>$darkTheme');
                          setState(
                            () {
                              controller.isDark = darkTheme;
                              Prefs.setBool(Prefs.DARKTHEME, darkTheme);
                              Get.changeTheme(
                                  darkTheme ? Themes().isDark : Themes().isLight);
                              _color = controller.isDark
                                  ? Colors.white.withOpacity(0.12)
                                  : Colors.grey[200];
                              // BlocProvider.of<ThemeBloc>(context).add(
                              //   ThemeChanged(
                              //       theme: darkTheme
                              //           ? AppTheme.DarkTheme
                              //           : AppTheme.LightTheme),
                              // );
                            },
                          );*/
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
