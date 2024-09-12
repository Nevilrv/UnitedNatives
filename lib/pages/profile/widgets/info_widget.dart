import 'dart:developer';
import 'package:united_natives/viewModel/user_controller.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_city_response_model.dart';
import 'package:united_natives/newModel/apiModel/responseModel/get_states_response_model.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:united_natives/viewModel/get_city_view_model.dart';
import 'package:united_natives/viewModel/get_states_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'profile_info_tile.dart';

class InfoWidget extends StatefulWidget {
  const InfoWidget({super.key});

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  final UserController _userController = Get.find();

  final GetCitiesViewModel getCitiesViewModel = Get.put(GetCitiesViewModel());

  final GetStatesViewModel getStatesViewModel = Get.put(GetStatesViewModel());

  String cityName = '';
  String stateName = '';
  String stateID = '';

  bool getDataLoader = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getStateCityData();
    });

    super.initState();
  }

  getStateCityData() async {
    setState(() {
      getDataLoader = true;
    });
    await getStatesViewModel.getStatesViewModel();

    List<GetStatesResponseModel> data =
        getStatesViewModel.getStatesApiResponse.data;

    for (var element in data) {
      if (element.id.toString() ==
          _userController.user.value.state.toString()) {
        stateName = element.name!;
        stateID = element.id!;
      }
    }
    log('stateID==========>>>>>$stateID');
    await getCitiesViewModel.getCitiesViewModel(stateId: stateID);

    List<GetCityResponseModel> data1 =
        getCitiesViewModel.getCitiesApiResponse.data;
    log(' _userController.user.value.city.toString()==========>>>>>${_userController.user.value.city.toString()}');
    for (var e1 in data1) {
      if (e1.id.toString() == _userController.user.value.city.toString()) {
        log('e1.name==========>>>>>${e1.name}');
        cityName = e1.name!;
      }
    }
    setState(() {
      getDataLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text(
            Translate.of(context)!.translate('name_dot'),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            '${_userController.user.value.firstName} ${_userController.user.value.lastName}',
            style:
                Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 18),
          ),
          trailing: Obx(
            () => Utils().patientProfile(
                _userController.user.value.profilePic ??
                    _userController.user.value.socialProfilePic!,
                _userController.authResult?.user?.photoURL ?? "",
                32),
          ),
        ),
        Divider(
          height: 0.5,
          color: Colors.grey[200],
          indent: 15,
          endIndent: 15,
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('contact_number'),
          trailing: _userController.user.value.contactNumber!,
          hint: 'Add phone number',
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('email'),
          trailing: _userController.user.value.email!,
          hint: Translate.of(context)!.translate('add_email'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('gender'),
          trailing: _userController.user.value.gender!,
          hint: Translate.of(context)!.translate('add_gender'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('date_of_birth'),
          trailing: _userController.user.value.dateOfBirth!,
          hint: 'yyyy mm dd',
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('blood_group'),
          trailing: _userController.user.value.bloodGroup!,
          hint: Translate.of(context)!.translate('add_blood_group'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Allergies'),
          trailing: _userController.user.value.allergies!,
          hint: Translate.of(context)!.translate('Allergies'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('marital_status'),
          trailing: _userController.user.value.maritalStatus!,
          hint: Translate.of(context)!.translate('add_marital_status'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('height'),
          trailing: _userController.user.value.height!,
          hint: Translate.of(context)!.translate('add_height'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('weight'),
          trailing: _userController.user.value.weight!,
          hint: Translate.of(context)!.translate('add_weight'),
        ),
        ProfileInfoTile(
          title: 'Emergency contact',
          trailing: _userController.user.value.emergencyContact!,
          hint: 'Add emergency contact',
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Current case manager info'),
          trailing: _userController.user.value.currentCaseManagerInfo!,
          hint: Translate.of(context)!.translate('+1 52139784672'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Insurance Eligibility'),
          trailing: _userController.user.value.insuranceEligibility!,
          hint: Translate.of(context)!.translate('yes'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!
              .translate('State the name of your insurance'),
          trailing: _userController.user.value.insuranceCompanyName!.isEmpty
              ? "-"
              : _userController.user.value.insuranceCompanyName!,
          hint: Translate.of(context)!.translate(''),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Are you a US Veteran?'),
          trailing: _userController.user.value.usVeteranStatus!,
          hint: Translate.of(context)!.translate('yes'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Tribal Status'),
          trailing: _userController.user.value.tribalStatus!,
          hint: Translate.of(context)!.translate('No'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!
              .translate('Are you enrolled in a federally recognized tribe?'),
          trailing: _userController.user.value.tribalFederallyMember!.isEmpty
              ? "No"
              : "Yes",
          hint: Translate.of(context)!.translate('yes'),
        ),
        if (_userController.user.value.tribalFederallyMember!.isNotEmpty)
          ProfileInfoTile(
            title: Translate.of(context)!.translate('Tribal affiliation'),
            trailing: _userController.user.value.tribalFederallyMember!,
            hint: Translate.of(context)!.translate('Tribal affiliation'),
          ),
        ProfileInfoTile(
          title: Translate.of(context)!
              .translate('Are you enrolled in a State Recognized Tribe?'),
          trailing: _userController.user.value.tribalFederallyState!.isEmpty
              ? "No"
              : "Yes",
          hint: Translate.of(context)!.translate('yes'),
        ),
        if (_userController.user.value.tribalFederallyState!.isNotEmpty)
          ProfileInfoTile(
            title: Translate.of(context)!.translate('Tribal affiliation'),
            trailing: _userController.user.value.tribalFederallyState!,
            hint: Translate.of(context)!.translate('Tribal affiliation'),
          ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('Racial/ethnic background '),
          trailing: _userController.user.value.tribalBackgroundStatus!,
          hint: Translate.of(context)!.translate('yes'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('State'),
          // trailing: '${_userController.user.value.state}',
          trailing: stateName,
          hint: Translate.of(context)!.translate('Alabama'),
        ),
        ProfileInfoTile(
          title: Translate.of(context)!.translate('city'),
          // trailing: _userController.user.value.city,
          trailing: cityName.capitalizeFirst!,
          hint: Translate.of(context)!.translate('ADAK'),
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
