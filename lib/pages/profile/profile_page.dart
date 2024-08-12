import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/round_icon_button.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/doctorprofile/widgets/profile_info_tile.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = Get.find();
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
              body: Obx(
                () => SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        //color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Utils().patientProfile(
                                _userController.user.value.profilePic ?? '',
                                _userController.user.value.socialProfilePic ??
                                    '',
                                40),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${_userController.user.value.firstName ?? ""} ${_userController.user.value.lastName ?? ""}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(fontSize: 22),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      _userController.user.value.email ?? "",
                                      style: TextStyle(
                                        color: Colors.grey[350],
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      _userController
                                              .user.value.contactNumber ??
                                          '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            RoundIconButton(
                              onPressed: () async =>
                                  await Get.toNamed(Routes.editProfile)
                                      ?.then((value) async {
                                setState(() {});
                              }),
                              icon: Icons.edit,
                              size: 50,
                              color: kColorBlue,
                              iconColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Divider(
                        height: 0.5,
                        color: Colors.grey[200],
                        indent: 15,
                        endIndent: 15,
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('gender'),
                        trailing: _userController.user.value.gender,
                        hint: Translate.of(context)?.translate('add_gender'),
                      ),
                      ProfileInfoTile(
                        title:
                            Translate.of(context)?.translate('date_of_birth'),
                        trailing: _userController.user.value.dateOfBirth,
                        hint: 'yyyy mm dd',
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('blood_group'),
                        trailing: _userController.user.value.bloodGroup!.isEmpty
                            ? "   -   "
                            : _userController.user.value.bloodGroup,
                        hint:
                            Translate.of(context)?.translate('add_blood_group'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('Allergies'),
                        trailing: _userController.user.value.allergies!.isEmpty
                            ? "   -   "
                            : _userController.user.value.allergies,
                        hint: Translate.of(context)?.translate('Allergies'),
                      ),
                      ProfileInfoTile(
                        title:
                            Translate.of(context)?.translate('marital_status'),
                        trailing:
                            _userController.user.value.maritalStatus!.isEmpty
                                ? "   -   "
                                : _userController.user.value.maritalStatus,
                        hint: Translate.of(context)
                            ?.translate('add_marital_status'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('height'),
                        trailing: _userController.user.value.height!.isEmpty
                            ? "   -   "
                            : _userController.user.value.height,
                        hint: Translate.of(context)?.translate('add_height'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('weight'),
                        trailing: _userController.user.value.weight!.isEmpty
                            ? "   -   "
                            : _userController.user.value.weight,
                        hint: Translate.of(context)?.translate('add_weight'),
                      ),
                      ProfileInfoTile(
                        title: 'Emergency contact',
                        trailing:
                            _userController.user.value.emergencyContact!.isEmpty
                                ? "   -   "
                                : _userController.user.value.emergencyContact,
                        hint: 'Add emergency contact',
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)
                            ?.translate('Current case manager info'),
                        trailing: _userController
                                .user.value.currentCaseManagerInfo!.isEmpty
                            ? "   -   "
                            : _userController.user.value.currentCaseManagerInfo,
                        hint:
                            Translate.of(context)?.translate('+1 52139784672'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)
                            ?.translate('Insurance Eligibility'),
                        trailing:
                            _userController.user.value.insuranceEligibility,
                        hint: Translate.of(context)?.translate('yes'),
                      ),
                      if (_userController.user.value.insuranceEligibility
                              ?.toLowerCase() ==
                          "yes")
                        ProfileInfoTile(
                          title: Translate.of(context)
                              ?.translate('State the name of your insurance'),
                          trailing: _userController
                                  .user.value.insuranceCompanyName!.isEmpty
                              ? "   -   "
                              : _userController.user.value.insuranceCompanyName,
                          hint: Translate.of(context)?.translate(''),
                        ),
                      ProfileInfoTile(
                        title: Translate.of(context)
                            ?.translate('Are you a US Veteran?'),
                        trailing: _userController.user.value.usVeteranStatus,
                        hint: Translate.of(context)?.translate('yes'),
                      ),
                      ProfileInfoTile(
                        title:
                            Translate.of(context)?.translate('Tribal Status'),
                        trailing: _userController.user.value.tribalStatus,
                        hint: Translate.of(context)?.translate('No'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)
                            ?.translate('Federally Enrolled Tribal Member?'),
                        trailing: _userController
                                .user.value.tribalFederallyMember!.isEmpty
                            ? "No"
                            : "Yes",
                        hint: Translate.of(context)?.translate('yes'),
                      ),
                      if (_userController
                          .user.value.tribalFederallyMember!.isNotEmpty)
                        ProfileInfoTile(
                          title: Translate.of(context)
                              ?.translate('Tribal affiliation'),
                          trailing:
                              _userController.user.value.tribalFederallyMember,
                          hint: Translate.of(context)
                              ?.translate('Tribal affiliation'),
                        ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate(
                            'Are you enrolled in a State Recognized Tribe?'),
                        trailing: _userController
                                .user.value.tribalFederallyState!.isEmpty
                            ? "No"
                            : "Yes",
                        hint: Translate.of(context)?.translate('yes'),
                      ),
                      if (_userController
                          .user.value.tribalFederallyState!.isNotEmpty)
                        ProfileInfoTile(
                          title: Translate.of(context)
                              ?.translate('Tribal affiliation'),
                          trailing:
                              _userController.user.value.tribalFederallyState,
                          hint: Translate.of(context)
                              ?.translate('Tribal affiliation'),
                        ),
                      ProfileInfoTile(
                        title: Translate.of(context)
                            ?.translate('Racial/ethnic background '),
                        trailing:
                            _userController.user.value.tribalBackgroundStatus,
                        hint: Translate.of(context)?.translate('yes'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('State'),
                        trailing: _userController.user.value.stateName,
                        hint: Translate.of(context)?.translate('Alabama'),
                      ),
                      ProfileInfoTile(
                        title: Translate.of(context)?.translate('city'),
                        trailing: _userController.user.value.cityName,
                        hint: Translate.of(context)?.translate('ADAK'),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// OLD CODE

/*import 'dart:math';

import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/round_icon_button.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/data/pref_manager.dart';
import 'package:united_natives/pages/prescription/patient_profile_prescription_tab_page.dart';
import 'package:united_natives/pages/splash_page.dart';
import 'package:united_natives/pages/visit/visit_page.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
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
  doctorProfile() {
    String doctorImagePath;
    return doctorImagePath;
  }

  final _kTabPages = [
    VisitPage(),
    PatientProfilePrescriptionTabPage(),
  ];

  bool _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  var _kTabs = [
    Tab(
      text: 'Visit',
    ),
    Tab(
      text: 'Prescription',
    ),
  ];

  Utils utils = Utils();
  final UserController _userController = Get.find();

  AdsController adsController = Get.find();

  @override
  Widget build(BuildContext context) {
    

    super.build(context);
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
                        return utils.patientProfile(
                            _userController.user?.value?.profilePic ?? '',
                            _userController.user?.value?.socialProfilePic ?? '',
                            40);
                      }),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Obx(
                              () => Column(
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
                                  color: Colors.grey[350],
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${_userController.user.value.contactNumber ?? '-'}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      RoundIconButton(
                        onPressed: () => Get.toNamed(Routes.editProfile),
                        icon: Icons.edit,
                        size: 50,
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
                            // color: _isDark ? Colors.white : Colors.white,
                            border: Border(
                              top: BorderSide(
                                width: 1,
                                color:
                                _isDark ? Colors.black87 : Colors.grey[200],
                              ),
                              bottom: BorderSide(
                                width: 1,
                                color:
                                _isDark ? Colors.black87 : Colors.grey[200],
                              ),
                            ),
                          ),
                          child: TabBar(
                            indicatorColor: kColorBlue,
                            labelStyle: _kTabTextStyle,
                            unselectedLabelStyle: _kUnselectedTabTextStyle,
                            labelColor: kColorBlue,
                            unselectedLabelColor: Colors.grey,
                            tabs: _kTabs,
                          ),
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
        //       child: _patientHomeScreenController.isLoading.value
        //           ? ProgressIndicatorScreen()
        //           : Container()),
        // ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}*/
