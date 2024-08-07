import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/components/round_icon_button.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/medicle_center/lib/utils/translate.dart';
import 'package:doctor_appointment_booking/pages/profile/widgets/profile_info_tile.dart';
import 'package:doctor_appointment_booking/routes/routes.dart';
import 'package:doctor_appointment_booking/utils/constants.dart';
import 'package:doctor_appointment_booking/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class DocProfilePage extends StatefulWidget {
  @override
  _DocProfilePageState createState() => _DocProfilePageState();
}

class _DocProfilePageState extends State<DocProfilePage> {
  final UserController _userController = Get.find<UserController>();

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GetBuilder<AdsController>(
          builder: (ads) {
            return Scaffold(
              bottomNavigationBar: AdsBottomBar(
                ads: ads,
                context: context,
              ),
              body: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Obx(
                          () {
                            return utils.Utils().patientProfile(
                                _userController.user?.value?.profilePic ?? '',
                                _userController.user?.value?.socialProfilePic ??
                                    '',
                                40);
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${_userController.user.value.firstName ?? ""} ${_userController.user.value.lastName ?? ""}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontSize: 22),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                '${_userController.user.value.email ?? ""}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${_userController.user.value.contactNumber ?? ""}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                      fontSize: 18,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        RoundIconButton(
                          onPressed: () async => await Navigator.of(context)
                              .pushNamed(Routes.doceditprofile)
                              .then((value) => setState(() {})),
                          icon: Icons.edit,
                          size: 50,
                          color: kColorBlue,
                          iconColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 0.5,
                    color: Colors.grey[200],
                    indent: 15,
                    endIndent: 15,
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('Date of Birth'),
                    trailing:
                        '${_userController.user.value.dateOfBirth ?? "Date of Birth"}',
                    hint: Translate.of(context).translate('Date of Birth'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('gender'),
                    trailing: Translate.of(context).translate(
                        '${_userController.user.value.gender.toString() ?? "Enter Gender"}'),
                    hint: Translate.of(context).translate('add_gender'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('Certificate No.'),
                    trailing:
                        '${_userController.user.value.certificateNo ?? "Enter Certificate Number"}',
                    hint: Translate.of(context)
                        .translate('Enter your license no.'),
                  ),
                  ProfileInfoTile(
                    title: 'Per Appointment Charge',
                    trailing:
                        '${_userController.user.value.perAppointmentCharge ?? "Enter Per Appointment Charge"}',
                    hint: '\$100',
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('Speciality'),
                    trailing:
                        '${_userController.user.value.speciality ?? "Enter Speciality"}',
                    hint: Translate.of(context).translate('add Speciality'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('Education'),
                    trailing:
                        '${_userController.user.value.education ?? "Enter Education"}',
                    hint: Translate.of(context).translate('add Education'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('Provider Type'),
                    trailing:
                        '${_userController.user.value.providerType ?? "Enter Provider Type"}',
                    hint:
                        Translate.of(context).translate('Enter Provider Type'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('State'),
                    trailing:
                        '${_userController.user.value.stateName ?? "Alaska"}',
                    hint: Translate.of(context).translate('State'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('City'),
                    trailing:
                        '${_userController.user.value.cityName ?? "Akhiok"}',
                    hint: Translate.of(context).translate('City'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context).translate('Medical Center'),
                    trailing:
                        '${_userController.user.value.medicalCenterName ?? "United Natives"}',
                    hint: Translate.of(context).translate('Medical Center'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  bool get wantKeepAlive => true;
}

/// OLD CODE

/*import 'dart:math';
import 'package:doctor_appointment_booking/components/ads_bottom_bar.dart';
import 'package:doctor_appointment_booking/controller/ads_controller.dart';
import 'package:doctor_appointment_booking/controller/user_controller.dart';
import 'package:doctor_appointment_booking/pages/prescription/doctor_profile_prescription_tab_page.dart';
import 'package:doctor_appointment_booking/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import '../../components/round_icon_button.dart';
import '../../data/pref_manager.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../patientvisit/visit_page.dart';
import '../splash_page.dart';

class DocProfilePage extends StatefulWidget {
  @override
  _DocProfilePageState createState() => _DocProfilePageState();
}

class _DocProfilePageState extends State<DocProfilePage> {
  final UserController _userController = Get.find<UserController>();
  bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  final _kTabTextStyle = TextStyle(
    color: kColorBlue,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const _kUnselectedTabTextStyle = TextStyle(
    color: Colors.grey,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  final List<Widget> _kTabPages = [
    PatientVisitPage(),
    DoctorProfilePrescriptionTabPage(),
  ];

  AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    

    print('Enter profile');
    // super.build(context);

    var _kTabs = [
      Tab(
        text: 'Visit',
      ),
      Tab(
        text: 'Prescription',
      ),
    ];

    return Stack(
      children: <Widget>[
        GetBuilder<AdsController>(builder: (ads) {
          return Scaffold(
            bottomNavigationBar: AdsBottomBar(
              ads: ads,

              context: context,

            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  //color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Obx(() {
                        return utils.Utils().patientProfile(
                            _userController.user?.value?.profilePic ?? '',
                            _userController.user?.value?.socialProfilePic ?? '',
                            40);
                      }),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${_userController.user.value.firstName ?? ""} ${_userController.user.value.lastName ?? ""}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontSize: 22),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              '${_userController.user.value.email ?? ""}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${_userController.user.value.contactNumber ?? ""}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      RoundIconButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(Routes.doceditprofile),
                        icon: Icons.edit,
                        size: 40,
                        color: kColorBlue,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: DefaultTabController(
                    length: _kTabs.length,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            // color: _isdark ? Colors.white : Colors.white,
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color:
                                _isdark ? Colors.black87 : Colors.grey[200],
                              ),
                              bottom: BorderSide(
                                width: 1,
                                color:
                                _isdark ? Colors.black87 : Colors.grey[200],
                              ),
                            ),
                          ),
                          child: TabBar(
                              indicatorColor: kColorBlue,
                              labelStyle: _kTabTextStyle,
                              unselectedLabelStyle: _kUnselectedTabTextStyle,
                              labelColor: kColorBlue,
                              unselectedLabelColor: Colors.grey,
                              tabs: _kTabs),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: _kTabPages,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
        // Obx(
        //       () => Container(
        //       child: _doctorHomeScreenController.isLoading.value
        //           ? ProgressIndicatorScreen()
        //           : Container()),
        // ),
      ],
    );
  }

  bool get wantKeepAlive => true;
}*/
