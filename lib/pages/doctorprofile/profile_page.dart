import 'package:united_natives/components/ads_bottom_bar.dart';
import 'package:united_natives/components/round_icon_button.dart';
import 'package:united_natives/controller/ads_controller.dart';
import 'package:united_natives/controller/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/pages/profile/widgets/profile_info_tile.dart';
import 'package:united_natives/routes/routes.dart';
import 'package:united_natives/utils/constants.dart';
import 'package:united_natives/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

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
              body: Column(
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
                                _userController.user.value.contactNumber ?? "",
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
                    title: Translate.of(context)!.translate('Date of Birth'),
                    trailing: _userController.user.value.dateOfBirth ??
                        "Date of Birth",
                    hint: Translate.of(context)!.translate('Date of Birth'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('gender'),
                    trailing: Translate.of(context)!.translate(
                        _userController.user.value.gender.toString()),
                    hint: Translate.of(context)!.translate('add_gender'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('Certificate No.'),
                    trailing: _userController.user.value.certificateNo ??
                        "Enter Certificate Number",
                    hint: Translate.of(context)!
                        .translate('Enter your license no.'),
                  ),
                  ProfileInfoTile(
                    title: 'Per Appointment Charge',
                    trailing: _userController.user.value.perAppointmentCharge ??
                        "Enter Per Appointment Charge",
                    hint: '\$100',
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('Speciality'),
                    trailing: _userController.user.value.speciality ??
                        "Enter Speciality",
                    hint: Translate.of(context)!.translate('add Speciality'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('Education'),
                    trailing: _userController.user.value.education ??
                        "Enter Education",
                    hint: Translate.of(context)!.translate('add Education'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('Provider Type'),
                    trailing: _userController.user.value.providerType ??
                        "Enter Provider Type",
                    hint:
                        Translate.of(context)!.translate('Enter Provider Type'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('State'),
                    trailing: _userController.user.value.stateName ?? "Alaska",
                    hint: Translate.of(context)!.translate('State'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('City'),
                    trailing: _userController.user.value.cityName ?? "Akhiok",
                    hint: Translate.of(context)!.translate('City'),
                  ),
                  ProfileInfoTile(
                    title: Translate.of(context)!.translate('Medical Center'),
                    trailing: _userController.user.value.medicalCenterName ??
                        "United Natives",
                    hint: Translate.of(context)!.translate('Medical Center'),
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
