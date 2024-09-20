import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:intl/intl.dart';
import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/round_icon_button.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/profile/widgets/profile_info_tile.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart' as utils;
import 'package:united_natives/viewModel/ads_controller.dart';
import 'package:united_natives/viewModel/user_controller.dart';

class DocProfilePage extends StatefulWidget {
  const DocProfilePage({super.key});

  @override
  State<DocProfilePage> createState() => _DocProfilePageState();
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: <Widget>[
                          Obx(
                            () {
                              return utils.Utils().patientProfile(
                                  _userController.user.value.profilePic ?? '',
                                  _userController.user.value.socialProfilePic ??
                                      '',
                                  40);
                            },
                          ),
                          const SizedBox(
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
                                      .titleSmall
                                      ?.copyWith(fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  _userController.user.value.email ?? "",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _userController.user.value.contactNumber ??
                                      "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 0.5,
                      color: Colors.grey[200],
                      indent: 15,
                      endIndent: 15,
                    ),
                    ProfileInfoTile(
                        title:
                            Translate.of(context)!.translate('Date of Birth'),
                        trailing: "${_userController.user.value.dateOfBirth}"
                                .isEmpty
                            ? "   -   "
                            : DateFormat('EEEE, dd MMMM, yyyy').format(
                                DateTime.parse(
                                    _userController.user.value.dateOfBirth ??
                                        DateTime.now().toString()))),
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('gender'),
                      trailing: Translate.of(context)!.translate(
                          "${_userController.user.value.gender}".isEmpty
                              ? "   -   "
                              : _userController.user.value.gender.toString()),
                    ),
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('License No.'),
                      trailing:
                          "${_userController.user.value.certificateNo}".isEmpty
                              ? "   -   "
                              : _userController.user.value.certificateNo,
                    ),
                    ProfileInfoTile(
                      title: 'Per Appointment Charge',
                      trailing:
                          "${_userController.user.value.perAppointmentCharge}"
                                  .isEmpty
                              ? "0"
                              : _userController.user.value.perAppointmentCharge,
                    ),
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('Speciality'),
                      trailing:
                          "${_userController.user.value.speciality}".isEmpty
                              ? "   -   "
                              : _userController.user.value.speciality,
                    ),
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('Education'),
                      trailing:
                          "${_userController.user.value.education}".isEmpty
                              ? "   -   "
                              : _userController.user.value.education,
                    ),
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('Provider Type'),
                      trailing:
                          "${_userController.user.value.providerType}".isEmpty
                              ? "   -   "
                              : _userController.user.value.providerType,
                    ),
                    ProfileInfoTile(
                      title:
                          Translate.of(context)!.translate('Ethnic Background'),
                      trailing:
                          "${_userController.user.value.tribalBackgroundStatus}"
                                  .isEmpty
                              ? "   -   "
                              : _userController
                                  .user.value.tribalBackgroundStatus,
                    ),
                    if (_userController.user.value.tribalBackgroundStatus ==
                            "Native American" ||
                        _userController.user.value.tribalBackgroundStatus ==
                            'Alaska Native') ...[
                      ProfileInfoTile(
                        title: Translate.of(context)!.translate(
                            'Enrolled in a federally recognized tribe'),
                        trailing:
                            "${_userController.user.value.federallyRecognizedTribe}"
                                    .isEmpty
                                ? "   -   "
                                : _userController
                                    .user.value.federallyRecognizedTribe,
                      ),
                      if (_userController.user.value.federallyRecognizedTribe ==
                          "Yes")
                        ProfileInfoTile(
                          title: Translate.of(context)!.translate(
                              'Tribal affiliation are you enrolled in'),
                          trailing:
                              "${_userController.user.value.tribal_affiliation_enrolled}"
                                      .isEmpty
                                  ? "   -   "
                                  : _userController
                                      .user.value.tribal_affiliation_enrolled,
                        )
                      else
                        ProfileInfoTile(
                          title: Translate.of(context)!.translate(
                              'Tribal descendancy do you affiliate with'),
                          trailing:
                              "${_userController.user.value.tribal_descendancy_affiliate}"
                                      .isEmpty
                                  ? "   -   "
                                  : _userController
                                      .user.value.tribal_descendancy_affiliate,
                        ),
                    ],
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('State'),
                      trailing:
                          "${_userController.user.value.stateName}".isEmpty
                              ? "   -   "
                              : _userController.user.value.stateName,
                    ),
                    ProfileInfoTile(
                      title: Translate.of(context)!.translate('City'),
                      trailing: "${_userController.user.value.cityName}".isEmpty
                          ? "   -   "
                          : _userController.user.value.cityName,
                    ),
                    ProfileInfoTile(
                        title:
                            Translate.of(context)!.translate('Medical Center'),
                        trailing:
                            "${_userController.user.value.medicalCenterName}"
                                    .isEmpty
                                ? "   -   "
                                : _userController.user.value.medicalCenterName),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  bool get wantKeepAlive => true;
}
